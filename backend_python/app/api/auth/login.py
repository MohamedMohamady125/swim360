from fastapi import APIRouter, HTTPException, status, Response
from app.schemas.auth import LoginRequest, LoginResponse
from app.services.auth_service import AuthService
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

@router.post("/login", response_model=LoginResponse)
async def login(request: LoginRequest, response: Response):
    """
    Login user
    
    - **email**: User's email address
    - **password**: User's password
    
    Returns user data and tokens
    """
    try:
        auth_service = AuthService()
        login_response = await auth_service.login(request)
        
        if not login_response.success:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=login_response.message
            )
        
        # Set refresh token as httpOnly cookie (optional)
        if login_response.refresh_token:
            response.set_cookie(
                key="refresh_token",
                value=login_response.refresh_token,
                httponly=True,
                secure=True,
                samesite="lax",
                max_age=30 * 24 * 60 * 60  # 30 days
            )
        
        return login_response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Login endpoint error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An error occurred during login"
        )