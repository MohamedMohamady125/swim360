from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from app.services.auth_service import AuthService

router = APIRouter()
auth_service = AuthService()

class SignUpRequest(BaseModel):
    email: EmailStr
    password: str
    full_name: str

class SignUpResponse(BaseModel):
    success: bool
    user_id: str = None
    message: str

@router.post("/signup", response_model=SignUpResponse)
async def signup(request: SignUpRequest):
    """
    Register a new user
    """
    if len(request.password) < 6:
        raise HTTPException(status_code=400, detail="Password must be at least 6 characters")
    
    result = await auth_service.signup(
        email=request.email,
        password=request.password,
        full_name=request.full_name
    )
    
    if not result["success"]:
        raise HTTPException(status_code=400, detail=result["error"])
    
    return SignUpResponse(
        success=True,
        user_id=result["user_id"],
        message=result["message"]
    )