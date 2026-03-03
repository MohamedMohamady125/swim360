"""
Application configuration and settings
"""
from typing import List, Optional
from pydantic import Field, PostgresDsn
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables"""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore"
    )

    # Environment
    environment: str = Field(default="development")
    debug: bool = Field(default=True)
    api_version: str = Field(default="v1")

    # Server
    host: str = Field(default="0.0.0.0")
    port: int = Field(default=8000)
    workers: int = Field(default=4)

    # Database
    database_url: PostgresDsn
    supabase_url: str
    supabase_key: str
    supabase_service_key: str

    # Security
    secret_key: str
    algorithm: str = Field(default="HS256")
    access_token_expire_minutes: int = Field(default=30)
    refresh_token_expire_days: int = Field(default=7)

    # CORS
    allowed_origins: str = Field(default="*")

    # Supabase Auth
    supabase_jwt_secret: str

    # Storage
    storage_provider: str = Field(default="supabase")
    aws_access_key_id: Optional[str] = None
    aws_secret_access_key: Optional[str] = None
    aws_region: str = Field(default="us-east-1")
    s3_bucket_name: Optional[str] = None

    # Email
    sendgrid_api_key: Optional[str] = None
    from_email: str = Field(default="noreply@swim360.com")
    from_name: str = Field(default="Swim360")

    # SMS
    twilio_account_sid: Optional[str] = None
    twilio_auth_token: Optional[str] = None
    twilio_phone_number: Optional[str] = None

    # Payment
    stripe_secret_key: Optional[str] = None
    stripe_publishable_key: Optional[str] = None
    stripe_webhook_secret: Optional[str] = None

    # Push Notifications
    firebase_credentials_path: Optional[str] = None

    # Logging
    log_level: str = Field(default="INFO")
    log_file: str = Field(default="logs/app.log")

    # Rate Limiting
    rate_limit_per_minute: int = Field(default=60)

    # File Upload
    max_file_size_mb: int = Field(default=10)
    allowed_image_types: str = Field(default="image/jpeg,image/png,image/webp")
    allowed_video_types: str = Field(default="video/mp4,video/quicktime")

    # Business Logic
    default_currency: str = Field(default="USD")
    service_fee_percentage: float = Field(default=5.0)
    low_stock_threshold: int = Field(default=10)

    @property
    def allowed_origins_list(self) -> List[str]:
        """Parse allowed origins into a list"""
        if self.allowed_origins == "*":
            return ["*"]
        return [origin.strip() for origin in self.allowed_origins.split(",")]

    @property
    def allowed_image_types_list(self) -> List[str]:
        """Parse allowed image types into a list"""
        return [t.strip() for t in self.allowed_image_types.split(",")]

    @property
    def allowed_video_types_list(self) -> List[str]:
        """Parse allowed video types into a list"""
        return [t.strip() for t in self.allowed_video_types.split(",")]

    @property
    def max_file_size_bytes(self) -> int:
        """Convert max file size to bytes"""
        return self.max_file_size_mb * 1024 * 1024


# Initialize settings
settings = Settings()


# API Documentation
API_TITLE = "Swim360 API"
API_DESCRIPTION = """
## Swim360 - Complete Swimming Community Platform API

Swim360 connects swimmers with academies, clinics, coaches, event organizers, and equipment stores.

### Features

* **Authentication** - User registration, login, email verification
* **Multi-Role Support** - 6 user types: swimmer, academy, clinic, online_coach, event_organizer, store
* **Programs** - Training programs offered by academies and coaches
* **Services** - Therapy and rehabilitation services from clinics
* **Bookings** - Book programs, services, and sessions
* **E-Commerce** - Product catalog, cart, orders, payments
* **Events** - Swimming competitions, seminars, and workshops
* **Used Marketplace** - Buy and sell used swimming equipment
* **Chat** - Real-time messaging between users
* **Reviews** - Rate and review services, products, and providers
* **Notifications** - Push notifications and in-app alerts

### User Roles

- **Swimmer**: End users who book services and purchase products
- **Academy**: Swimming training centers with multiple branches
- **Clinic**: Therapy and rehabilitation clinics
- **Online Coach**: Independent coaches offering personalized training
- **Event Organizer**: Organizations hosting swimming events
- **Store**: Equipment retailers selling swimming gear

### Authentication

All endpoints (except auth and public endpoints) require authentication via Bearer token:

```
Authorization: Bearer <your_access_token>
```

Get your access token by calling `/api/v1/auth/login`
"""

API_VERSION_INFO = "1.0.0"
API_CONTACT = {
    "name": "Swim360 API Support",
    "email": "support@swim360.com",
}
API_LICENSE = {
    "name": "Proprietary",
}
