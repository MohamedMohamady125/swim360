"""
Review and rating schemas
"""
from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel, UUID4, Field, field_validator
from app.schemas.common import TimestampMixin


class ReviewCreate(BaseModel):
    """Create review"""
    target_id: UUID4
    target_type: str = Field(..., pattern="^(program|service|product|event|academy|clinic|coach|store|event_organizer)$")
    rating: int = Field(..., ge=1, le=5, description="Rating from 1 to 5")
    title: Optional[str] = Field(None, max_length=200)
    comment: Optional[str] = None
    photos: Optional[List[str]] = None


class ReviewUpdate(BaseModel):
    """Update review"""
    rating: Optional[int] = Field(None, ge=1, le=5)
    title: Optional[str] = Field(None, max_length=200)
    comment: Optional[str] = None
    photos: Optional[List[str]] = None


class ReviewResponse(TimestampMixin):
    """Review response"""
    id: UUID4
    reviewer_id: UUID4
    target_id: UUID4
    target_type: str
    rating: int
    title: Optional[str] = None
    comment: Optional[str] = None
    photos: List[str] = []
    is_verified_purchase: bool = False
    is_active: bool = True
    is_flagged: bool = False

    # Optional: include reviewer details
    reviewer_name: Optional[str] = None
    reviewer_photo: Optional[str] = None

    @field_validator('photos', mode='before')
    @classmethod
    def coerce_none_to_list(cls, v):
        return v if v is not None else []

    class Config:
        from_attributes = True


class ReviewListResponse(BaseModel):
    """List of reviews"""
    total: int
    average_rating: float
    reviews: List[ReviewResponse]


class ReviewFilterParams(BaseModel):
    """Review filter parameters"""
    target_id: Optional[UUID4] = None
    target_type: Optional[str] = None
    min_rating: Optional[int] = Field(None, ge=1, le=5)
    verified_only: bool = False
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)


class FavoriteCreate(BaseModel):
    """Add to favorites"""
    item_id: UUID4
    item_type: str = Field(..., pattern="^(program|service|product|event|academy|clinic|coach|store)$")


class FavoriteResponse(BaseModel):
    """Favorite response"""
    id: UUID4
    user_id: UUID4
    item_id: UUID4
    item_type: str
    created_at: datetime

    class Config:
        from_attributes = True


class NotificationResponse(BaseModel):
    """Notification response"""
    id: UUID4
    user_id: UUID4
    type: str
    title: str
    message: str
    action_url: Optional[str] = None
    related_id: Optional[UUID4] = None
    related_type: Optional[str] = None
    is_read: bool
    read_at: Optional[datetime] = None
    created_at: datetime

    class Config:
        from_attributes = True


class NotificationListResponse(BaseModel):
    """List of notifications"""
    total: int
    unread_count: int
    notifications: List[NotificationResponse]
