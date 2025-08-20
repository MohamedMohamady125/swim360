from fastapi import APIRouter, HTTPException, status
from app.schemas.auth import (
    VerifyEmailRequest, 
    VerifyEmailResponse,
    ResendOTPRequest,
    ResendOTPResponse
)
from app.services.auth_service import AuthService
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

@router.post("/verify-email", response_model=VerifyEmailResponse)
async def verify_email(request: VerifyEmailRequest):
    """
    Verify user's email with OTP
    
    - **user_id**: User's ID from registration
    - **otp**: 6-digit verification code
    
    Updates user's verification status
    """
    try:
        auth_service = AuthService()
        response = await auth_service.verify_email(request)
        
        if not response.success:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=response.message
            )
        
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Verify email endpoint error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An error occurred during verification"
        )

@router.post("/resend-otp", response_model=ResendOTPResponse)
async def resend_otp(request: ResendOTPRequest):
    """
    Resend OTP verification code
    
    - **user_id**: User's ID
    - **email**: User's email address
    
    Sends new OTP with cooldown period
    """
    try:
        auth_service = AuthService()
        response = await auth_service.resend_otp(request)
        
        if not response.success:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS if response.cooldown_seconds else status.HTTP_400_BAD_REQUEST,
                detail=response.message,
                headers={"Retry-After": str(response.cooldown_seconds)} if response.cooldown_seconds else None
            )
        
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Resend OTP endpoint error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An error occurred while resending OTP"
        )