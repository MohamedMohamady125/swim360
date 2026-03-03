"""
Academy-related Pydantic schemas
"""
from typing import Optional, List
from datetime import datetime, date
from pydantic import BaseModel, UUID4
from decimal import Decimal


# ============================================
# ACADEMY DETAILS SCHEMAS
# ============================================

class AcademyDetailsBase(BaseModel):
    """Base academy details schema"""
    academy_name: str
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    established_year: Optional[int] = None


class AcademyDetailsCreate(AcademyDetailsBase):
    """Create academy details"""
    pass


class AcademyDetailsUpdate(BaseModel):
    """Update academy details"""
    academy_name: Optional[str] = None
    description: Optional[str] = None
    website_url: Optional[str] = None
    license_number: Optional[str] = None
    established_year: Optional[int] = None


class AcademyDetails(AcademyDetailsBase):
    """Academy details response"""
    user_id: UUID4
    total_coaches: int
    total_students: int
    rating: Decimal
    total_reviews: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# ACADEMY BRANCH SCHEMAS
# ============================================

class AcademyBranchBase(BaseModel):
    """Base academy branch schema"""
    name: str
    city: Optional[str] = None
    governorate: Optional[str] = None
    location_url: Optional[str] = None
    opening_time: Optional[str] = None
    closing_time: Optional[str] = None
    operating_days: Optional[List[str]] = None


class AcademyBranchCreate(AcademyBranchBase):
    """Create academy branch"""
    pass


class AcademyBranchUpdate(BaseModel):
    """Update academy branch"""
    name: Optional[str] = None
    city: Optional[str] = None
    governorate: Optional[str] = None
    location_url: Optional[str] = None
    opening_time: Optional[str] = None
    closing_time: Optional[str] = None
    operating_days: Optional[List[str]] = None


class AcademyBranch(AcademyBranchBase):
    """Academy branch response"""
    id: UUID4
    user_id: UUID4
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# ACADEMY POOL SCHEMAS
# ============================================

class AcademyPoolBase(BaseModel):
    """Base academy pool schema"""
    name: str
    lanes: Optional[int] = 6
    capacity: Optional[int] = 30


class AcademyPoolCreate(AcademyPoolBase):
    """Create academy pool"""
    branch_id: UUID4


class AcademyPoolUpdate(BaseModel):
    """Update academy pool"""
    name: Optional[str] = None
    lanes: Optional[int] = None
    capacity: Optional[int] = None


class AcademyPool(AcademyPoolBase):
    """Academy pool response"""
    id: UUID4
    branch_id: UUID4
    created_at: datetime

    class Config:
        from_attributes = True


# ============================================
# ACADEMY PROGRAM SCHEMAS
# ============================================

class AcademyProgramBase(BaseModel):
    """Base academy program schema"""
    name: str
    description: Optional[str] = None
    price: Optional[Decimal] = Decimal('0')
    duration: Optional[str] = None
    capacity: Optional[int] = 20


class AcademyProgramCreate(AcademyProgramBase):
    """Create academy program"""
    pass


class AcademyProgramUpdate(BaseModel):
    """Update academy program"""
    name: Optional[str] = None
    description: Optional[str] = None
    price: Optional[Decimal] = None
    duration: Optional[str] = None
    capacity: Optional[int] = None


class AcademyProgram(AcademyProgramBase):
    """Academy program response"""
    id: UUID4
    user_id: UUID4
    enrolled: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================
# ACADEMY SWIMMER SCHEMAS
# ============================================

class AcademySwimmerBase(BaseModel):
    """Base academy swimmer schema"""
    swimmer_name: str
    phone: Optional[str] = None
    program_id: Optional[UUID4] = None
    branch_id: Optional[UUID4] = None
    end_date: Optional[date] = None


class AcademySwimmerCreate(AcademySwimmerBase):
    """Create academy swimmer"""
    pass


class AcademySwimmerUpdate(BaseModel):
    """Update academy swimmer"""
    swimmer_name: Optional[str] = None
    phone: Optional[str] = None
    program_id: Optional[UUID4] = None
    branch_id: Optional[UUID4] = None
    end_date: Optional[date] = None


class AcademySwimmer(AcademySwimmerBase):
    """Academy swimmer response"""
    id: UUID4
    user_id: UUID4
    created_at: datetime

    class Config:
        from_attributes = True


# ============================================
# ACADEMY COACH SCHEMAS
# ============================================

class AcademyCoachBase(BaseModel):
    """Base academy coach schema"""
    full_name: str
    email: Optional[str] = None
    phone: Optional[str] = None
    photo_url: Optional[str] = None
    specialization: Optional[str] = None
    experience_years: Optional[int] = None
    certifications: Optional[List[str]] = None
    bio: Optional[str] = None
    branch_id: Optional[UUID4] = None


class AcademyCoachCreate(AcademyCoachBase):
    """Create academy coach"""
    pass


class AcademyCoachUpdate(BaseModel):
    """Update academy coach"""
    full_name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    photo_url: Optional[str] = None
    specialization: Optional[str] = None
    experience_years: Optional[int] = None
    certifications: Optional[List[str]] = None
    bio: Optional[str] = None
    branch_id: Optional[UUID4] = None
    is_active: Optional[bool] = None


class AcademyCoach(AcademyCoachBase):
    """Academy coach response"""
    id: UUID4
    academy_id: UUID4
    is_active: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
