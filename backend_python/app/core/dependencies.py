# WHAT IT DOES:
# 1. Provides reusable dependencies
# 2. Gets current user from token
# 3. Validates permissions
# 4. Provides database sessions

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer

security = HTTPBearer()

async def get_current_user(token = Depends(security)):
    """Extract user from JWT token"""
    try:
        payload = decode_token(token.credentials)
        user_id = payload.get("sub")
        if not user_id:
            raise HTTPException(status_code=401)
        return user_id
    except JWTError:
        raise HTTPException(status_code=401)

async def require_role(role: str):
    """Require specific user role"""
    async def check_role(user_id = Depends(get_current_user)):
        # Check user has required role
        user_roles = db.table("user_roles").select("*").eq("user_id", user_id).execute()
        if role not in [r["role"] for r in user_roles.data]:
            raise HTTPException(status_code=403, detail="Insufficient permissions")
        return user_id
    return check_role