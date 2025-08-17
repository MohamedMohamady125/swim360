from typing import Optional, Dict
from app.core.database import db
from app.utils.otp_generator import generate_otp
from app.services.email_service import EmailService
import bcrypt

class AuthService:
    def __init__(self):
        self.email_service = EmailService()
    
    async def signup(self, email: str, password: str, full_name: str) -> Dict:
        """Register a new user"""
        try:
            # Create user in Supabase Auth
            auth_response = db.auth.sign_up({
                "email": email,
                "password": password
            })
            
            if auth_response.user:
                # Create profile
                profile_data = {
                    "id": auth_response.user.id,
                    "email": email,
                    "full_name": full_name,
                    "is_email_verified": False
                }
                
                db.table("profiles").insert(profile_data).execute()
                
                # Generate and send OTP
                otp = generate_otp()
                await self._save_otp(auth_response.user.id, otp)
                await self.email_service.send_otp(email, otp)
                
                return {
                    "success": True,
                    "user_id": auth_response.user.id,
                    "message": "User created successfully. Please verify your email."
                }
            
        except Exception as e:
            return {
                "success": False,
                "error": str(e)
            }
    
    async def verify_email(self, user_id: str, otp: str) -> Dict:
        """Verify user's email with OTP"""
        # Get stored OTP
        result = db.table("email_verification_codes")\
            .select("*")\
            .eq("user_id", user_id)\
            .eq("code", otp)\
            .eq("is_used", False)\
            .execute()
        
        if result.data and len(result.data) > 0:
            # Mark OTP as used
            db.table("email_verification_codes")\
                .update({"is_used": True})\
                .eq("id", result.data[0]["id"])\
                .execute()
            
            # Update profile
            db.table("profiles")\
                .update({"is_email_verified": True})\
                .eq("id", user_id)\
                .execute()
            
            return {"success": True, "message": "Email verified successfully"}
        
        return {"success": False, "error": "Invalid or expired OTP"}
    
    async def _save_otp(self, user_id: str, otp: str):
        """Save OTP to database"""
        db.table("email_verification_codes").insert({
            "user_id": user_id,
            "code": otp,
            "email": db.table("profiles").select("email").eq("id", user_id).execute().data[0]["email"]
        }).execute()