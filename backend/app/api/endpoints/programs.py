"""
Program management endpoints (Academies & Coaches)
"""
from typing import List, Optional
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user, require_provider, get_current_user_optional
from app.schemas.program import (
    ProgramCreate, ProgramUpdate, ProgramResponse,
    ProgramListResponse, ProgramEnrollmentCreate, ProgramEnrollmentResponse,
    ProgramFilterParams, ProgramCategory
)
from app.schemas.common import UserRole

router = APIRouter(prefix="/programs", tags=["Programs"])


@router.get("", response_model=ProgramListResponse)
async def list_programs(
    category: Optional[ProgramCategory] = None,
    provider_type: Optional[UserRole] = None,
    provider_id: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    city: Optional[str] = None,
    governorate: Optional[str] = None,
    is_featured: Optional[bool] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    current_user: Optional[dict] = Depends(get_current_user_optional)
):
    """
    List all active programs with filters
    Public endpoint (authentication optional)
    """
    conditions = ["is_active = true"]
    params = {}

    if category:
        conditions.append("category = :category")
        params["category"] = category.value

    if provider_type:
        conditions.append("provider_type = :provider_type")
        params["provider_type"] = provider_type.value

    if provider_id:
        conditions.append("provider_id = :provider_id")
        params["provider_id"] = provider_id

    if min_price is not None:
        conditions.append("price >= :min_price")
        params["min_price"] = min_price

    if max_price is not None:
        conditions.append("price <= :max_price")
        params["max_price"] = max_price

    if is_featured is not None:
        conditions.append("is_featured = :is_featured")
        params["is_featured"] = is_featured

    where_clause = " AND ".join(conditions)

    # Count total
    count_query = f"SELECT COUNT(*) as count FROM programs WHERE {where_clause}"
    count_result = await database.fetch_one(count_query, params)
    total = count_result["count"]

    # Fetch programs
    params["skip"] = skip
    params["limit"] = limit

    query = f"""
        SELECT * FROM programs
        WHERE {where_clause}
        ORDER BY is_featured DESC, created_at DESC
        LIMIT :limit OFFSET :skip
    """

    programs = await database.fetch_all(query, params)

    return ProgramListResponse(
        total=total,
        programs=[dict(p) for p in programs]
    )


@router.get("/{program_id}", response_model=ProgramResponse)
async def get_program(program_id: str):
    """Get program by ID"""
    program = await database.fetch_one(
        "SELECT * FROM programs WHERE id = :program_id",
        {"program_id": program_id}
    )

    if not program:
        raise HTTPException(status_code=404, detail="Program not found")

    return dict(program)


@router.post("", response_model=ProgramResponse, status_code=status.HTTP_201_CREATED)
async def create_program(
    program: ProgramCreate,
    current_user: dict = Depends(require_provider)
):
    """Create a new program (Academy or Coach only)"""
    # Verify role
    allowed_roles = [UserRole.ACADEMY.value, UserRole.ONLINE_COACH.value]
    if current_user["role"] not in allowed_roles:
        raise HTTPException(
            status_code=403,
            detail="Only academies and online coaches can create programs"
        )

    query = """
        INSERT INTO programs (
            provider_id, provider_type, program_name, category, description,
            duration_weeks, sessions_per_week, session_duration_minutes,
            price, currency, cover_photo_url, intro_video_url, max_participants,
            created_at, updated_at
        ) VALUES (
            :provider_id, :provider_type, :program_name, :category, :description,
            :duration_weeks, :sessions_per_week, :session_duration_minutes,
            :price, :currency, :cover_photo_url, :intro_video_url, :max_participants,
            NOW(), NOW()
        ) RETURNING *
    """

    values = program.dict()
    values["provider_id"] = current_user["id"]
    values["provider_type"] = current_user["role"]

    new_program = await database.fetch_one(query=query, values=values)

    return dict(new_program)


@router.put("/{program_id}", response_model=ProgramResponse)
async def update_program(
    program_id: str,
    updates: ProgramUpdate,
    current_user: dict = Depends(require_provider)
):
    """Update a program (owner only)"""
    # Check ownership
    existing = await database.fetch_one(
        "SELECT * FROM programs WHERE id = :program_id AND provider_id = :user_id",
        {"program_id": program_id, "user_id": current_user["id"]}
    )

    if not existing:
        raise HTTPException(status_code=404, detail="Program not found or access denied")

    update_data = updates.dict(exclude_unset=True)

    if not update_data:
        return dict(existing)

    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE programs SET {set_clause}, updated_at = NOW() WHERE id = :program_id RETURNING *"

    update_data["program_id"] = program_id

    updated_program = await database.fetch_one(query=query, values=update_data)

    return dict(updated_program)


@router.delete("/{program_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_program(
    program_id: str,
    current_user: dict = Depends(require_provider)
):
    """Delete a program (owner only)"""
    result = await database.execute(
        "DELETE FROM programs WHERE id = :program_id AND provider_id = :user_id",
        {"program_id": program_id, "user_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Program not found or access denied")


@router.post("/{program_id}/enroll", response_model=ProgramEnrollmentResponse)
async def enroll_in_program(
    program_id: str,
    enrollment: ProgramEnrollmentCreate,
    current_user: dict = Depends(get_current_user)
):
    """Enroll in a program (Swimmers only)"""
    if current_user["role"] != UserRole.SWIMMER.value:
        raise HTTPException(status_code=403, detail="Only swimmers can enroll in programs")

    # Check if program exists
    program = await database.fetch_one(
        "SELECT * FROM programs WHERE id = :program_id AND is_active = true",
        {"program_id": program_id}
    )

    if not program:
        raise HTTPException(status_code=404, detail="Program not found")

    # Check if already enrolled
    existing = await database.fetch_one(
        "SELECT * FROM program_enrollments WHERE swimmer_id = :swimmer_id AND program_id = :program_id AND is_active = true",
        {"swimmer_id": current_user["id"], "program_id": program_id}
    )

    if existing:
        raise HTTPException(status_code=400, detail="Already enrolled in this program")

    # Create enrollment
    query = """
        INSERT INTO program_enrollments (
            swimmer_id, program_id, start_date, amount_paid, created_at, updated_at
        ) VALUES (
            :swimmer_id, :program_id, :start_date, :amount_paid, NOW(), NOW()
        ) RETURNING *
    """

    new_enrollment = await database.fetch_one(
        query=query,
        values={
            "swimmer_id": current_user["id"],
            "program_id": program_id,
            "start_date": enrollment.start_date,
            "amount_paid": program["price"]
        }
    )

    # Update program participant count
    await database.execute(
        "UPDATE programs SET current_participants = current_participants + 1, total_enrollments = total_enrollments + 1 WHERE id = :program_id",
        {"program_id": program_id}
    )

    return dict(new_enrollment)


@router.get("/enrollments/my", response_model=List[ProgramEnrollmentResponse])
async def get_my_enrollments(current_user: dict = Depends(get_current_user)):
    """Get current user's program enrollments"""
    enrollments = await database.fetch_all(
        "SELECT * FROM program_enrollments WHERE swimmer_id = :swimmer_id ORDER BY created_at DESC",
        {"swimmer_id": current_user["id"]}
    )

    return [dict(e) for e in enrollments]
