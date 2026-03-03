"""
Common schemas and enums used across the application
"""
from enum import Enum
from typing import Optional, List
from datetime import datetime, date, time
from decimal import Decimal
from pydantic import BaseModel, Field, UUID4


# ==================== ENUMS ====================

class UserRole(str, Enum):
    SWIMMER = "swimmer"
    ACADEMY = "academy"
    CLINIC = "clinic"
    ONLINE_COACH = "online_coach"
    EVENT_ORGANIZER = "event_organizer"
    STORE = "store"


class BookingStatus(str, Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class OrderStatus(str, Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    PROCESSING = "processing"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"
    REFUNDED = "refunded"


class PaymentStatus(str, Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"
    REFUNDED = "refunded"


class PaymentMethod(str, Enum):
    CREDIT_CARD = "credit_card"
    DEBIT_CARD = "debit_card"
    CASH_ON_DELIVERY = "cash_on_delivery"
    WALLET = "wallet"


class SessionStatus(str, Enum):
    UPCOMING = "upcoming"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class ProgramCategory(str, Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"
    COMPETITION = "competition"
    KIDS = "kids"
    ADULTS = "adults"


class ServiceCategory(str, Enum):
    REHABILITATION = "rehabilitation"
    ASSESSMENT = "assessment"
    RECOVERY = "recovery"
    MANUAL_THERAPY = "manual_therapy"
    OTHER = "other"


class ProductCategory(str, Enum):
    CAP = "cap"
    GOGGLES = "goggles"
    SUIT = "suit"
    KICKBOARD = "kickboard"
    PADDLES = "paddles"
    PARACHUTE = "parachute"
    FINS = "fins"
    SNORKELS = "snorkels"
    DEFLECTORS = "deflectors"
    APPAREL = "apparel"
    OTHER = "other"


class ProductCondition(str, Enum):
    NEW = "new"
    LIKE_NEW = "like_new"
    EXCELLENT = "excellent"
    GOOD = "good"
    FAIR = "fair"


class EventType(str, Enum):
    COMPETITION = "competition"
    SEMINAR = "seminar"
    WORKSHOP = "workshop"
    MEET = "meet"
    TRAINING_CAMP = "training_camp"
    WEBINAR = "webinar"


class NotificationType(str, Enum):
    BOOKING_CONFIRMED = "booking_confirmed"
    BOOKING_CANCELLED = "booking_cancelled"
    ORDER_PLACED = "order_placed"
    ORDER_SHIPPED = "order_shipped"
    ORDER_DELIVERED = "order_delivered"
    PAYMENT_RECEIVED = "payment_received"
    NEW_MESSAGE = "new_message"
    EVENT_REMINDER = "event_reminder"
    PROGRAM_UPDATE = "program_update"
    SYSTEM = "system"


class DayOfWeek(str, Enum):
    MONDAY = "monday"
    TUESDAY = "tuesday"
    WEDNESDAY = "wednesday"
    THURSDAY = "thursday"
    FRIDAY = "friday"
    SATURDAY = "saturday"
    SUNDAY = "sunday"


# ==================== BASE SCHEMAS ====================

class LocationBase(BaseModel):
    """Base location information"""
    city: Optional[str] = None
    governorate: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None


class TimestampMixin(BaseModel):
    """Mixin for created_at and updated_at timestamps"""
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class PaginationParams(BaseModel):
    """Pagination parameters"""
    skip: int = Field(0, ge=0, description="Number of records to skip")
    limit: int = Field(20, ge=1, le=100, description="Number of records to return")


class PaginatedResponse(BaseModel):
    """Generic paginated response"""
    total: int
    skip: int
    limit: int
    data: List[BaseModel]


class SuccessResponse(BaseModel):
    """Generic success response"""
    success: bool = True
    message: str


class ErrorResponse(BaseModel):
    """Generic error response"""
    success: bool = False
    error: str
    detail: Optional[str] = None


# ==================== SEARCH & FILTER ====================

class SearchParams(BaseModel):
    """Search parameters"""
    query: str = Field(..., min_length=1, description="Search query")
    skip: int = Field(0, ge=0)
    limit: int = Field(20, ge=1, le=100)


class PriceFilter(BaseModel):
    """Price range filter"""
    min_price: Optional[Decimal] = Field(None, ge=0)
    max_price: Optional[Decimal] = Field(None, ge=0)


class RatingFilter(BaseModel):
    """Rating filter"""
    min_rating: Optional[Decimal] = Field(None, ge=0, le=5)


class LocationFilter(LocationBase):
    """Location-based filter"""
    radius_km: Optional[int] = Field(None, ge=1, description="Search radius in kilometers")


# ==================== FILE UPLOAD ====================

class FileUploadResponse(BaseModel):
    """Response after file upload"""
    url: str
    filename: str
    size: int
    content_type: str


# ==================== STATISTICS ====================

class StatisticsBase(BaseModel):
    """Base statistics"""
    total_count: int
    active_count: Optional[int] = None
    inactive_count: Optional[int] = None


# ==================== HEALTH CHECK ====================

class HealthCheck(BaseModel):
    """Health check response"""
    status: str
    version: str
    database: bool
    timestamp: datetime
