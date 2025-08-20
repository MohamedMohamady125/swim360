from typing import Optional, Dict, Any
from datetime import datetime, timedelta
from app.core.database import db
from app.core.security import SecurityService
from app.core.config import settings
from app.utils.otp_generator import generate_secure_otp
from app.services.email_service import EmailService
from app.schemas.auth import (
    SignUpRequest, SignUpResponse,
    LoginRequest, LoginResponse,
    VerifyEmailRequest, VerifyEmailResponse,
    ResendOTPRequest, ResendOTPResponse
)
import logging
import uuid

logger = logging.getLogger(__name__)

class AuthService:
    def __init__(self):
        self.db = db
        self.email_service = EmailService()
        self.security = SecurityService()
    
    async def signup(self, request: SignUpRequest) -> SignUpResponse:
        """Register a new user"""
        try:
            # Check if email already exists
            existing_user = self.db.table("profiles").select("*").eq("email", request.email).execute()
            
            if existing_user.data and len(existing_user.data) > 0:
                return SignUpResponse(
                    success=False,
                    message="Email already registered. Please login or use a different email.",
                    requires_verification=False
                )
            
            # Create user in Supabase Auth
            auth_response = self.db.auth.sign_up({
                "email": request.email,
                "password": request.password,
                "options": {
                    "data": {
                        "full_name": request.full_name
                    }
                }
            })
            
            if not auth_response.user:
                return SignUpResponse(
                    success=False,
                    message="Failed to create account. Please try again.",
                    requires_verification=False
                )
            
            user_id = auth_response.user.id
            
            # Create profile record
            profile_data = {
                "id": user_id,
                "email": request.email,
                "full_name": request.full_name,
                "is_email_verified": False,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }
            
            profile_result = self.db.table("profiles").insert(profile_data).execute()
            
            if not profile_result.data:
                # Rollback auth user if profile creation fails
                logger.error(f"Failed to create profile for user {user_id}")
                return SignUpResponse(
                    success=False,
                    message="Failed to create profile. Please try again.",
                    requires_verification=False
                )
            
            # Create default customer role
            role_data = {
                "id": str(uuid.uuid4()),
                "user_id": user_id,
                "role": "customer",
                "is_active": True,
                "created_at": datetime.utcnow().isoformat()
            }
            
            self.db.table("user_roles").insert(role_data).execute()
            
            # Generate and save OTP
            otp = generate_secure_otp()
            otp_data = {
                "id": str(uuid.uuid4()),
                "user_id": user_id,
                "email": request.email,
                "code": otp,
                "is_used": False,
                "expires_at": (datetime.utcnow() + timedelta(minutes=settings.otp_expiry_minutes)).isoformat(),
                "created_at": datetime.utcnow().isoformat()
            }
            
            self.db.table("email_verification_codes").insert(otp_data).execute()
            
            # Send verification email
            await self.email_service.send_verification_email(
                email=request.email,
                otp=otp,
                user_name=request.full_name
            )
            
            # Generate access token
            token_data = {
                "user_id": user_id,
                "email": request.email,
                "is_verified": False,
                "roles": ["customer"]
            }
            access_token = self.security.create_access_token(token_data)
            
            logger.info(f"User {user_id} registered successfully")
            
            return SignUpResponse(
                success=True,
                message="Account created successfully! Please check your email for verification code.",
                user_id=user_id,
                email=request.email,
                access_token=access_token,
                requires_verification=True
            )
            
        except Exception as e:
            logger.error(f"Signup error: {str(e)}")
            return SignUpResponse(
                success=False,
                message="An error occurred during registration. Please try again.",
                requires_verification=False
            )
    
    async def login(self, request: LoginRequest) -> LoginResponse:
        """Login user"""
        try:
            # Authenticate with Supabase
            auth_response = self.db.auth.sign_in_with_password({
                "email": request.email,
                "password": request.password
            })
            
            if not auth_response.user:
                return LoginResponse(
                    success=False,
                    message="Invalid email or password",
                    is_email_verified=False
                )
            
            user_id = auth_response.user.id
            
            # Get user profile
            profile_result = self.db.table("profiles").select("*").eq("id", user_id).single().execute()
            
            if not profile_result.data:
                return LoginResponse(
                    success=False,
                    message="Profile not found",
                    is_email_verified=False
                )
            
            profile = profile_result.data
            
            # Get user roles
            roles_result = self.db.table("user_roles").select("role").eq("user_id", user_id).eq("is_active", True).execute()
            roles = [r["role"] for r in roles_result.data] if roles_result.data else ["customer"]
            
            # Generate tokens
            token_data = {
                "user_id": user_id,
                "email": profile["email"],
                "is_verified": profile["is_email_verified"],
                "roles": roles
            }
            
            access_token = self.security.create_access_token(token_data)
            refresh_token = self.security.create_access_token(
                token_data, 
                expires_delta=timedelta(days=30)
            )
            
            # Update last login
            self.db.table("profiles").update({
                "last_login_at": datetime.utcnow().isoformat()
            }).eq("id", user_id).execute()
            
            # Prepare user data for response
            user_data = {
                "id": user_id,
                "email": profile["email"],
                "full_name": profile["full_name"],
                "is_email_verified": profile["is_email_verified"],
                "avatar_url": profile.get("avatar_url"),
                "roles": roles,
                "created_at": profile["created_at"]
            }
            
            logger.info(f"User {user_id} logged in successfully")
            
            return LoginResponse(
                success=True,
                message="Login successful",
                user=user_data,
                access_token=access_token,
                refresh_token=refresh_token,
                is_email_verified=profile["is_email_verified"]
            )
            
        except Exception as e:
            logger.error(f"Login error: {str(e)}")
            return LoginResponse(
                success=False,
                message="An error occurred during login. Please try again.",
                is_email_verified=False
            )
    
    async def verify_email(self, request: VerifyEmailRequest) -> VerifyEmailResponse:
        """Verify user email with OTP"""
        try:
            # Get OTP record
            otp_result = self.db.table("email_verification_codes").select("*").eq(
                "user_id", request.user_id
            ).eq(
                "code", request.otp
            ).eq(
                "is_used", False
            ).single().execute()
            
            if not otp_result.data:
                # Check if user has too many failed attempts
                attempts_result = self.db.table("verification_attempts").select("attempt_count").eq(
                    "user_id", request.user_id
                ).eq(
                    "date", datetime.utcnow().date().isoformat()
                ).execute()
                
                if attempts_result.data and attempts_result.data[0]["attempt_count"] >= settings.otp_max_attempts:
                    return VerifyEmailResponse(
                        success=False,
                        message="Too many failed attempts. Please request a new code tomorrow.",
                        is_verified=False
                    )
                
                # Record failed attempt
                self._record_verification_attempt(request.user_id)
                
                return VerifyEmailResponse(
                    success=False,
                    message="Invalid verification code. Please check and try again.",
                    is_verified=False
                )
            
            otp_data = otp_result.data
            
            # Check if OTP is expired
            expires_at = datetime.fromisoformat(otp_data["expires_at"].replace("Z", "+00:00"))
            if expires_at < datetime.utcnow():
                return VerifyEmailResponse(
                    success=False,
                    message="Verification code has expired. Please request a new one.",
                    is_verified=False
                )
            
            # Mark OTP as used
            self.db.table("email_verification_codes").update({
                "is_used": True,
                "used_at": datetime.utcnow().isoformat()
            }).eq("id", otp_data["id"]).execute()
            
            # Update user profile
            self.db.table("profiles").update({
                "is_email_verified": True,
                "email_verified_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }).eq("id", request.user_id).execute()
            
            # Send welcome email
            profile_result = self.db.table("profiles").select("full_name, email").eq("id", request.user_id).single().execute()
            if profile_result.data:
                await self.email_service.send_welcome_email(
                    email=profile_result.data["email"],
                    user_name=profile_result.data["full_name"]
                )
            
            logger.info(f"User {request.user_id} email verified successfully")
            
            return VerifyEmailResponse(
                success=True,
                message="Email verified successfully! Welcome to Swim360!",
                is_verified=True
            )
            
        except Exception as e:
            logger.error(f"Email verification error: {str(e)}")
            return VerifyEmailResponse(
                success=False,
                message="An error occurred during verification. Please try again.",
                is_verified=False
            )
    
    async def resend_otp(self, request: ResendOTPRequest) -> ResendOTPResponse:
        """Resend OTP for email verification"""
        try:
            # Check cooldown
            last_otp_result = self.db.table("email_verification_codes").select("created_at").eq(
                "user_id", request.user_id
            ).order("created_at", desc=True).limit(1).execute()
            
            if last_otp_result.data:
                last_sent = datetime.fromisoformat(last_otp_result.data[0]["created_at"].replace("Z", "+00:00"))
                time_since_last = (datetime.utcnow() - last_sent).total_seconds()
                
                if time_since_last < settings.otp_resend_cooldown_seconds:
                    cooldown_remaining = int(settings.otp_resend_cooldown_seconds - time_since_last)
                    return ResendOTPResponse(
                        success=False,
                        message=f"Please wait {cooldown_remaining} seconds before requesting a new code.",
                        cooldown_seconds=cooldown_remaining
                    )
            
            # Check daily limit
            today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
            daily_count_result = self.db.table("email_verification_codes").select("count").eq(
                "user_id", request.user_id
            ).gte("created_at", today_start.isoformat()).execute()
            
            daily_count = len(daily_count_result.data) if daily_count_result.data else 0
            
            if daily_count >= settings.otp_max_attempts:
                return ResendOTPResponse(
                    success=False,
                    message="Daily limit reached. Please try again tomorrow.",
                    cooldown_seconds=None
                )
            
            # Invalidate old OTPs
            self.db.table("email_verification_codes").update({
                "is_used": True
            }).eq("user_id", request.user_id).eq("is_used", False).execute()
            
            # Generate new OTP
            otp = generate_secure_otp()
            otp_data = {
                "id": str(uuid.uuid4()),
                "user_id": request.user_id,
                "email": request.email,
                "code": otp,
                "is_used": False,
                "expires_at": (datetime.utcnow() + timedelta(minutes=settings.otp_expiry_minutes)).isoformat(),
                "created_at": datetime.utcnow().isoformat()
            }
            
            self.db.table("email_verification_codes").insert(otp_data).execute()
            
            # Get user name for email
            profile_result = self.db.table("profiles").select("full_name").eq("id", request.user_id).single().execute()
            user_name = profile_result.data["full_name"] if profile_result.data else "User"
            
            # Send email
            await self.email_service.send_verification_email(
                email=request.email,
                otp=otp,
                user_name=user_name
            )
            
            logger.info(f"OTP resent for user {request.user_id}")
            
            return ResendOTPResponse(
                success=True,
                message="New verification code sent! Please check your email.",
                cooldown_seconds=settings.otp_resend_cooldown_seconds
            )
            
        except Exception as e:
            logger.error(f"Resend OTP error: {str(e)}")
            return ResendOTPResponse(
                success=False,
                message="Failed to resend verification code. Please try again.",
                cooldown_seconds=None
            )
    
    def _record_verification_attempt(self, user_id: str) -> None:
        """Record failed verification attempt"""
        try:
            today = datetime.utcnow().date().isoformat()
            
            # Check if record exists for today
            existing = self.db.table("verification_attempts").select("*").eq(
                "user_id", user_id
            ).eq("date", today).execute()
            
            if existing.data:
                # Update attempt count
                self.db.table("verification_attempts").update({
                    "attempt_count": existing.data[0]["attempt_count"] + 1,
                    "last_attempt_at": datetime.utcnow().isoformat()
                }).eq("id", existing.data[0]["id"]).execute()
            else:
                # Create new record
                self.db.table("verification_attempts").insert({
                    "id": str(uuid.uuid4()),
                    "user_id": user_id,
                    "date": today,
                    "attempt_count": 1,
                    "last_attempt_at": datetime.utcnow().isoformat()
                }).execute()
                
        except Exception as e:
            logger.error(f"Failed to record verification attempt: {e}")