"""
Authentication and authorization schemas
"""
from typing import Optional
from pydantic import BaseModel, EmailStr, Field, UUID4
from app.schemas.common import UserRole


class SignupRequest(BaseModel):
    """User signup request"""
    email: EmailStr
    password: str = Field(..., min_length=8, description="Password must be at least 8 characters")
    full_name: str = Field(..., min_length=2, max_length=100)
    phone: Optional[str] = Field(None, max_length=20)
    role: UserRole = Field(default=UserRole.SWIMMER, description="User role (defaults to swimmer)")
    governorate: Optional[str] = None
    city: Optional[str] = None

    class Config:
        json_schema_extra = {
            "example": {
                "email": "user@example.com",
                "password": "SecurePass123!",
                "full_name": "John Doe",
                "phone": "+201234567890",
                "role": "swimmer",
                "governorate": "Cairo",
                "city": "Maadi"
            }
        }


class LoginRequest(BaseModel):
    """User login request"""
    email: EmailStr
    password: str

    class Config:
        json_schema_extra = {
            "example": {
                "email": "user@example.com",
                "password": "SecurePass123!"
            }
        }


class TokenResponse(BaseModel):
    """Token response"""
    success: bool = True
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int
    user: dict


class RefreshTokenRequest(BaseModel):
    """Refresh token request"""
    refresh_token: str


class VerifyEmailRequest(BaseModel):
    """Email verification request"""
    token: str


class ForgotPasswordRequest(BaseModel):
    """Forgot password request"""
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    """Reset password request"""
    token: str
    new_password: str = Field(..., min_length=8)


class ChangePasswordRequest(BaseModel):
    """Change password request (for authenticated users)"""
    current_password: str
    new_password: str = Field(..., min_length=8)


class EmailVerificationResponse(BaseModel):
    """Email verification response"""
    success: bool
    message: str


class PasswordResetResponse(BaseModel):
    """Password reset response"""
    success: bool
    message: str
