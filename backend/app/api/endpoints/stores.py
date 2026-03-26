"""
Store and Marketplace API endpoints
"""
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from pydantic import UUID4

from app.core.database import database
from app.api.dependencies.auth import get_current_user
from app.schemas.store import (
    StoreDetails, StoreDetailsCreate, StoreDetailsUpdate,
    StoreBranch, StoreBranchCreate, StoreBranchUpdate,
    StoreProduct, StoreProductCreate, StoreProductUpdate,
    StoreOrder, StoreOrderCreate, StoreOrderUpdate, OrderItem,
    UsedItem, UsedItemCreate, UsedItemUpdate
)

router = APIRouter(tags=["Stores & Marketplace"])


# ============================================
# PUBLIC LIST-ALL ENDPOINTS (must be before /{id} routes)
# ============================================

@router.get("/stores/all", response_model=List[StoreDetails])
async def get_all_stores():
    """Get all stores (public)"""
    result = await database.fetch_all(
        "SELECT * FROM store_details ORDER BY created_at DESC"
    )
    return result


# ============================================
# STORE DETAILS ENDPOINTS
# ============================================

@router.post("/stores/details", response_model=StoreDetails, status_code=status.HTTP_201_CREATED)
async def create_store_details(details: StoreDetailsCreate, current_user: dict = Depends(get_current_user)):
    """Create store details for the current user"""
    existing = await database.fetch_one(
        "SELECT user_id FROM store_details WHERE user_id = :user_id",
        {"user_id": current_user["id"]}
    )

    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Store details already exist"
        )

    query = """
        INSERT INTO store_details (
            user_id, store_name, description, website_url, license_number,
            shipping_available, accepts_returns, return_policy_days,
            created_at, updated_at
        ) VALUES (
            :user_id, :store_name, :description, :website_url, :license_number,
            :shipping_available, :accepts_returns, :return_policy_days,
            NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **details.dict()
    })

    return result


@router.get("/stores/details", response_model=StoreDetails)
async def get_my_store_details(current_user: dict = Depends(get_current_user)):
    """Get store details for the current user"""
    result = await database.fetch_one(
        "SELECT * FROM store_details WHERE user_id = :user_id",
        {"user_id": current_user["id"]}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Store details not found"
        )

    return result


@router.get("/stores/details/{user_id}", response_model=StoreDetails)
async def get_store_details(user_id: UUID4):
    """Get store details by user ID (public)"""
    result = await database.fetch_one(
        "SELECT * FROM store_details WHERE user_id = :user_id",
        {"user_id": str(user_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Store details not found"
        )

    return result


@router.put("/stores/details", response_model=StoreDetails)
async def update_store_details(details: StoreDetailsUpdate, current_user: dict = Depends(get_current_user)):
    """Update store details for the current user"""
    update_fields = {k: v for k, v in details.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE store_details
        SET {set_clause}, updated_at = NOW()
        WHERE user_id = :user_id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **update_fields
    })

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Store details not found"
        )

    return result


# ============================================
# STORE BRANCH ENDPOINTS
# ============================================

@router.post("/stores/branches", response_model=StoreBranch, status_code=status.HTTP_201_CREATED)
async def create_store_branch(branch: StoreBranchCreate, current_user: dict = Depends(get_current_user)):
    """Create a new store branch"""
    query = """
        INSERT INTO store_branches (
            user_id, location_name, governorate, city, location_url, branch_phone,
            opening_hour, opening_minute, opening_ampm, closing_hour, closing_minute,
            closing_ampm, delivery_options, created_at, updated_at
        ) VALUES (
            :user_id, :location_name, :governorate, :city, :location_url, :branch_phone,
            :opening_hour, :opening_minute, :opening_ampm, :closing_hour, :closing_minute,
            :closing_ampm, :delivery_options, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **branch.dict()
    })

    return result


@router.get("/stores/branches", response_model=List[StoreBranch])
async def get_my_store_branches(current_user: dict = Depends(get_current_user)):
    """Get all branches for the current user's store"""
    result = await database.fetch_all(
        "SELECT * FROM store_branches WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/stores/branches/store/{user_id}", response_model=List[StoreBranch])
async def get_store_branches(user_id: UUID4):
    """Get all branches for a specific store (public)"""
    result = await database.fetch_all(
        "SELECT * FROM store_branches WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": str(user_id)}
    )

    return result


@router.put("/stores/branches/{branch_id}", response_model=StoreBranch)
async def update_store_branch(branch_id: UUID4, branch: StoreBranchUpdate, current_user: dict = Depends(get_current_user)):
    """Update a store branch"""
    existing = await database.fetch_one(
        "SELECT user_id FROM store_branches WHERE id = :id",
        {"id": str(branch_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this branch"
        )

    update_fields = {k: v for k, v in branch.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE store_branches
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(branch_id),
        **update_fields
    })

    return result


@router.delete("/stores/branches/{branch_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_store_branch(branch_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a store branch"""
    existing = await database.fetch_one(
        "SELECT user_id FROM store_branches WHERE id = :id",
        {"id": str(branch_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this branch"
        )

    await database.execute(
        "DELETE FROM store_branches WHERE id = :id",
        {"id": str(branch_id)}
    )


# ============================================
# STORE PRODUCT ENDPOINTS
# ============================================

@router.post("/stores/products", response_model=StoreProduct, status_code=status.HTTP_201_CREATED)
async def create_product(product: StoreProductCreate, current_user: dict = Depends(get_current_user)):
    """Create a new store product"""
    query = """
        INSERT INTO store_products (
            user_id, name, brand, category, price, description,
            available_sizes, available_colors, photo_url, created_at, updated_at
        ) VALUES (
            :user_id, :name, :brand, :category, :price, :description,
            :available_sizes, :available_colors, :photo_url, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **product.dict()
    })

    return result


@router.get("/stores/products", response_model=List[StoreProduct])
async def get_my_products(current_user: dict = Depends(get_current_user)):
    """Get all products for the current user's store"""
    result = await database.fetch_all(
        "SELECT * FROM store_products WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/stores/products/store/{user_id}", response_model=List[StoreProduct])
async def get_store_products(user_id: UUID4):
    """Get all products for a specific store (public)"""
    result = await database.fetch_all(
        "SELECT * FROM store_products WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": str(user_id)}
    )

    return result


@router.get("/stores/products/{product_id}", response_model=StoreProduct)
async def get_product(product_id: UUID4):
    """Get a specific product by ID"""
    result = await database.fetch_one(
        "SELECT * FROM store_products WHERE id = :id",
        {"id": str(product_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )

    return result


@router.put("/stores/products/{product_id}", response_model=StoreProduct)
async def update_product(product_id: UUID4, product: StoreProductUpdate, current_user: dict = Depends(get_current_user)):
    """Update a store product"""
    existing = await database.fetch_one(
        "SELECT user_id FROM store_products WHERE id = :id",
        {"id": str(product_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this product"
        )

    update_fields = {k: v for k, v in product.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE store_products
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(product_id),
        **update_fields
    })

    return result


@router.delete("/stores/products/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_product(product_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a store product"""
    existing = await database.fetch_one(
        "SELECT user_id FROM store_products WHERE id = :id",
        {"id": str(product_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this product"
        )

    await database.execute(
        "DELETE FROM store_products WHERE id = :id",
        {"id": str(product_id)}
    )


# ============================================
# STORE ORDER ENDPOINTS
# ============================================

@router.post("/stores/orders", response_model=StoreOrder, status_code=status.HTTP_201_CREATED)
async def create_order(order: StoreOrderCreate, current_user: dict = Depends(get_current_user)):
    """Create a new store order"""
    # Calculate total amount
    total_amount = sum(item.subtotal for item in order.items)

    # Insert order
    order_query = """
        INSERT INTO store_orders (
            user_id, store_owner_id, branch_id, customer_name, customer_phone,
            delivery_address, delivery_type, total_amount, created_at, updated_at
        ) VALUES (
            :user_id, :store_owner_id, :branch_id, :customer_name, :customer_phone,
            :delivery_address, :delivery_type, :total_amount, NOW(), NOW()
        )
        RETURNING *
    """

    # TODO: Get store_owner_id from products or branch
    # For now, using current user (should be fixed in production)
    order_data = order.dict(exclude={'items'})
    order_data['user_id'] = current_user["id"]
    order_data['store_owner_id'] = current_user["id"]  # Should get from product
    order_data['total_amount'] = total_amount

    result = await database.fetch_one(order_query, order_data)

    # Insert order items
    for item in order.items:
        await database.execute("""
            INSERT INTO order_items (
                order_id, product_id, product_name, product_brand,
                selected_size, selected_color, unit_price, quantity, subtotal, created_at
            ) VALUES (
                :order_id, :product_id, :product_name, :product_brand,
                :selected_size, :selected_color, :unit_price, :quantity, :subtotal, NOW()
            )
        """, {
            "order_id": result["id"],
            **item.dict()
        })

    return result


@router.get("/stores/orders", response_model=List[StoreOrder])
async def get_my_orders(current_user: dict = Depends(get_current_user)):
    """Get all orders for the current user's store"""
    result = await database.fetch_all(
        "SELECT * FROM store_orders WHERE store_owner_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/stores/orders/{order_id}", response_model=StoreOrder)
async def get_order(order_id: int, current_user: dict = Depends(get_current_user)):
    """Get a specific order by ID"""
    result = await database.fetch_one("""
        SELECT * FROM store_orders
        WHERE id = :id AND store_owner_id = :user_id
    """, {"id": order_id, "user_id": current_user["id"]})

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found"
        )

    # Get order items
    items = await database.fetch_all(
        "SELECT * FROM order_items WHERE order_id = :order_id",
        {"order_id": order_id}
    )

    order_dict = dict(result)
    order_dict['items'] = [dict(item) for item in items]

    return order_dict


@router.put("/stores/orders/{order_id}", response_model=StoreOrder)
async def update_order(order_id: int, order: StoreOrderUpdate, current_user: dict = Depends(get_current_user)):
    """Update a store order"""
    existing = await database.fetch_one(
        "SELECT store_owner_id FROM store_orders WHERE id = :id",
        {"id": order_id}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found"
        )

    if str(existing["store_owner_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this order"
        )

    update_fields = {k: v for k, v in order.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE store_orders
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": order_id,
        **update_fields
    })

    return result


# ============================================
# MARKETPLACE (USED ITEMS) ENDPOINTS
# ============================================

@router.post("/marketplace/items", response_model=UsedItem, status_code=status.HTTP_201_CREATED)
async def create_used_item(item: UsedItemCreate, current_user: dict = Depends(get_current_user)):
    """Create a new used item listing"""
    query = """
        INSERT INTO used_items (
            seller_id, title, description, category, brand, condition, price,
            currency, is_negotiable, size, color, year_purchased, photos,
            contact_phone, contact_whatsapp, preferred_contact_method,
            city, governorate, created_at, updated_at
        ) VALUES (
            :seller_id, :title, :description, :category, :brand, :condition, :price,
            :currency, :is_negotiable, :size, :color, :year_purchased, :photos,
            :contact_phone, :contact_whatsapp, :preferred_contact_method,
            :city, :governorate, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "seller_id": current_user["id"],
        **item.dict()
    })

    return result


@router.get("/marketplace/items", response_model=List[UsedItem], response_model_by_alias=True)
async def get_used_items(
    category: Optional[str] = Query(None),
    condition: Optional[str] = Query(None),
    min_price: Optional[float] = Query(None),
    max_price: Optional[float] = Query(None),
    governorate: Optional[str] = Query(None),
    search: Optional[str] = Query(None)
):
    """Get all used items with optional filters (public)"""
    query = "SELECT * FROM used_items WHERE is_active = true AND is_sold = false"
    params = {}

    if category:
        query += " AND category = :category"
        params["category"] = category

    if condition:
        query += " AND condition = :condition"
        params["condition"] = condition

    if min_price is not None:
        query += " AND price >= :min_price"
        params["min_price"] = min_price

    if max_price is not None:
        query += " AND price <= :max_price"
        params["max_price"] = max_price

    if governorate:
        query += " AND governorate = :governorate"
        params["governorate"] = governorate

    if search:
        query += " AND (title ILIKE :search OR description ILIKE :search)"
        params["search"] = f"%{search}%"

    query += " ORDER BY created_at DESC"

    result = await database.fetch_all(query, params)

    return result


@router.get("/marketplace/items/my", response_model=List[UsedItem])
async def get_my_used_items(current_user: dict = Depends(get_current_user)):
    """Get all used items for the current user"""
    result = await database.fetch_all(
        "SELECT * FROM used_items WHERE seller_id = :seller_id ORDER BY created_at DESC",
        {"seller_id": current_user["id"]}
    )

    return result


@router.get("/marketplace/items/{item_id}", response_model=UsedItem)
async def get_used_item(item_id: UUID4):
    """Get a specific used item by ID"""
    # Increment view count
    await database.execute(
        "UPDATE used_items SET view_count = view_count + 1 WHERE id = :id",
        {"id": str(item_id)}
    )

    result = await database.fetch_one(
        "SELECT * FROM used_items WHERE id = :id",
        {"id": str(item_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Item not found"
        )

    return result


@router.put("/marketplace/items/{item_id}", response_model=UsedItem)
async def update_used_item(item_id: UUID4, item: UsedItemUpdate, current_user: dict = Depends(get_current_user)):
    """Update a used item"""
    existing = await database.fetch_one(
        "SELECT seller_id FROM used_items WHERE id = :id",
        {"id": str(item_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Item not found"
        )

    if str(existing["seller_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this item"
        )

    update_fields = {k: v for k, v in item.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    # If marking as sold, set sold_at timestamp
    if update_fields.get('is_sold'):
        update_fields['sold_at'] = 'NOW()'
        set_clause = ", ".join([f"{k} = :{k}" if k != 'sold_at' else "sold_at = NOW()" for k in update_fields.keys()])
        update_fields.pop('sold_at')
    else:
        set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])

    query = f"""
        UPDATE used_items
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(item_id),
        **update_fields
    })

    return result


@router.delete("/marketplace/items/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_used_item(item_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a used item"""
    existing = await database.fetch_one(
        "SELECT seller_id FROM used_items WHERE id = :id",
        {"id": str(item_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Item not found"
        )

    if str(existing["seller_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this item"
        )

    await database.execute(
        "DELETE FROM used_items WHERE id = :id",
        {"id": str(item_id)}
    )
