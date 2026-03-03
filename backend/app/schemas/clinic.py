"""
Clinic-related Pydantic schemas
"""
from typing import Optional, List
from datetime import datetime, date
from pydantic import BaseModel, UUID4
from decimal import Decimal


# ============================================
# CLINIC DETAILS SCHEMAS
# ============================================

class ClinicDetailsBase(BaseModel):
    """Base clinic details schema"""
    clinic_name: str
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    specializations: Optional[List[str]] = None


class ClinicDetailsCreate(ClinicDetailsBase):
    """Create clinic details"""
    pass


class ClinicDetailsUpdate(BaseModel):
    """Update clinic details"""
    clinic_name: Optional[str] = None
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    specializations: Optional[List[str]] = None


class ClinicDetails(ClinicDetailsBase):
    """Clinic details response"""
    user_id: UUID4
    rating: Decimal
    total_reviews: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# CLINIC BRANCH SCHEMAS
# ============================================

class ClinicBranchBase(BaseModel):
    """Base clinic branch schema"""
    location_name: str
    governorate: Optional[str] = None
    city: Optional[str] = None
    location_url: Optional[str] = None
    number_of_beds: Optional[int] = 1
    opening_hour: Optional[str] = None
    opening_minute: Optional[str] = None
    opening_ampm: Optional[str] = None
    closing_hour: Optional[str] = None
    closing_minute: Optional[str] = None
    closing_ampm: Optional[str] = None
    services_offered: Optional[List[str]] = None


class ClinicBranchCreate(ClinicBranchBase):
    """Create clinic branch"""
    pass


class ClinicBranchUpdate(BaseModel):
    """Update clinic branch"""
    location_name: Optional[str] = None
    governorate: Optional[str] = None
    city: Optional[str] = None
    location_url: Optional[str] = None
    number_of_beds: Optional[int] = None
    opening_hour: Optional[str] = None
    opening_minute: Optional[str] = None
    opening_ampm: Optional[str] = None
    closing_hour: Optional[str] = None
    closing_minute: Optional[str] = None
    closing_ampm: Optional[str] = None
    services_offered: Optional[List[str]] = None


class ClinicBranch(ClinicBranchBase):
    """Clinic branch response"""
    id: UUID4
    user_id: UUID4
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# CLINIC SERVICE SCHEMAS
# ============================================

class ClinicServiceBase(BaseModel):
    """Base clinic service schema"""
    title: str
    category: Optional[str] = None
    price: Optional[Decimal] = Decimal('0')
    duration: Optional[str] = None
    description: Optional[str] = None
    video_url: Optional[str] = None
    photo_url: Optional[str] = None


class ClinicServiceCreate(ClinicServiceBase):
    """Create clinic service"""
    pass


class ClinicServiceUpdate(BaseModel):
    """Update clinic service"""
    title: Optional[str] = None
    category: Optional[str] = None
    price: Optional[Decimal] = None
    duration: Optional[str] = None
    description: Optional[str] = None
    video_url: Optional[str] = None
    photo_url: Optional[str] = None


class ClinicService(ClinicServiceBase):
    """Clinic service response"""
    id: UUID4
    user_id: UUID4
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# CLINIC BOOKING SCHEMAS
# ============================================

class ClinicBookingBase(BaseModel):
    """Base clinic booking schema"""
    client_name: str
    client_age: Optional[int] = None
    phone: Optional[str] = None
    booking_date: date
    booking_time: str
    bed_number: Optional[str] = None
    service_id: Optional[UUID4] = None


class ClinicBookingCreate(ClinicBookingBase):
    """Create clinic booking"""
    branch_id: UUID4


class ClinicBookingUpdate(BaseModel):
    """Update clinic booking"""
    client_name: Optional[str] = None
    client_age: Optional[int] = None
    phone: Optional[str] = None
    booking_date: Optional[date] = None
    booking_time: Optional[str] = None
    bed_number: Optional[str] = None
    service_id: Optional[UUID4] = None
    status: Optional[str] = None


class ClinicBooking(ClinicBookingBase):
    """Clinic booking response"""
    id: UUID4
    branch_id: UUID4
    status: str
    created_at: datetime

    class Config:
        from_attributes = True
