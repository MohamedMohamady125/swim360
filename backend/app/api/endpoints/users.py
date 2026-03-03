"""
User and profile management endpoints
"""
from typing import List
from fastapi import APIRouter, HTTPException, status, Depends, UploadFile, File
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db, database
from app.api.dependencies.auth import get_current_user, require_provider
from app.schemas.user import (
    ProfileResponse,
    ProfileUpdate,
    BranchCreate,
    BranchUpdate,
    BranchResponse,
    AcademyDetailsCreate,
    AcademyDetailsUpdate,
    AcademyDetailsResponse,
    ClinicDetailsCreate,
    ClinicDetailsUpdate,
    ClinicDetailsResponse,
    CoachDetailsCreate,
    CoachDetailsUpdate,
    CoachDetailsResponse,
    StoreDetailsCreate,
    StoreDetailsUpdate,
    StoreDetailsResponse,
    EventOrganizerDetailsCreate,
    EventOrganizerDetailsUpdate,
    EventOrganizerDetailsResponse,
)


router = APIRouter(prefix="/users", tags=["Users & Profiles"])


@router.get("/profile", response_model=ProfileResponse)
async def get_my_profile(current_user: dict = Depends(get_current_user)):
    """Get current user's profile"""
    profile = await database.fetch_one(
        "SELECT * FROM profiles WHERE id = :user_id",
        {"user_id": current_user["id"]}
    )

    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    return dict(profile)


@router.put("/profile", response_model=ProfileResponse)
async def update_my_profile(
    updates: ProfileUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update current user's profile"""
    update_data = updates.dict(exclude_unset=True)

    if not update_data:
        raise HTTPException(status_code=400, detail="No fields to update")

    # Build update query
    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE profiles SET {set_clause}, updated_at = NOW() WHERE id = :user_id RETURNING *"

    update_data["user_id"] = current_user["id"]

    profile = await database.fetch_one(query=query, values=update_data)

    return dict(profile)


@router.get("/profile/{user_id}", response_model=ProfileResponse)
async def get_user_profile(user_id: str):
    """Get any user's public profile"""
    profile = await database.fetch_one(
        "SELECT * FROM profiles WHERE id = :user_id",
        {"user_id": user_id}
    )

    if not profile:
        raise HTTPException(status_code=404, detail="User not found")

    return dict(profile)


# ==================== BRANCHES ====================

@router.get("/branches", response_model=List[BranchResponse])
async def get_my_branches(current_user: dict = Depends(require_provider)):
    """Get current user's branches"""
    branches = await database.fetch_all(
        "SELECT * FROM branches WHERE owner_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return [dict(branch) for branch in branches]


@router.post("/branches", response_model=BranchResponse, status_code=status.HTTP_201_CREATED)
async def create_branch(
    branch: BranchCreate,
    current_user: dict = Depends(require_provider)
):
    """Create a new branch"""
    query = """
        INSERT INTO branches (
            owner_id, owner_type, branch_name, phone, whatsapp_number, email,
            address, city, governorate, latitude, longitude, google_maps_url,
            opening_time, closing_time, working_days, delivery_time_range_min,
            delivery_time_range_max, created_at, updated_at
        ) VALUES (
            :owner_id, :owner_type, :branch_name, :phone, :whatsapp_number, :email,
            :address, :city, :governorate, :latitude, :longitude, :google_maps_url,
            :opening_time, :closing_time, :working_days, :delivery_time_range_min,
            :delivery_time_range_max, NOW(), NOW()
        ) RETURNING *
    """

    values = branch.dict()
    values["owner_id"] = current_user["id"]
    values["owner_type"] = current_user["role"]

    new_branch = await database.fetch_one(query=query, values=values)

    return dict(new_branch)


@router.put("/branches/{branch_id}", response_model=BranchResponse)
async def update_branch(
    branch_id: str,
    updates: BranchUpdate,
    current_user: dict = Depends(require_provider)
):
    """Update a branch"""
    # Check ownership
    existing = await database.fetch_one(
        "SELECT * FROM branches WHERE id = :branch_id AND owner_id = :user_id",
        {"branch_id": branch_id, "user_id": current_user["id"]}
    )

    if not existing:
        raise HTTPException(status_code=404, detail="Branch not found or access denied")

    update_data = updates.dict(exclude_unset=True)

    if not update_data:
        return dict(existing)

    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE branches SET {set_clause}, updated_at = NOW() WHERE id = :branch_id RETURNING *"

    update_data["branch_id"] = branch_id

    updated_branch = await database.fetch_one(query=query, values=update_data)

    return dict(updated_branch)


@router.delete("/branches/{branch_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_branch(
    branch_id: str,
    current_user: dict = Depends(require_provider)
):
    """Delete a branch"""
    result = await database.execute(
        "DELETE FROM branches WHERE id = :branch_id AND owner_id = :user_id",
        {"branch_id": branch_id, "user_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Branch not found or access denied")


# ==================== ROLE-SPECIFIC DETAILS ====================

# Similar endpoints for academy_details, clinic_details, coach_details, etc.
# For brevity, I'll include just the academy endpoints as an example

@router.get("/academy-details", response_model=AcademyDetailsResponse)
async def get_academy_details(current_user: dict = Depends(get_current_user)):
    """Get current user's academy details"""
    details = await database.fetch_one(
        "SELECT * FROM academy_details WHERE user_id = :user_id",
        {"user_id": current_user["id"]}
    )

    if not details:
        raise HTTPException(status_code=404, detail="Academy details not found")

    return dict(details)


@router.put("/academy-details", response_model=AcademyDetailsResponse)
async def update_academy_details(
    updates: AcademyDetailsUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update academy details"""
    update_data = updates.dict(exclude_unset=True)

    if not update_data:
        raise HTTPException(status_code=400, detail="No fields to update")

    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE academy_details SET {set_clause}, updated_at = NOW() WHERE user_id = :user_id RETURNING *"

    update_data["user_id"] = current_user["id"]

    details = await database.fetch_one(query=query, values=update_data)

    if not details:
        raise HTTPException(status_code=404, detail="Academy details not found")

    return dict(details)
