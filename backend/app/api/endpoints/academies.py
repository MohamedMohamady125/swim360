"""
Academy API endpoints
"""
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import UUID4

from app.core.database import database
from app.api.dependencies.auth import get_current_user
from app.schemas.academy import (
    AcademyDetails, AcademyDetailsCreate, AcademyDetailsUpdate,
    AcademyBranch, AcademyBranchCreate, AcademyBranchUpdate,
    AcademyPool, AcademyPoolCreate, AcademyPoolUpdate,
    AcademyProgram, AcademyProgramCreate, AcademyProgramUpdate,
    AcademySwimmer, AcademySwimmerCreate, AcademySwimmerUpdate,
    AcademyCoach, AcademyCoachCreate, AcademyCoachUpdate
)

router = APIRouter(prefix="/academies", tags=["Academies"])


# ============================================
# ACADEMY DETAILS ENDPOINTS
# ============================================

@router.post("/details", response_model=AcademyDetails, status_code=status.HTTP_201_CREATED)
async def create_academy_details(details: AcademyDetailsCreate, current_user: dict = Depends(get_current_user)):
    """Create academy details for the current user"""
    # Check if academy details already exist
    existing = await database.fetch_one(
        "SELECT user_id FROM academy_details WHERE user_id = :user_id",
        {"user_id": current_user["id"]}
    )

    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Academy details already exist"
        )

    query = """
        INSERT INTO academy_details (
            user_id, academy_name, description, website_url,
            license_number, established_year, created_at, updated_at
        ) VALUES (
            :user_id, :academy_name, :description, :website_url,
            :license_number, :established_year, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **details.dict()
    })

    return result


@router.get("/details", response_model=AcademyDetails)
async def get_my_academy_details(current_user: dict = Depends(get_current_user)):
    """Get academy details for the current user"""
    result = await database.fetch_one(
        "SELECT * FROM academy_details WHERE user_id = :user_id",
        {"user_id": current_user["id"]}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Academy details not found"
        )

    return result


@router.get("/details/{user_id}", response_model=AcademyDetails)
async def get_academy_details(user_id: UUID4):
    """Get academy details by user ID (public)"""
    result = await database.fetch_one(
        "SELECT * FROM academy_details WHERE user_id = :user_id",
        {"user_id": str(user_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Academy details not found"
        )

    return result


@router.put("/details", response_model=AcademyDetails)
async def update_academy_details(details: AcademyDetailsUpdate, current_user: dict = Depends(get_current_user)):
    """Update academy details for the current user"""
    # Build update query dynamically based on provided fields
    update_fields = {k: v for k, v in details.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE academy_details
        SET {set_clause}, updated_at = NOW()
        WHERE user_id = :user_id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **update_fields
    })

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Academy details not found"
        )

    return result


# ============================================
# ACADEMY BRANCH ENDPOINTS
# ============================================

@router.post("/branches", response_model=AcademyBranch, status_code=status.HTTP_201_CREATED)
async def create_branch(branch: AcademyBranchCreate, current_user: dict = Depends(get_current_user)):
    """Create a new academy branch"""
    query = """
        INSERT INTO academy_branches (
            user_id, name, city, governorate, location_url,
            opening_time, closing_time, operating_days, created_at, updated_at
        ) VALUES (
            :user_id, :name, :city, :governorate, :location_url,
            :opening_time, :closing_time, :operating_days, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **branch.dict()
    })

    return result


@router.get("/branches", response_model=List[AcademyBranch])
async def get_my_branches(current_user: dict = Depends(get_current_user)):
    """Get all branches for the current user's academy"""
    result = await database.fetch_all(
        "SELECT * FROM academy_branches WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/branches/academy/{user_id}", response_model=List[AcademyBranch])
async def get_academy_branches(user_id: UUID4):
    """Get all branches for a specific academy (public)"""
    result = await database.fetch_all(
        "SELECT * FROM academy_branches WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": str(user_id)}
    )

    return result


@router.get("/branches/{branch_id}", response_model=AcademyBranch)
async def get_branch(branch_id: UUID4):
    """Get a specific branch by ID"""
    result = await database.fetch_one(
        "SELECT * FROM academy_branches WHERE id = :id",
        {"id": str(branch_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    return result


@router.put("/branches/{branch_id}", response_model=AcademyBranch)
async def update_branch(branch_id: UUID4, branch: AcademyBranchUpdate, current_user: dict = Depends(get_current_user)):
    """Update an academy branch"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM academy_branches WHERE id = :id",
        {"id": str(branch_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this branch"
        )

    update_fields = {k: v for k, v in branch.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE academy_branches
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(branch_id),
        **update_fields
    })

    return result


@router.delete("/branches/{branch_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_branch(branch_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete an academy branch"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM academy_branches WHERE id = :id",
        {"id": str(branch_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this branch"
        )

    await database.execute(
        "DELETE FROM academy_branches WHERE id = :id",
        {"id": str(branch_id)}
    )


# ============================================
# ACADEMY POOL ENDPOINTS
# ============================================

@router.post("/pools", response_model=AcademyPool, status_code=status.HTTP_201_CREATED)
async def create_pool(pool: AcademyPoolCreate, current_user: dict = Depends(get_current_user)):
    """Create a new pool for a branch"""
    # Verify branch ownership
    branch = await database.fetch_one(
        "SELECT user_id FROM academy_branches WHERE id = :id",
        {"id": str(pool.branch_id)}
    )

    if not branch:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    if str(branch["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to add pools to this branch"
        )

    query = """
        INSERT INTO academy_pools (
            branch_id, name, lanes, capacity, created_at
        ) VALUES (
            :branch_id, :name, :lanes, :capacity, NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, pool.dict())

    return result


@router.get("/pools/branch/{branch_id}", response_model=List[AcademyPool])
async def get_branch_pools(branch_id: UUID4):
    """Get all pools for a branch"""
    result = await database.fetch_all(
        "SELECT * FROM academy_pools WHERE branch_id = :branch_id ORDER BY created_at DESC",
        {"branch_id": str(branch_id)}
    )

    return result


@router.put("/pools/{pool_id}", response_model=AcademyPool)
async def update_pool(pool_id: UUID4, pool: AcademyPoolUpdate, current_user: dict = Depends(get_current_user)):
    """Update a pool"""
    # Verify ownership through branch
    existing = await database.fetch_one("""
        SELECT ap.*, ab.user_id
        FROM academy_pools ap
        JOIN academy_branches ab ON ap.branch_id = ab.id
        WHERE ap.id = :id
    """, {"id": str(pool_id)})

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pool not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this pool"
        )

    update_fields = {k: v for k, v in pool.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE academy_pools
        SET {set_clause}
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(pool_id),
        **update_fields
    })

    return result


@router.delete("/pools/{pool_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_pool(pool_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a pool"""
    # Verify ownership through branch
    existing = await database.fetch_one("""
        SELECT ap.*, ab.user_id
        FROM academy_pools ap
        JOIN academy_branches ab ON ap.branch_id = ab.id
        WHERE ap.id = :id
    """, {"id": str(pool_id)})

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pool not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this pool"
        )

    await database.execute(
        "DELETE FROM academy_pools WHERE id = :id",
        {"id": str(pool_id)}
    )


# ============================================
# ACADEMY PROGRAM ENDPOINTS
# ============================================

@router.post("/programs", response_model=AcademyProgram, status_code=status.HTTP_201_CREATED)
async def create_program(program: AcademyProgramCreate, current_user: dict = Depends(get_current_user)):
    """Create a new academy program"""
    query = """
        INSERT INTO academy_programs (
            user_id, name, description, price, duration, capacity, created_at, updated_at
        ) VALUES (
            :user_id, :name, :description, :price, :duration, :capacity, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **program.dict()
    })

    return result


@router.get("/programs", response_model=List[AcademyProgram])
async def get_my_programs(current_user: dict = Depends(get_current_user)):
    """Get all programs for the current user's academy"""
    result = await database.fetch_all(
        "SELECT * FROM academy_programs WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/programs/academy/{user_id}", response_model=List[AcademyProgram])
async def get_academy_programs(user_id: UUID4):
    """Get all programs for a specific academy (public)"""
    result = await database.fetch_all(
        "SELECT * FROM academy_programs WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": str(user_id)}
    )

    return result


@router.get("/programs/{program_id}", response_model=AcademyProgram)
async def get_program(program_id: UUID4):
    """Get a specific program by ID"""
    result = await database.fetch_one(
        "SELECT * FROM academy_programs WHERE id = :id",
        {"id": str(program_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Program not found"
        )

    return result


@router.put("/programs/{program_id}", response_model=AcademyProgram)
async def update_program(program_id: UUID4, program: AcademyProgramUpdate, current_user: dict = Depends(get_current_user)):
    """Update an academy program"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM academy_programs WHERE id = :id",
        {"id": str(program_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Program not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this program"
        )

    update_fields = {k: v for k, v in program.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE academy_programs
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(program_id),
        **update_fields
    })

    return result


@router.delete("/programs/{program_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_program(program_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete an academy program"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM academy_programs WHERE id = :id",
        {"id": str(program_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Program not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this program"
        )

    await database.execute(
        "DELETE FROM academy_programs WHERE id = :id",
        {"id": str(program_id)}
    )


# ============================================
# ACADEMY SWIMMER ENDPOINTS
# ============================================

@router.post("/swimmers", response_model=AcademySwimmer, status_code=status.HTTP_201_CREATED)
async def create_swimmer(swimmer: AcademySwimmerCreate, current_user: dict = Depends(get_current_user)):
    """Add a new swimmer to the academy"""
    query = """
        INSERT INTO academy_swimmers (
            user_id, swimmer_name, phone, program_id, branch_id, end_date, created_at
        ) VALUES (
            :user_id, :swimmer_name, :phone, :program_id, :branch_id, :end_date, NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **swimmer.dict()
    })

    # Update enrolled count if program_id is provided
    if swimmer.program_id:
        await database.execute("""
            UPDATE academy_programs
            SET enrolled = enrolled + 1
            WHERE id = :program_id
        """, {"program_id": str(swimmer.program_id)})

    return result


@router.get("/swimmers", response_model=List[AcademySwimmer])
async def get_my_swimmers(current_user: dict = Depends(get_current_user)):
    """Get all swimmers for the current user's academy"""
    result = await database.fetch_all(
        "SELECT * FROM academy_swimmers WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/swimmers/{swimmer_id}", response_model=AcademySwimmer)
async def get_swimmer(swimmer_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Get a specific swimmer by ID"""
    result = await database.fetch_one(
        "SELECT * FROM academy_swimmers WHERE id = :id AND user_id = :user_id",
        {"id": str(swimmer_id), "user_id": current_user["id"]}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Swimmer not found"
        )

    return result


@router.put("/swimmers/{swimmer_id}", response_model=AcademySwimmer)
async def update_swimmer(swimmer_id: UUID4, swimmer: AcademySwimmerUpdate, current_user: dict = Depends(get_current_user)):
    """Update a swimmer's information"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id, program_id FROM academy_swimmers WHERE id = :id",
        {"id": str(swimmer_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Swimmer not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this swimmer"
        )

    update_fields = {k: v for k, v in swimmer.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    # Handle program change
    old_program_id = existing["program_id"]
    new_program_id = update_fields.get("program_id")

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE academy_swimmers
        SET {set_clause}
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(swimmer_id),
        **update_fields
    })

    # Update enrolled counts if program changed
    if new_program_id and old_program_id != new_program_id:
        if old_program_id:
            await database.execute("""
                UPDATE academy_programs
                SET enrolled = GREATEST(enrolled - 1, 0)
                WHERE id = :program_id
            """, {"program_id": str(old_program_id)})

        await database.execute("""
            UPDATE academy_programs
            SET enrolled = enrolled + 1
            WHERE id = :program_id
        """, {"program_id": str(new_program_id)})

    return result


@router.delete("/swimmers/{swimmer_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_swimmer(swimmer_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a swimmer from the academy"""
    # Verify ownership and get program_id for enrolled count update
    existing = await database.fetch_one(
        "SELECT user_id, program_id FROM academy_swimmers WHERE id = :id",
        {"id": str(swimmer_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Swimmer not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this swimmer"
        )

    await database.execute(
        "DELETE FROM academy_swimmers WHERE id = :id",
        {"id": str(swimmer_id)}
    )

    # Update enrolled count if swimmer was in a program
    if existing["program_id"]:
        await database.execute("""
            UPDATE academy_programs
            SET enrolled = GREATEST(enrolled - 1, 0)
            WHERE id = :program_id
        """, {"program_id": str(existing["program_id"])})


# ============================================
# ACADEMY COACH ENDPOINTS
# ============================================

@router.post("/coaches", response_model=AcademyCoach, status_code=status.HTTP_201_CREATED)
async def create_coach(coach: AcademyCoachCreate, current_user: dict = Depends(get_current_user)):
    """Add a new coach to the academy"""
    query = """
        INSERT INTO academy_coaches (
            academy_id, branch_id, full_name, email, phone, photo_url,
            specialization, experience_years, certifications, bio, created_at, updated_at
        ) VALUES (
            :academy_id, :branch_id, :full_name, :email, :phone, :photo_url,
            :specialization, :experience_years, :certifications, :bio, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "academy_id": current_user["id"],
        **coach.dict()
    })

    # Update total_coaches count
    await database.execute("""
        UPDATE academy_details
        SET total_coaches = total_coaches + 1
        WHERE user_id = :user_id
    """, {"user_id": current_user["id"]})

    return result


@router.get("/coaches", response_model=List[AcademyCoach])
async def get_my_coaches(current_user: dict = Depends(get_current_user)):
    """Get all coaches for the current user's academy"""
    result = await database.fetch_all(
        "SELECT * FROM academy_coaches WHERE academy_id = :academy_id ORDER BY created_at DESC",
        {"academy_id": current_user["id"]}
    )

    return result


@router.get("/coaches/academy/{user_id}", response_model=List[AcademyCoach])
async def get_academy_coaches(user_id: UUID4):
    """Get all coaches for a specific academy (public)"""
    result = await database.fetch_all(
        "SELECT * FROM academy_coaches WHERE academy_id = :academy_id AND is_active = true ORDER BY created_at DESC",
        {"academy_id": str(user_id)}
    )

    return result


@router.get("/coaches/{coach_id}", response_model=AcademyCoach)
async def get_coach(coach_id: UUID4):
    """Get a specific coach by ID"""
    result = await database.fetch_one(
        "SELECT * FROM academy_coaches WHERE id = :id",
        {"id": str(coach_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Coach not found"
        )

    return result


@router.put("/coaches/{coach_id}", response_model=AcademyCoach)
async def update_coach(coach_id: UUID4, coach: AcademyCoachUpdate, current_user: dict = Depends(get_current_user)):
    """Update a coach's information"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT academy_id FROM academy_coaches WHERE id = :id",
        {"id": str(coach_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Coach not found"
        )

    if str(existing["academy_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this coach"
        )

    update_fields = {k: v for k, v in coach.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE academy_coaches
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(coach_id),
        **update_fields
    })

    return result


@router.delete("/coaches/{coach_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_coach(coach_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a coach from the academy"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT academy_id FROM academy_coaches WHERE id = :id",
        {"id": str(coach_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Coach not found"
        )

    if str(existing["academy_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this coach"
        )

    await database.execute(
        "DELETE FROM academy_coaches WHERE id = :id",
        {"id": str(coach_id)}
    )

    # Update total_coaches count
    await database.execute("""
        UPDATE academy_details
        SET total_coaches = GREATEST(total_coaches - 1, 0)
        WHERE user_id = :user_id
    """, {"user_id": current_user["id"]})
