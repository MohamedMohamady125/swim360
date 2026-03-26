"""
Event-related schemas
"""
from typing import Optional, List
from datetime import date, time
from decimal import Decimal
from pydantic import BaseModel, UUID4, Field
from app.schemas.common import EventType, PaymentStatus, TimestampMixin


class EventBase(BaseModel):
    """Base event information"""
    event_name: str
    event_type: EventType
    description: str
    event_date: date
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    venue_name: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    is_online: bool = False
    online_meeting_url: Optional[str] = None
    max_participants: Optional[int] = Field(None, ge=1)
    registration_fee: Decimal = Field(0, ge=0)
    registration_deadline: Optional[date] = None


class EventCreate(EventBase):
    """Create event"""
    cover_photo_url: Optional[str] = None
    gallery_photos: Optional[List[str]] = None


class EventUpdate(BaseModel):
    """Update event (all fields optional)"""
    event_name: Optional[str] = None
    event_type: Optional[EventType] = None
    description: Optional[str] = None
    event_date: Optional[date] = None
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    venue_name: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    is_online: Optional[bool] = None
    online_meeting_url: Optional[str] = None
    max_participants: Optional[int] = Field(None, ge=1)
    registration_fee: Optional[Decimal] = Field(None, ge=0)
    registration_deadline: Optional[date] = None
    cover_photo_url: Optional[str] = None
    gallery_photos: Optional[List[str]] = None
    is_active: Optional[bool] = None
    is_featured: Optional[bool] = None


class EventResponse(EventBase, TimestampMixin):
    """Event response"""
    id: UUID4
    organizer_id: UUID4
    cover_photo_url: Optional[str] = None
    gallery_photos: List[str] = []
    current_participants: int
    is_active: bool
    is_featured: bool

    class Config:
        from_attributes = True


class EventListResponse(BaseModel):
    """List of events"""
    total: int
    events: List[EventResponse]


class EventFilterParams(BaseModel):
    """Event filter parameters"""
    event_type: Optional[EventType] = None
    organizer_id: Optional[UUID4] = None
    from_date: Optional[date] = None
    to_date: Optional[date] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    is_online: Optional[bool] = None
    is_featured: Optional[bool] = None
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)


class EventRegistrationCreate(BaseModel):
    """Register for event"""
    event_id: UUID4


class EventRegistrationResponse(TimestampMixin):
    """Event registration response"""
    id: UUID4
    event_id: UUID4
    user_id: UUID4
    registration_date: str
    payment_status: PaymentStatus
    amount_paid: Optional[Decimal] = None
    checked_in: bool
    checked_in_at: Optional[str] = None
    is_cancelled: bool
    cancelled_at: Optional[str] = None

    class Config:
        from_attributes = True
