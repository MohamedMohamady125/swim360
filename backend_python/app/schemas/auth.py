from pydantic import BaseModel, EmailStr, Field, validator
from typing import Optional, Dict, Any
from datetime import datetime

class SignUpRequest(BaseModel):
    """User registration request"""
    email: EmailStr
    password: str = Field(..., min_length=6, max_length=100)
    full_name: str = Field(..., min_length=2, max_length=100)
    
    @validator('password')
    def validate_password(cls, v):
        if len(v) < 6:
            raise ValueError('Password must be at least 6 characters')
        if not any(char.isdigit() for char in v):
            raise ValueError('Password must contain at least one number')
        if not any(char.isupper() for char in v):
            raise ValueError('Password must contain at least one uppercase letter')
        return v
    
    @validator('full_name')
    def validate_full_name(cls, v):
        if len(v.strip()) < 2:
            raise ValueError('Full name must be at least 2 characters')
        return v.strip()

class SignUpResponse(BaseModel):
    """User registration response"""
    success: bool
    message: str
    user_id: Optional[str] = None
    email: Optional[str] = None
    access_token: Optional[str] = None
    requires_verification: bool = True

class LoginRequest(BaseModel):
    """User login request"""
    email: EmailStr
    password: str = Field(..., min_length=1)

class LoginResponse(BaseModel):
    """User login response"""
    success: bool
    message: str
    user: Optional[Dict[str, Any]] = None
    access_token: Optional[str] = None
    refresh_token: Optional[str] = None
    is_email_verified: bool = False

class VerifyEmailRequest(BaseModel):
    """Email verification request"""
    user_id: str = Field(..., min_length=1)
    otp: str = Field(..., min_length=6, max_length=6)
    
    @validator('otp')
    def validate_otp(cls, v):
        if not v.isdigit():
            raise ValueError('OTP must contain only digits')
        if len(v) != 6:
            raise ValueError('OTP must be exactly 6 digits')
        return v

class VerifyEmailResponse(BaseModel):
    """Email verification response"""
    success: bool
    message: str
    is_verified: bool = False

class ResendOTPRequest(BaseModel):
    """Resend OTP request"""
    user_id: str = Field(..., min_length=1)
    email: EmailStr

class ResendOTPResponse(BaseModel):
    """Resend OTP response"""
    success: bool
    message: str
    cooldown_seconds: Optional[int] = None

class ResetPasswordRequest(BaseModel):
    """Password reset request"""
    email: EmailStr

class ResetPasswordResponse(BaseModel):
    """Password reset response"""
    success: bool
    message: str

class TokenData(BaseModel):
    """JWT token payload data"""
    user_id: str
    email: str
    is_verified: bool
    roles: list = []