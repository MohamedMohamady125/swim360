"""
Service-related schemas (clinics)
"""
from typing import Optional, List
from decimal import Decimal
from pydantic import BaseModel, UUID4, Field
from app.schemas.common import ServiceCategory, TimestampMixin


class ServiceBase(BaseModel):
    """Base service information"""
    service_name: str
    category: ServiceCategory
    description: str
    price: Decimal = Field(ge=0, description="Service price")
    duration_minutes: int = Field(ge=1, description="Service duration in minutes")
    currency: str = "USD"


class ServiceCreate(ServiceBase):
    """Create service"""
    cover_photo_url: Optional[str] = None
    intro_video_url: Optional[str] = None


class ServiceUpdate(BaseModel):
    """Update service (all fields optional)"""
    service_name: Optional[str] = None
    category: Optional[ServiceCategory] = None
    description: Optional[str] = None
    price: Optional[Decimal] = Field(None, ge=0)
    duration_minutes: Optional[int] = Field(None, ge=1)
    currency: Optional[str] = None
    cover_photo_url: Optional[str] = None
    intro_video_url: Optional[str] = None
    is_active: Optional[bool] = None


class ServiceResponse(ServiceBase, TimestampMixin):
    """Service response"""
    id: UUID4
    clinic_id: UUID4
    cover_photo_url: Optional[str] = None
    intro_video_url: Optional[str] = None
    is_active: bool
    rating: Decimal
    total_reviews: int
    total_bookings: int

    class Config:
        from_attributes = True


class ServiceListResponse(BaseModel):
    """List of services"""
    total: int
    services: List[ServiceResponse]


class ServiceFilterParams(BaseModel):
    """Service filter parameters"""
    category: Optional[ServiceCategory] = None
    clinic_id: Optional[UUID4] = None
    min_price: Optional[Decimal] = Field(None, ge=0)
    max_price: Optional[Decimal] = Field(None, ge=0)
    city: Optional[str] = None
    governorate: Optional[str] = None
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)
