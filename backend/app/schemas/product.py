"""
Product and e-commerce schemas
"""
from typing import Optional, List
from decimal import Decimal
from pydantic import BaseModel, UUID4, Field, field_validator
from app.schemas.common import ProductCategory, ProductCondition, TimestampMixin


class ProductBase(BaseModel):
    """Base product information"""
    product_name: str
    category: ProductCategory
    brand: Optional[str] = None
    description: str
    price: Decimal = Field(ge=0, description="Product price")
    currency: str = "USD"
    discount_percentage: Decimal = Field(0, ge=0, le=100)


class ProductCreate(ProductBase):
    """Create product"""
    photos: Optional[List[str]] = None
    intro_video_url: Optional[str] = None
    available_colors: Optional[List[str]] = None
    available_sizes: Optional[List[str]] = None
    total_stock: int = Field(0, ge=0)


class ProductUpdate(BaseModel):
    """Update product (all fields optional)"""
    product_name: Optional[str] = None
    category: Optional[ProductCategory] = None
    brand: Optional[str] = None
    description: Optional[str] = None
    price: Optional[Decimal] = Field(None, ge=0)
    currency: Optional[str] = None
    discount_percentage: Optional[Decimal] = Field(None, ge=0, le=100)
    photos: Optional[List[str]] = None
    intro_video_url: Optional[str] = None
    available_colors: Optional[List[str]] = None
    available_sizes: Optional[List[str]] = None
    total_stock: Optional[int] = Field(None, ge=0)
    is_active: Optional[bool] = None
    is_featured: Optional[bool] = None


class ProductResponse(ProductBase, TimestampMixin):
    """Product response"""
    id: UUID4
    store_id: UUID4
    photos: List[str] = []
    intro_video_url: Optional[str] = None
    available_colors: List[str] = []
    available_sizes: List[str] = []
    total_stock: int
    low_stock_threshold: int = 0
    is_active: bool
    is_featured: bool
    rating: Decimal = 0
    total_reviews: int = 0
    total_sales: int = 0
    view_count: int = 0
    slug: Optional[str] = None

    @field_validator('photos', 'available_colors', 'available_sizes', mode='before')
    @classmethod
    def coerce_none_to_list(cls, v):
        return v if v is not None else []

    class Config:
        from_attributes = True


class ProductListResponse(BaseModel):
    """List of products"""
    total: int
    products: List[ProductResponse]


class ProductFilterParams(BaseModel):
    """Product filter parameters"""
    category: Optional[ProductCategory] = None
    store_id: Optional[UUID4] = None
    brand: Optional[str] = None
    min_price: Optional[Decimal] = Field(None, ge=0)
    max_price: Optional[Decimal] = Field(None, ge=0)
    in_stock_only: bool = False
    is_featured: Optional[bool] = None
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)


class CartItemCreate(BaseModel):
    """Add item to cart"""
    product_id: UUID4
    branch_id: Optional[UUID4] = None
    selected_size: Optional[str] = None
    selected_color: Optional[str] = None
    quantity: int = Field(1, ge=1)


class CartItemUpdate(BaseModel):
    """Update cart item"""
    quantity: int = Field(..., ge=1)


class CartItemResponse(BaseModel):
    """Cart item response"""
    id: UUID4
    swimmer_id: UUID4
    product_id: UUID4
    store_id: UUID4
    branch_id: Optional[UUID4] = None
    selected_size: Optional[str] = None
    selected_color: Optional[str] = None
    quantity: int
    price_at_add: Decimal
    created_at: str
    updated_at: str

    # Include product details
    product: ProductResponse

    class Config:
        from_attributes = True


class CartResponse(BaseModel):
    """Shopping cart response"""
    items: List[CartItemResponse]
    total_items: int
    subtotal: Decimal


class UsedItemCreate(BaseModel):
    """Create used item listing"""
    title: str
    description: str
    category: ProductCategory
    brand: Optional[str] = None
    condition: ProductCondition
    price: Decimal = Field(ge=0)
    currency: str = "USD"
    is_negotiable: bool = True
    size: Optional[str] = None
    color: Optional[str] = None
    year_purchased: Optional[int] = None
    photos: Optional[List[str]] = None
    contact_phone: str
    contact_whatsapp: Optional[str] = None
    preferred_contact_method: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None


class UsedItemUpdate(BaseModel):
    """Update used item listing"""
    title: Optional[str] = None
    description: Optional[str] = None
    category: Optional[ProductCategory] = None
    brand: Optional[str] = None
    condition: Optional[ProductCondition] = None
    price: Optional[Decimal] = Field(None, ge=0)
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


class UsedItemResponse(UsedItemCreate, TimestampMixin):
    """Used item response"""
    id: UUID4
    seller_id: UUID4
    is_sold: bool
    is_active: bool
    view_count: int
    sold_at: Optional[str] = None

    class Config:
        from_attributes = True


class UsedItemFilterParams(BaseModel):
    """Used item filter parameters"""
    category: Optional[ProductCategory] = None
    condition: Optional[ProductCondition] = None
    min_price: Optional[Decimal] = Field(None, ge=0)
    max_price: Optional[Decimal] = Field(None, ge=0)
    city: Optional[str] = None
    governorate: Optional[str] = None
    available_only: bool = True
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)
