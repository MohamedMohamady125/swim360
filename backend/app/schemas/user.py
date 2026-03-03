"""
User and profile schemas
"""
from typing import Optional, List
from datetime import datetime, date
from decimal import Decimal
from pydantic import BaseModel, EmailStr, Field, UUID4
from app.schemas.common import UserRole, TimestampMixin


# ==================== PROFILE SCHEMAS ====================

class ProfileBase(BaseModel):
    """Base profile information"""
    full_name: str
    phone: Optional[str] = None
    whatsapp_number: Optional[str] = None
    bio: Optional[str] = None
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None


class ProfileCreate(ProfileBase):
    """Create profile"""
    role: UserRole


class ProfileUpdate(BaseModel):
    """Update profile (all fields optional)"""
    full_name: Optional[str] = None
    phone: Optional[str] = None
    whatsapp_number: Optional[str] = None
    profile_photo_url: Optional[str] = None
    bio: Optional[str] = None
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    language: Optional[str] = None
    notifications_enabled: Optional[bool] = None
    email_notifications_enabled: Optional[bool] = None


class ProfileResponse(ProfileBase, TimestampMixin):
    """Profile response"""
    id: UUID4
    role: UserRole
    email: EmailStr
    profile_photo_url: Optional[str] = None
    language: str
    notifications_enabled: bool
    email_notifications_enabled: bool
    is_verified: bool
    is_active: bool
    onboarding_completed: bool

    class Config:
        from_attributes = True


# ==================== ROLE-SPECIFIC DETAILS ====================

class AcademyDetailsCreate(BaseModel):
    """Create academy details"""
    academy_name: str
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    established_year: Optional[int] = None


class AcademyDetailsUpdate(BaseModel):
    """Update academy details"""
    academy_name: Optional[str] = None
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    established_year: Optional[int] = None


class AcademyDetailsResponse(AcademyDetailsCreate, TimestampMixin):
    """Academy details response"""
    user_id: UUID4
    total_coaches: int
    total_students: int
    rating: Decimal
    total_reviews: int

    class Config:
        from_attributes = True


class ClinicDetailsCreate(BaseModel):
    """Create clinic details"""
    clinic_name: str
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    specializations: Optional[List[str]] = None


class ClinicDetailsUpdate(BaseModel):
    """Update clinic details"""
    clinic_name: Optional[str] = None
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    specializations: Optional[List[str]] = None


class ClinicDetailsResponse(ClinicDetailsCreate, TimestampMixin):
    """Clinic details response"""
    user_id: UUID4
    rating: Decimal
    total_reviews: int

    class Config:
        from_attributes = True


class CoachDetailsCreate(BaseModel):
    """Create coach details"""
    specialization: Optional[str] = None
    experience_years: Optional[int] = None
    certifications: Optional[List[str]] = None
    education: Optional[str] = None
    hourly_rate: Optional[Decimal] = None


class CoachDetailsUpdate(BaseModel):
    """Update coach details"""
    specialization: Optional[str] = None
    experience_years: Optional[int] = None
    certifications: Optional[List[str]] = None
    education: Optional[str] = None
    hourly_rate: Optional[Decimal] = None


class CoachDetailsResponse(CoachDetailsCreate, TimestampMixin):
    """Coach details response"""
    user_id: UUID4
    total_clients: int
    rating: Decimal
    total_reviews: int

    class Config:
        from_attributes = True


class StoreDetailsCreate(BaseModel):
    """Create store details"""
    store_name: str
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    shipping_available: bool = True
    accepts_returns: bool = True
    return_policy_days: int = 30


class StoreDetailsUpdate(BaseModel):
    """Update store details"""
    store_name: Optional[str] = None
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    shipping_available: Optional[bool] = None
    accepts_returns: Optional[bool] = None
    return_policy_days: Optional[int] = None


class StoreDetailsResponse(StoreDetailsCreate, TimestampMixin):
    """Store details response"""
    user_id: UUID4
    rating: Decimal
    total_reviews: int
    total_sales: int

    class Config:
        from_attributes = True


class EventOrganizerDetailsCreate(BaseModel):
    """Create event organizer details"""
    organization_name: str
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None


class EventOrganizerDetailsUpdate(BaseModel):
    """Update event organizer details"""
    organization_name: Optional[str] = None
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None


class EventOrganizerDetailsResponse(EventOrganizerDetailsCreate, TimestampMixin):
    """Event organizer details response"""
    user_id: UUID4
    total_events_hosted: int
    rating: Decimal
    total_reviews: int

    class Config:
        from_attributes = True


# ==================== BRANCH SCHEMAS ====================

class BranchBase(BaseModel):
    """Base branch information"""
    branch_name: str
    phone: str
    whatsapp_number: Optional[str] = None
    email: Optional[str] = None
    address: str
    city: str
    governorate: str
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    google_maps_url: Optional[str] = None
    opening_time: str
    closing_time: str
    working_days: List[str] = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    delivery_time_range_min: Optional[int] = None
    delivery_time_range_max: Optional[int] = None


class BranchCreate(BranchBase):
    """Create branch"""
    pass


class BranchUpdate(BaseModel):
    """Update branch (all fields optional)"""
    branch_name: Optional[str] = None
    phone: Optional[str] = None
    whatsapp_number: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    google_maps_url: Optional[str] = None
    opening_time: Optional[str] = None
    closing_time: Optional[str] = None
    working_days: Optional[List[str]] = None
    delivery_time_range_min: Optional[int] = None
    delivery_time_range_max: Optional[int] = None
    is_active: Optional[bool] = None
    branch_photo_url: Optional[str] = None


class BranchResponse(BranchBase, TimestampMixin):
    """Branch response"""
    id: UUID4
    owner_id: UUID4
    owner_type: UserRole
    is_active: bool
    branch_photo_url: Optional[str] = None

    class Config:
        from_attributes = True
