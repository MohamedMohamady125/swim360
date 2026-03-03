"""
Order management endpoints
"""
from typing import List
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user, require_store
from app.schemas.order import *
import uuid

router = APIRouter(prefix="/orders", tags=["Orders"])


@router.get("", response_model=List[OrderResponse])
async def list_orders(
    status_filter: Optional[OrderStatus] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """List orders for current user (as swimmer or store)"""
    conditions = ["(swimmer_id = :user_id OR store_id = :user_id)"]
    params = {"user_id": current_user["id"]}

    if status_filter:
        conditions.append("status = :status")
        params["status"] = status_filter.value

    where_clause = " AND ".join(conditions)
    params["skip"] = skip
    params["limit"] = limit

    query = f"""
        SELECT * FROM orders
        WHERE {where_clause}
        ORDER BY created_at DESC
        LIMIT :limit OFFSET :skip
    """

    orders = await database.fetch_all(query, params)
    return [dict(o) for o in orders]


@router.get("/{order_id}", response_model=OrderResponse)
async def get_order(
    order_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Get order details with items"""
    order = await database.fetch_one(
        "SELECT * FROM orders WHERE id = :order_id AND (swimmer_id = :user_id OR store_id = :user_id)",
        {"order_id": order_id, "user_id": current_user["id"]}
    )

    if not order:
        raise HTTPException(status_code=404, detail="Order not found or access denied")

    # Fetch order items
    items = await database.fetch_all(
        "SELECT * FROM order_items WHERE order_id = :order_id",
        {"order_id": order_id}
    )

    order_dict = dict(order)
    order_dict["items"] = [dict(item) for item in items]

    return order_dict


@router.post("", response_model=OrderResponse, status_code=status.HTTP_201_CREATED)
async def create_order(
    order_data: OrderCreate,
    current_user: dict = Depends(get_current_user)
):
    """Create a new order from cart"""
    if not order_data.items:
        raise HTTPException(status_code=400, detail="Order must contain at least one item")

    # Generate order number
    order_number = f"ORD-{uuid.uuid4().hex[:8].upper()}"

    # Calculate totals
    subtotal = 0
    for item in order_data.items:
        product = await database.fetch_one(
            "SELECT price FROM products WHERE id = :product_id",
            {"product_id": item.product_id}
        )
        if not product:
            raise HTTPException(status_code=404, detail=f"Product {item.product_id} not found")

        subtotal += float(product["price"]) * item.quantity

    # Apply service fee and delivery fee
    service_fee = subtotal * 0.05  # 5% service fee
    delivery_fee = 50.0  # Fixed delivery fee

    # Apply promo code if provided
    discount_amount = 0
    if order_data.promo_code:
        promo = await database.fetch_one(
            """
            SELECT * FROM promo_codes
            WHERE code = :code AND is_active = true
            AND (valid_until IS NULL OR valid_until > NOW())
            AND (max_uses IS NULL OR current_uses < max_uses)
            """,
            {"code": order_data.promo_code}
        )

        if promo:
            if promo["discount_percentage"]:
                discount_amount = subtotal * (float(promo["discount_percentage"]) / 100)
            elif promo["discount_fixed_amount"]:
                discount_amount = float(promo["discount_fixed_amount"])

    total_amount = subtotal + service_fee + delivery_fee - discount_amount

    # Create order
    order_query = """
        INSERT INTO orders (
            order_number, swimmer_id, store_id, delivery_governorate, delivery_city,
            delivery_address, delivery_latitude, delivery_longitude, delivery_phone,
            subtotal, delivery_fee, service_fee, discount_amount, total_amount,
            currency, payment_method, promo_code_used, customer_notes,
            created_at, updated_at
        ) VALUES (
            :order_number, :swimmer_id, :store_id, :delivery_governorate, :delivery_city,
            :delivery_address, :delivery_latitude, :delivery_longitude, :delivery_phone,
            :subtotal, :delivery_fee, :service_fee, :discount_amount, :total_amount,
            'USD', :payment_method, :promo_code_used, :customer_notes,
            NOW(), NOW()
        ) RETURNING *
    """

    new_order = await database.fetch_one(
        query=order_query,
        values={
            "order_number": order_number,
            "swimmer_id": current_user["id"],
            "store_id": order_data.store_id,
            "delivery_governorate": order_data.delivery_governorate,
            "delivery_city": order_data.delivery_city,
            "delivery_address": order_data.delivery_address,
            "delivery_latitude": order_data.delivery_latitude,
            "delivery_longitude": order_data.delivery_longitude,
            "delivery_phone": order_data.delivery_phone,
            "subtotal": subtotal,
            "delivery_fee": delivery_fee,
            "service_fee": service_fee,
            "discount_amount": discount_amount,
            "total_amount": total_amount,
            "payment_method": order_data.payment_method.value,
            "promo_code_used": order_data.promo_code,
            "customer_notes": order_data.customer_notes
        }
    )

    # Create order items
    for item in order_data.items:
        product = await database.fetch_one(
            "SELECT * FROM products WHERE id = :product_id",
            {"product_id": item.product_id}
        )

        item_subtotal = float(product["price"]) * item.quantity

        await database.execute(
            """
            INSERT INTO order_items (
                order_id, product_id, product_name, product_brand,
                selected_size, selected_color, unit_price, quantity, subtotal,
                created_at
            ) VALUES (
                :order_id, :product_id, :product_name, :product_brand,
                :selected_size, :selected_color, :unit_price, :quantity, :subtotal,
                NOW()
            )
            """,
            {
                "order_id": new_order["id"],
                "product_id": product["id"],
                "product_name": product["product_name"],
                "product_brand": product["brand"],
                "selected_size": item.selected_size,
                "selected_color": item.selected_color,
                "unit_price": product["price"],
                "quantity": item.quantity,
                "subtotal": item_subtotal
            }
        )

    # Clear cart after order
    await database.execute(
        "DELETE FROM cart_items WHERE swimmer_id = :swimmer_id",
        {"swimmer_id": current_user["id"]}
    )

    return dict(new_order)


@router.put("/{order_id}/status", response_model=OrderResponse)
async def update_order_status(
    order_id: str,
    status_update: OrderUpdateStatus,
    current_user: dict = Depends(require_store)
):
    """Update order status (Store only)"""
    # Check ownership
    order = await database.fetch_one(
        "SELECT * FROM orders WHERE id = :order_id AND store_id = :user_id",
        {"order_id": order_id, "user_id": current_user["id"]}
    )

    if not order:
        raise HTTPException(status_code=404, detail="Order not found or access denied")

    # Update with timestamp
    timestamp_field = {
        OrderStatus.CONFIRMED: "confirmed_at",
        OrderStatus.SHIPPED: "shipped_at",
        OrderStatus.DELIVERED: "delivered_at",
        OrderStatus.CANCELLED: "cancelled_at",
    }.get(status_update.status)

    query = f"""
        UPDATE orders
        SET status = :status, internal_notes = :internal_notes, {timestamp_field} = NOW(), updated_at = NOW()
        WHERE id = :order_id
        RETURNING *
    """ if timestamp_field else """
        UPDATE orders
        SET status = :status, internal_notes = :internal_notes, updated_at = NOW()
        WHERE id = :order_id
        RETURNING *
    """

    updated_order = await database.fetch_one(
        query,
        {
            "order_id": order_id,
            "status": status_update.status.value,
            "internal_notes": status_update.internal_notes
        }
    )

    return dict(updated_order)
