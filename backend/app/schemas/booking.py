"""
Booking-related schemas
"""
from typing import Optional
from datetime import date, time
from decimal import Decimal
from pydantic import BaseModel, UUID4, Field
from app.schemas.common import BookingStatus, UserRole, PaymentStatus, TimestampMixin


class BookingCreate(BaseModel):
    """Create booking"""
    provider_id: UUID4
    provider_type: UserRole
    program_id: Optional[UUID4] = None
    service_id: Optional[UUID4] = None
    session_id: Optional[UUID4] = None
    branch_id: Optional[UUID4] = None
    booking_date: date
    booking_time: Optional[time] = None
    amount: Decimal = Field(ge=0)
    currency: str = "USD"
    swimmer_notes: Optional[str] = None


class BookingUpdate(BaseModel):
    """Update booking"""
    status: Optional[BookingStatus] = None
    booking_date: Optional[date] = None
    booking_time: Optional[time] = None
    swimmer_notes: Optional[str] = None
    provider_notes: Optional[str] = None


class BookingResponse(TimestampMixin):
    """Booking response"""
    id: UUID4
    swimmer_id: UUID4
    provider_id: UUID4
    provider_type: UserRole
    program_id: Optional[UUID4] = None
    service_id: Optional[UUID4] = None
    session_id: Optional[UUID4] = None
    branch_id: Optional[UUID4] = None
    booking_date: date
    booking_time: Optional[time] = None
    status: BookingStatus
    amount: Decimal
    currency: str
    swimmer_notes: Optional[str] = None
    provider_notes: Optional[str] = None
    confirmed_at: Optional[str] = None
    completed_at: Optional[str] = None
    cancelled_at: Optional[str] = None

    class Config:
        from_attributes = True


class BookingFilterParams(BaseModel):
    """Booking filter parameters"""
    status: Optional[BookingStatus] = None
    provider_id: Optional[UUID4] = None
    provider_type: Optional[UserRole] = None
    from_date: Optional[date] = None
    to_date: Optional[date] = None
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)
