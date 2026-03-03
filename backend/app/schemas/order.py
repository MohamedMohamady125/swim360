"""
Order and payment schemas
"""
from typing import Optional, List
from decimal import Decimal
from pydantic import BaseModel, UUID4, Field
from app.schemas.common import OrderStatus, PaymentStatus, PaymentMethod, TimestampMixin


class OrderItemCreate(BaseModel):
    """Order item"""
    product_id: UUID4
    selected_size: Optional[str] = None
    selected_color: Optional[str] = None
    quantity: int = Field(..., ge=1)


class OrderCreate(BaseModel):
    """Create order"""
    store_id: UUID4
    items: List[OrderItemCreate]
    delivery_governorate: str
    delivery_city: str
    delivery_address: str
    delivery_latitude: Optional[Decimal] = None
    delivery_longitude: Optional[Decimal] = None
    delivery_phone: str
    payment_method: PaymentMethod
    promo_code: Optional[str] = None
    customer_notes: Optional[str] = None


class OrderItemResponse(BaseModel):
    """Order item response"""
    id: UUID4
    order_id: UUID4
    product_id: UUID4
    product_name: str
    product_brand: Optional[str] = None
    selected_size: Optional[str] = None
    selected_color: Optional[str] = None
    unit_price: Decimal
    quantity: int
    subtotal: Decimal
    created_at: str

    class Config:
        from_attributes = True


class OrderResponse(TimestampMixin):
    """Order response"""
    id: UUID4
    order_number: str
    swimmer_id: UUID4
    store_id: UUID4
    status: OrderStatus
    delivery_governorate: str
    delivery_city: str
    delivery_address: str
    delivery_latitude: Optional[Decimal] = None
    delivery_longitude: Optional[Decimal] = None
    delivery_phone: str
    subtotal: Decimal
    delivery_fee: Decimal
    service_fee: Decimal
    discount_amount: Decimal
    total_amount: Decimal
    currency: str
    promo_code_used: Optional[str] = None
    payment_method: PaymentMethod
    payment_status: PaymentStatus
    customer_notes: Optional[str] = None
    internal_notes: Optional[str] = None
    confirmed_at: Optional[str] = None
    shipped_at: Optional[str] = None
    delivered_at: Optional[str] = None
    cancelled_at: Optional[str] = None

    # Include order items
    items: Optional[List[OrderItemResponse]] = None

    class Config:
        from_attributes = True


class OrderUpdateStatus(BaseModel):
    """Update order status"""
    status: OrderStatus
    internal_notes: Optional[str] = None


class OrderFilterParams(BaseModel):
    """Order filter parameters"""
    status: Optional[OrderStatus] = None
    store_id: Optional[UUID4] = None
    payment_status: Optional[PaymentStatus] = None
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)


class PromoCodeCreate(BaseModel):
    """Create promo code"""
    code: str = Field(..., min_length=3, max_length=50)
    discount_percentage: Optional[Decimal] = Field(None, ge=0, le=100)
    discount_fixed_amount: Optional[Decimal] = Field(None, ge=0)
    minimum_order_amount: Optional[Decimal] = Field(None, ge=0)
    max_uses: Optional[int] = Field(None, ge=1)
    max_uses_per_user: int = Field(1, ge=1)
    valid_from: Optional[str] = None
    valid_until: Optional[str] = None


class PromoCodeResponse(TimestampMixin):
    """Promo code response"""
    id: UUID4
    code: str
    created_by: UUID4
    discount_percentage: Optional[Decimal] = None
    discount_fixed_amount: Optional[Decimal] = None
    minimum_order_amount: Optional[Decimal] = None
    max_uses: Optional[int] = None
    current_uses: int
    max_uses_per_user: int
    valid_from: str
    valid_until: Optional[str] = None
    is_active: bool

    class Config:
        from_attributes = True


class PromoCodeValidateRequest(BaseModel):
    """Validate promo code"""
    code: str
    order_amount: Decimal


class PromoCodeValidateResponse(BaseModel):
    """Promo code validation response"""
    valid: bool
    discount_amount: Optional[Decimal] = None
    message: Optional[str] = None
