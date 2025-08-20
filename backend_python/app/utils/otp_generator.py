import random
import string
from datetime import datetime, timedelta
import hashlib
import secrets

def generate_otp() -> str:
    """Generate 6-digit OTP"""
    return ''.join(random.choices('0123456789', k=6))

def generate_secure_otp() -> str:
    """Generate cryptographically secure 6-digit OTP"""
    return f"{secrets.randbelow(1000000):06d}"

def hash_otp(otp: str) -> str:
    """Hash OTP for secure storage"""
    return hashlib.sha256(otp.encode()).hexdigest()

def generate_verification_token() -> str:
    """Generate email verification token"""
    return secrets.token_urlsafe(32)