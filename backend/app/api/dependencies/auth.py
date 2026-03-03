"""
Authentication dependencies for FastAPI routes
"""
from typing import Optional
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.security import decode_token, verify_supabase_jwt
from app.core.supabase import supabase
from app.schemas.common import UserRole


security = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: AsyncSession = Depends(get_db)
) -> dict:
    """
    Get current authenticated user from JWT token

    This dependency can be used to protect routes:
        @app.get("/protected")
        async def protected_route(current_user: dict = Depends(get_current_user)):
            ...
    """
    token = credentials.credentials

    try:
        # First try to verify as Supabase token
        payload = verify_supabase_jwt(token)
        user_id = payload.get("sub")

        if not user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token: user ID not found",
            )

        # Fetch user profile from database
        query = """
            SELECT id, role, full_name, email, is_active, is_verified
            FROM profiles
            WHERE id = :user_id
        """

        from app.core.database import database
        user = await database.fetch_one(query=query, values={"user_id": user_id})

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found",
            )

        if not user["is_active"]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Account is deactivated",
            )

        return dict(user)

    except Exception as e:
        # If Supabase token verification fails, try our own token
        try:
            payload = decode_token(token)
            user_id = payload.get("user_id")

            if not user_id:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid token",
                )

            # Fetch user
            query = """
                SELECT id, role, full_name, email, is_active, is_verified
                FROM profiles
                WHERE id = :user_id
            """

            from app.core.database import database
            user = await database.fetch_one(query=query, values={"user_id": user_id})

            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="User not found",
                )

            if not user["is_active"]:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Account is deactivated",
                )

            return dict(user)

        except Exception:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Could not validate credentials",
                headers={"WWW-Authenticate": "Bearer"},
            )


async def get_current_verified_user(
    current_user: dict = Depends(get_current_user)
) -> dict:
    """
    Get current user and ensure email is verified
    """
    if not current_user.get("is_verified"):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Email not verified. Please verify your email to access this resource.",
        )
    return current_user


def require_role(allowed_roles: list[UserRole]):
    """
    Dependency factory to check if user has required role

    Usage:
        @app.get("/admin")
        async def admin_route(current_user: dict = Depends(require_role([UserRole.ADMIN]))):
            ...
    """
    async def role_checker(current_user: dict = Depends(get_current_user)) -> dict:
        user_role = current_user.get("role")

        if user_role not in [role.value for role in allowed_roles]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Insufficient permissions. Required roles: {[r.value for r in allowed_roles]}",
            )

        return current_user

    return role_checker


# Convenience dependencies for specific roles
async def require_swimmer(current_user: dict = Depends(get_current_user)) -> dict:
    """Require swimmer role"""
    if current_user.get("role") != UserRole.SWIMMER.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for swimmers",
        )
    return current_user


async def require_academy(current_user: dict = Depends(get_current_user)) -> dict:
    """Require academy role"""
    if current_user.get("role") != UserRole.ACADEMY.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for academies",
        )
    return current_user


async def require_clinic(current_user: dict = Depends(get_current_user)) -> dict:
    """Require clinic role"""
    if current_user.get("role") != UserRole.CLINIC.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for clinics",
        )
    return current_user


async def require_store(current_user: dict = Depends(get_current_user)) -> dict:
    """Require store role"""
    if current_user.get("role") != UserRole.STORE.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for stores",
        )
    return current_user


async def require_event_organizer(current_user: dict = Depends(get_current_user)) -> dict:
    """Require event organizer role"""
    if current_user.get("role") != UserRole.EVENT_ORGANIZER.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for event organizers",
        )
    return current_user


async def require_coach(current_user: dict = Depends(get_current_user)) -> dict:
    """Require online coach role"""
    if current_user.get("role") != UserRole.ONLINE_COACH.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for online coaches",
        )
    return current_user


async def require_provider(current_user: dict = Depends(get_current_user)) -> dict:
    """Require any provider role (academy, clinic, coach, event_organizer, store)"""
    provider_roles = [
        UserRole.ACADEMY.value,
        UserRole.CLINIC.value,
        UserRole.ONLINE_COACH.value,
        UserRole.EVENT_ORGANIZER.value,
        UserRole.STORE.value,
    ]

    if current_user.get("role") not in provider_roles:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for service providers",
        )

    return current_user


# Optional authentication (user may or may not be authenticated)
async def get_current_user_optional(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(HTTPBearer(auto_error=False))
) -> Optional[dict]:
    """
    Get current user if authenticated, otherwise return None
    Useful for endpoints that work for both authenticated and unauthenticated users
    """
    if not credentials:
        return None

    try:
        return await get_current_user(credentials)
    except HTTPException:
        return None
