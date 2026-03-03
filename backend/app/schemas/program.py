"""
Program-related schemas (academies and coaches)
"""
from typing import Optional, List
from decimal import Decimal
from pydantic import BaseModel, UUID4, Field
from app.schemas.common import ProgramCategory, UserRole, TimestampMixin


class ProgramBase(BaseModel):
    """Base program information"""
    program_name: str
    category: ProgramCategory
    description: str
    duration_weeks: int = Field(ge=1, description="Total program duration in weeks")
    sessions_per_week: int = Field(ge=1, description="Number of sessions per week")
    session_duration_minutes: int = Field(ge=1, description="Duration of each session in minutes")
    price: Decimal = Field(ge=0, description="Program price")
    currency: str = "USD"
    max_participants: Optional[int] = Field(None, ge=1, description="Maximum participants")


class ProgramCreate(ProgramBase):
    """Create program"""
    cover_photo_url: Optional[str] = None
    intro_video_url: Optional[str] = None


class ProgramUpdate(BaseModel):
    """Update program (all fields optional)"""
    program_name: Optional[str] = None
    category: Optional[ProgramCategory] = None
    description: Optional[str] = None
    duration_weeks: Optional[int] = Field(None, ge=1)
    sessions_per_week: Optional[int] = Field(None, ge=1)
    session_duration_minutes: Optional[int] = Field(None, ge=1)
    price: Optional[Decimal] = Field(None, ge=0)
    currency: Optional[str] = None
    cover_photo_url: Optional[str] = None
    intro_video_url: Optional[str] = None
    max_participants: Optional[int] = Field(None, ge=1)
    is_active: Optional[bool] = None
    is_featured: Optional[bool] = None


class ProgramResponse(ProgramBase, TimestampMixin):
    """Program response"""
    id: UUID4
    provider_id: UUID4
    provider_type: UserRole
    cover_photo_url: Optional[str] = None
    intro_video_url: Optional[str] = None
    current_participants: int
    is_active: bool
    is_featured: bool
    rating: Decimal
    total_reviews: int
    total_enrollments: int

    class Config:
        from_attributes = True


class ProgramListResponse(BaseModel):
    """List of programs"""
    total: int
    programs: List[ProgramResponse]


class ProgramEnrollmentCreate(BaseModel):
    """Enroll in program"""
    program_id: UUID4
    start_date: str


class ProgramEnrollmentResponse(BaseModel):
    """Program enrollment response"""
    id: UUID4
    swimmer_id: UUID4
    program_id: UUID4
    start_date: str
    end_date: Optional[str] = None
    is_active: bool
    amount_paid: Decimal
    payment_status: str
    sessions_attended: int
    sessions_total: Optional[int] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class ProgramFilterParams(BaseModel):
    """Program filter parameters"""
    category: Optional[ProgramCategory] = None
    provider_type: Optional[UserRole] = None
    min_price: Optional[Decimal] = Field(None, ge=0)
    max_price: Optional[Decimal] = Field(None, ge=0)
    city: Optional[str] = None
    governorate: Optional[str] = None
    is_featured: Optional[bool] = None
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)
