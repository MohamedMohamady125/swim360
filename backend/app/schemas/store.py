"""
Store and Marketplace-related Pydantic schemas
"""
from typing import Optional, List
from datetime import datetime, date
from pydantic import BaseModel, UUID4, Field
from decimal import Decimal


# ============================================
# STORE DETAILS SCHEMAS
# ============================================

class StoreDetailsBase(BaseModel):
    """Base store details schema"""
    store_name: str
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    shipping_available: Optional[bool] = True
    accepts_returns: Optional[bool] = True
    return_policy_days: Optional[int] = 30


class StoreDetailsCreate(StoreDetailsBase):
    """Create store details"""
    pass


class StoreDetailsUpdate(BaseModel):
    """Update store details"""
    store_name: Optional[str] = None
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    shipping_available: Optional[bool] = None
    accepts_returns: Optional[bool] = None
    return_policy_days: Optional[int] = None


class StoreDetails(StoreDetailsBase):
    """Store details response"""
    user_id: UUID4
    rating: Decimal
    total_reviews: int
    total_sales: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# STORE BRANCH SCHEMAS
# ============================================

class StoreBranchBase(BaseModel):
    """Base store branch schema"""
    location_name: str
    governorate: Optional[str] = None
    city: Optional[str] = None
    location_url: Optional[str] = None
    branch_phone: Optional[str] = None
    opening_hour: Optional[str] = None
    opening_minute: Optional[str] = None
    opening_ampm: Optional[str] = None
    closing_hour: Optional[str] = None
    closing_minute: Optional[str] = None
    closing_ampm: Optional[str] = None
    delivery_options: Optional[List[str]] = None


class StoreBranchCreate(StoreBranchBase):
    """Create store branch"""
    pass


class StoreBranchUpdate(BaseModel):
    """Update store branch"""
    location_name: Optional[str] = None
    governorate: Optional[str] = None
    city: Optional[str] = None
    location_url: Optional[str] = None
    branch_phone: Optional[str] = None
    opening_hour: Optional[str] = None
    opening_minute: Optional[str] = None
    opening_ampm: Optional[str] = None
    closing_hour: Optional[str] = None
    closing_minute: Optional[str] = None
    closing_ampm: Optional[str] = None
    delivery_options: Optional[List[str]] = None


class StoreBranch(StoreBranchBase):
    """Store branch response"""
    id: UUID4
    user_id: UUID4
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# STORE PRODUCT SCHEMAS
# ============================================

class StoreProductBase(BaseModel):
    """Base store product schema"""
    name: str
    brand: Optional[str] = None
    category: Optional[str] = None
    price: Optional[Decimal] = Decimal('0')
    description: Optional[str] = None
    available_sizes: Optional[List[str]] = None
    available_colors: Optional[List[str]] = None
    photo_url: Optional[str] = None


class StoreProductCreate(StoreProductBase):
    """Create store product"""
    pass


class StoreProductUpdate(BaseModel):
    """Update store product"""
    name: Optional[str] = None
    brand: Optional[str] = None
    category: Optional[str] = None
    price: Optional[Decimal] = None
    description: Optional[str] = None
    available_sizes: Optional[List[str]] = None
    available_colors: Optional[List[str]] = None
    photo_url: Optional[str] = None


class StoreProduct(StoreProductBase):
    """Store product response"""
    id: UUID4
    user_id: UUID4
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# ORDER ITEM SCHEMAS
# ============================================

class OrderItemBase(BaseModel):
    """Base order item schema"""
    product_id: UUID4
    product_name: str
    product_brand: Optional[str] = None
    selected_size: Optional[str] = None
    selected_color: Optional[str] = None
    unit_price: Decimal
    quantity: int
    subtotal: Decimal


class OrderItemCreate(OrderItemBase):
    """Create order item"""
    pass


class OrderItem(OrderItemBase):
    """Order item response"""
    id: UUID4
    order_id: UUID4
    created_at: datetime

    class Config:
        from_attributes = True


# ============================================
# STORE ORDER SCHEMAS
# ============================================

class StoreOrderBase(BaseModel):
    """Base store order schema"""
    customer_name: Optional[str] = None
    customer_phone: Optional[str] = None
    delivery_address: Optional[str] = None
    delivery_type: Optional[str] = None
    branch_id: Optional[UUID4] = None


class StoreOrderCreate(StoreOrderBase):
    """Create store order"""
    items: List[OrderItemCreate]


class StoreOrderUpdate(BaseModel):
    """Update store order"""
    customer_name: Optional[str] = None
    customer_phone: Optional[str] = None
    delivery_address: Optional[str] = None
    delivery_type: Optional[str] = None
    delivery_date: Optional[date] = None
    status: Optional[str] = None


class StoreOrder(StoreOrderBase):
    """Store order response"""
    id: int
    user_id: Optional[UUID4]
    store_owner_id: UUID4
    status: str
    total_amount: Decimal
    delivery_date: Optional[date]
    created_at: datetime
    updated_at: datetime
    items: Optional[List[OrderItem]] = None

    class Config:
        from_attributes = True


# ============================================
# USED ITEM (MARKETPLACE) SCHEMAS
# ============================================

class UsedItemBase(BaseModel):
    """Base used item schema"""
    title: str
    description: str
    category: str
    brand: Optional[str] = None
    condition: str
    price: Decimal
    currency: Optional[str] = "USD"
    is_negotiable: Optional[bool] = Field(True, alias="isNegotiable")
    size: Optional[str] = None
    color: Optional[str] = None
    year_purchased: Optional[int] = Field(None, alias="yearPurchased")
    photos: Optional[List[str]] = None
    contact_phone: str = Field(alias="contactPhone")
    contact_whatsapp: Optional[str] = Field(None, alias="contactWhatsapp")
    preferred_contact_method: Optional[str] = Field(None, alias="preferredContactMethod")
    city: Optional[str] = None
    governorate: Optional[str] = None


class UsedItemCreate(UsedItemBase):
    """Create used item"""
    pass


class UsedItemUpdate(BaseModel):
    """Update used item"""
    title: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    brand: Optional[str] = None
    condition: Optional[str] = None
    price: Optional[Decimal] = None
    currency: Optional[str] = None
    is_negotiable: Optional[bool] = None
    size: Optional[str] = None
    color: Optional[str] = None
    year_purchased: Optional[int] = None
    photos: Optional[List[str]] = None
    contact_phone: Optional[str] = None
    contact_whatsapp: Optional[str] = None
    preferred_contact_method: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    is_sold: Optional[bool] = None
    is_active: Optional[bool] = None


class UsedItem(UsedItemBase):
    """Used item response"""
    id: UUID4
    seller_id: UUID4 = Field(alias="sellerId")
    is_sold: bool = Field(alias="isSold")
    is_active: bool = Field(alias="isActive")
    view_count: int = Field(alias="viewCount")
    sold_at: Optional[datetime] = Field(None, alias="soldAt")
    created_at: datetime = Field(alias="createdAt")
    updated_at: datetime = Field(alias="updatedAt")

    class Config:
        from_attributes = True
        populate_by_name = True
        by_alias = True
        json_encoders = {
            datetime: lambda v: v.isoformat() if v else None,
            UUID4: lambda v: str(v),
            Decimal: lambda v: str(v)
        }
