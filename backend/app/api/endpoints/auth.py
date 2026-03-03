"""
Authentication endpoints
"""
from fastapi import APIRouter, HTTPException, status, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db, database
from app.core.security import (
    get_password_hash,
    verify_password,
    create_access_token,
    create_refresh_token,
    generate_verification_token,
    verify_verification_token,
    generate_password_reset_token,
    verify_password_reset_token,
)
from app.core.supabase import supabase, auth_client
from app.schemas.auth import (
    SignupRequest,
    LoginRequest,
    TokenResponse,
    RefreshTokenRequest,
    VerifyEmailRequest,
    ForgotPasswordRequest,
    ResetPasswordRequest,
    ChangePasswordRequest,
    EmailVerificationResponse,
    PasswordResetResponse,
)
from app.api.dependencies.auth import get_current_user


router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/signup", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
async def signup(request: SignupRequest, db: AsyncSession = Depends(get_db)):
    """
    Register a new user

    Creates a new user account with Supabase Auth and creates profile in database
    """
    try:
        # Check if user already exists
        existing_user = await database.fetch_one(
            "SELECT id FROM profiles WHERE email = :email",
            {"email": request.email}
        )

        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User with this email already exists"
            )

        # DEV MODE: Skip Supabase Auth due to rate limits, create user directly
        from uuid import uuid4
        user_id = str(uuid4())

        # Hash password
        password_hash = get_password_hash(request.password)

        # Create profile in database
        profile_query = """
            INSERT INTO profiles (
                id, email, role, full_name, phone, governorate, city, password_hash,
                created_at, updated_at
            ) VALUES (
                :id, :email, :role, :full_name, :phone, :governorate, :city, :password_hash,
                NOW(), NOW()
            )
            RETURNING id, role, full_name, email
        """

        profile = await database.fetch_one(
            query=profile_query,
            values={
                "id": user_id,
                "email": request.email,
                "role": request.role.value,
                "full_name": request.full_name,
                "phone": request.phone,
                "governorate": request.governorate,
                "city": request.city,
                "password_hash": password_hash,
            }
        )

        # Create role-specific details table based on role
        if request.role.value == "academy":
            await database.execute(
                "INSERT INTO academy_details (user_id, academy_name, created_at, updated_at) VALUES (:user_id, :name, NOW(), NOW())",
                {"user_id": user_id, "name": request.full_name}
            )
        elif request.role.value == "clinic":
            await database.execute(
                "INSERT INTO clinic_details (user_id, clinic_name, created_at, updated_at) VALUES (:user_id, :name, NOW(), NOW())",
                {"user_id": user_id, "name": request.full_name}
            )
        elif request.role.value == "online_coach":
            await database.execute(
                "INSERT INTO coach_details (user_id, created_at, updated_at) VALUES (:user_id, NOW(), NOW())",
                {"user_id": user_id}
            )
        elif request.role.value == "event_organizer":
            await database.execute(
                "INSERT INTO event_organizer_details (user_id, organization_name, created_at, updated_at) VALUES (:user_id, :name, NOW(), NOW())",
                {"user_id": user_id, "name": request.full_name}
            )
        elif request.role.value == "store":
            await database.execute(
                "INSERT INTO store_details (user_id, store_name, created_at, updated_at) VALUES (:user_id, :name, NOW(), NOW())",
                {"user_id": user_id, "name": request.full_name}
            )

        # Generate JWT tokens manually (DEV MODE)
        access_token = create_access_token(data={"sub": user_id})
        refresh_token = create_refresh_token(data={"sub": user_id})

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            token_type="bearer",
            expires_in=30 * 60,  # 30 minutes
            user=dict(profile)
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Signup failed: {str(e)}"
        )


@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest):
    """
    Authenticate user and return access token

    Uses Supabase Auth for authentication
    """
    try:
        # DEV MODE: Authenticate against local database
        profile_query = """
            SELECT id, role, full_name, email, is_active, is_verified, password_hash
            FROM profiles
            WHERE email = :email
        """

        profile = await database.fetch_one(
            query=profile_query,
            values={"email": request.email}
        )

        if not profile:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )

        # Verify password
        if not verify_password(request.password, profile["password_hash"]):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )

        if not profile["is_active"]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Account is deactivated"
            )

        # Generate JWT tokens manually (DEV MODE)
        user_id = str(profile["id"])  # Convert UUID to string
        access_token = create_access_token(data={"sub": user_id})
        refresh_token = create_refresh_token(data={"sub": user_id})

        # Remove password_hash from profile before returning and convert UUID to string
        profile_dict = dict(profile)
        profile_dict["id"] = user_id  # Convert UUID to string
        profile_dict.pop("password_hash", None)

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            token_type="bearer",
            expires_in=30 * 60,  # 30 minutes
            user=profile_dict
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Login failed: {str(e)}"
        )


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(request: RefreshTokenRequest):
    """
    Refresh access token using refresh token
    """
    try:
        auth_response = supabase.auth.refresh_session(request.refresh_token)

        if not auth_response.session:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid refresh token"
            )

        # Fetch user profile
        profile = await database.fetch_one(
            "SELECT id, role, full_name, email FROM profiles WHERE id = :user_id",
            {"user_id": auth_response.user.id}
        )

        return TokenResponse(
            access_token=auth_response.session.access_token,
            refresh_token=auth_response.session.refresh_token,
            token_type="bearer",
            expires_in=auth_response.session.expires_in,
            user=dict(profile)
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Token refresh failed: {str(e)}"
        )


@router.post("/logout")
async def logout(current_user: dict = Depends(get_current_user)):
    """
    Logout current user (invalidate tokens)
    """
    try:
        supabase.auth.sign_out()
        return {"message": "Successfully logged out"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Logout failed: {str(e)}"
        )


@router.post("/verify-email", response_model=EmailVerificationResponse)
async def verify_email(request: VerifyEmailRequest):
    """
    Verify user's email address
    """
    try:
        # Verify token
        payload = verify_verification_token(request.token)
        user_id = payload.get("user_id")

        # Update user verification status
        await database.execute(
            "UPDATE profiles SET is_verified = true, updated_at = NOW() WHERE id = :user_id",
            {"user_id": user_id}
        )

        return EmailVerificationResponse(
            success=True,
            message="Email verified successfully"
        )

    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Verification failed: {str(e)}"
        )


@router.post("/forgot-password", response_model=PasswordResetResponse)
async def forgot_password(request: ForgotPasswordRequest):
    """
    Send password reset email
    """
    try:
        # Use Supabase password reset
        supabase.auth.reset_password_email(request.email)

        return PasswordResetResponse(
            success=True,
            message="Password reset email sent. Please check your inbox."
        )

    except Exception as e:
        # Don't reveal if email exists or not for security
        return PasswordResetResponse(
            success=True,
            message="If the email exists, a password reset link has been sent."
        )


@router.post("/reset-password", response_model=PasswordResetResponse)
async def reset_password(request: ResetPasswordRequest):
    """
    Reset password using reset token
    """
    try:
        # Update password via Supabase
        supabase.auth.update_user({
            "password": request.new_password
        })

        return PasswordResetResponse(
            success=True,
            message="Password reset successfully"
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Password reset failed: {str(e)}"
        )


@router.post("/change-password", response_model=PasswordResetResponse)
async def change_password(
    request: ChangePasswordRequest,
    current_user: dict = Depends(get_current_user)
):
    """
    Change password for authenticated user
    """
    try:
        # Verify current password by attempting to sign in
        try:
            email = current_user.get("email")
            supabase.auth.sign_in_with_password({
                "email": email,
                "password": request.current_password
            })
        except:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Current password is incorrect"
            )

        # Update password
        supabase.auth.update_user({
            "password": request.new_password
        })

        return PasswordResetResponse(
            success=True,
            message="Password changed successfully"
        )

    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Password change failed: {str(e)}"
        )


@router.get("/me")
async def get_current_user_info(current_user: dict = Depends(get_current_user)):
    """
    Get current authenticated user information
    """
    return current_user
