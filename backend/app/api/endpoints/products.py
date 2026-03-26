"""
Product, cart, and marketplace endpoints
"""
from typing import List, Optional
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user, require_store, get_current_user_optional
from app.schemas.product import *
from app.schemas.common import UserRole

router = APIRouter(prefix="/products", tags=["Products & Marketplace"])


@router.get("", response_model=ProductListResponse)
async def list_products(
    category: Optional[ProductCategory] = None,
    store_id: Optional[str] = None,
    brand: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    in_stock_only: bool = False,
    is_featured: Optional[bool] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100)
):
    """List all products with filters"""
    conditions = ["is_active = true"]
    params = {}

    if category:
        conditions.append("category = :category")
        params["category"] = category.value

    if store_id:
        conditions.append("store_id = :store_id")
        params["store_id"] = store_id

    if brand:
        conditions.append("brand ILIKE :brand")
        params["brand"] = f"%{brand}%"

    if min_price is not None:
        conditions.append("price >= :min_price")
        params["min_price"] = min_price

    if max_price is not None:
        conditions.append("price <= :max_price")
        params["max_price"] = max_price

    if in_stock_only:
        conditions.append("total_stock > 0")

    if is_featured is not None:
        conditions.append("is_featured = :is_featured")
        params["is_featured"] = is_featured

    where_clause = " AND ".join(conditions)

    count_query = f"SELECT COUNT(*) as count FROM products WHERE {where_clause}"
    count_result = await database.fetch_one(count_query, params)
    total = count_result["count"]

    params["skip"] = skip
    params["limit"] = limit

    query = f"""
        SELECT * FROM products
        WHERE {where_clause}
        ORDER BY is_featured DESC, created_at DESC
        LIMIT :limit OFFSET :skip
    """

    products = await database.fetch_all(query, params)

    return ProductListResponse(
        total=total,
        products=[dict(p) for p in products]
    )


@router.post("", response_model=ProductResponse, status_code=status.HTTP_201_CREATED)
async def create_product(
    product: ProductCreate,
    current_user: dict = Depends(require_store)
):
    """Create a new product (Store only)"""
    query = """
        INSERT INTO products (
            store_id, product_name, category, brand, description, price, currency,
            discount_percentage, photos, intro_video_url, available_colors,
            available_sizes, total_stock, created_at, updated_at
        ) VALUES (
            :store_id, :product_name, :category, :brand, :description, :price, :currency,
            :discount_percentage, :photos, :intro_video_url, :available_colors,
            :available_sizes, :total_stock, NOW(), NOW()
        ) RETURNING *
    """

    values = product.dict()
    values["store_id"] = current_user["id"]

    new_product = await database.fetch_one(query=query, values=values)
    return dict(new_product)


@router.get("/{product_id}", response_model=ProductResponse)
async def get_product(product_id: str):
    """Get a single product by ID"""
    product = await database.fetch_one(
        "SELECT * FROM products WHERE id = :product_id AND is_active = true",
        {"product_id": product_id}
    )

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    return dict(product)


@router.put("/{product_id}", response_model=ProductResponse)
async def update_product(
    product_id: str,
    updates: ProductUpdate,
    current_user: dict = Depends(require_store)
):
    """Update a product (owner only)"""
    existing = await database.fetch_one(
        "SELECT * FROM products WHERE id = :product_id AND store_id = :user_id",
        {"product_id": product_id, "user_id": current_user["id"]}
    )

    if not existing:
        raise HTTPException(status_code=404, detail="Product not found or access denied")

    update_data = updates.dict(exclude_unset=True)
    if not update_data:
        return dict(existing)

    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE products SET {set_clause}, updated_at = NOW() WHERE id = :product_id RETURNING *"
    update_data["product_id"] = product_id

    updated_product = await database.fetch_one(query=query, values=update_data)
    return dict(updated_product)


@router.delete("/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_product(
    product_id: str,
    current_user: dict = Depends(require_store)
):
    """Delete a product (store owner only)"""
    result = await database.execute(
        "DELETE FROM products WHERE id = :product_id AND store_id = :user_id",
        {"product_id": product_id, "user_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Product not found or access denied")


# ==================== CART ====================

@router.get("/cart", response_model=CartResponse)
async def get_cart(current_user: dict = Depends(get_current_user)):
    """Get current user's shopping cart"""
    items = await database.fetch_all(
        """
        SELECT ci.*, p.* FROM cart_items ci
        JOIN products p ON ci.product_id = p.id
        WHERE ci.swimmer_id = :swimmer_id
        ORDER BY ci.created_at DESC
        """,
        {"swimmer_id": current_user["id"]}
    )

    cart_items = []
    subtotal = 0

    for item in items:
        cart_items.append(dict(item))
        subtotal += float(item["price_at_add"]) * item["quantity"]

    return CartResponse(
        items=cart_items,
        total_items=len(cart_items),
        subtotal=subtotal
    )


@router.post("/cart", response_model=CartItemResponse)
async def add_to_cart(
    item: CartItemCreate,
    current_user: dict = Depends(get_current_user)
):
    """Add item to cart"""
    if current_user["role"] != UserRole.SWIMMER.value:
        raise HTTPException(status_code=403, detail="Only swimmers can add items to cart")

    # Get product details
    product = await database.fetch_one(
        "SELECT * FROM products WHERE id = :product_id AND is_active = true",
        {"product_id": item.product_id}
    )

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Check if already in cart
    existing = await database.fetch_one(
        """
        SELECT * FROM cart_items
        WHERE swimmer_id = :swimmer_id AND product_id = :product_id
        AND selected_size = :selected_size AND selected_color = :selected_color
        """,
        {
            "swimmer_id": current_user["id"],
            "product_id": item.product_id,
            "selected_size": item.selected_size,
            "selected_color": item.selected_color
        }
    )

    if existing:
        # Update quantity
        updated = await database.fetch_one(
            """
            UPDATE cart_items SET quantity = quantity + :quantity, updated_at = NOW()
            WHERE id = :cart_id
            RETURNING *
            """,
            {"cart_id": existing["id"], "quantity": item.quantity}
        )
        return dict(updated)

    # Add new item
    query = """
        INSERT INTO cart_items (
            swimmer_id, product_id, store_id, branch_id, selected_size,
            selected_color, quantity, price_at_add, created_at, updated_at
        ) VALUES (
            :swimmer_id, :product_id, :store_id, :branch_id, :selected_size,
            :selected_color, :quantity, :price_at_add, NOW(), NOW()
        ) RETURNING *
    """

    new_item = await database.fetch_one(
        query=query,
        values={
            **item.dict(),
            "swimmer_id": current_user["id"],
            "store_id": product["store_id"],
            "price_at_add": product["price"]
        }
    )

    return dict(new_item)


@router.delete("/cart/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_from_cart(
    item_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Remove item from cart"""
    result = await database.execute(
        "DELETE FROM cart_items WHERE id = :item_id AND swimmer_id = :swimmer_id",
        {"item_id": item_id, "swimmer_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Cart item not found")
