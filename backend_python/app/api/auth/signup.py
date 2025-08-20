from fastapi import APIRouter, HTTPException, status
from app.schemas.auth import SignUpRequest, SignUpResponse
from app.services.auth_service import AuthService
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

@router.post("/signup", response_model=SignUpResponse, status_code=status.HTTP_201_CREATED)
async def signup(request: SignUpRequest):
    """
    Register a new user
    
    - **email**: User's email address
    - **password**: Password (min 6 chars, must contain number and uppercase)
    - **full_name**: User's full name
    
    Returns user ID and access token. Email verification required.
    """
    try:
        auth_service = AuthService()
        response = await auth_service.signup(request)
        
        if not response.success:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=response.message
            )
        
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Signup endpoint error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An error occurred during registration"
        )