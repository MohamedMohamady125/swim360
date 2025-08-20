from pydantic_settings import BaseSettings
from typing import Optional
import os
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    # App Configuration
    app_name: str = "Swim360"
    app_version: str = "1.0.0"
    debug: bool = True
    
    # Supabase Configuration - Using your actual credentials
    supabase_url: str = "https://lemmqyevlipsexqxvgpd.supabase.co"
    supabase_key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlbW1xeWV2bGlwc2V4cXh2Z3BkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUzOTc3ODQsImV4cCI6MjA3MDk3Mzc4NH0.SaIzDRTMf_Nn3qA0j5LyPC9F6XdvYnPXKSVuOmG4_fg"
    supabase_service_key: str = os.getenv("SUPABASE_SERVICE_KEY", "")
    
    # JWT Configuration
    secret_key: str = os.getenv("SECRET_KEY", "swim360-secret-key-2024")
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 43200  # 30 days
    
    # Email Configuration (Optional for now)
    sendgrid_api_key: Optional[str] = os.getenv("SENDGRID_API_KEY")
    from_email: str = "noreply@swim360.com"
    from_name: str = "Swim360"
    
    # OTP Configuration
    otp_expiry_minutes: int = 5
    otp_max_attempts: int = 5
    otp_resend_cooldown_seconds: int = 60
    
    # Frontend URL
    frontend_url: str = "http://localhost:3000"
    
    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()