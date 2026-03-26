"""
Clinic API endpoints
"""
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import UUID4

from app.core.database import database
from app.api.dependencies.auth import get_current_user
from app.schemas.clinic import (
    ClinicDetails, ClinicDetailsCreate, ClinicDetailsUpdate,
    ClinicBranch, ClinicBranchCreate, ClinicBranchUpdate,
    ClinicService, ClinicServiceCreate, ClinicServiceUpdate,
    ClinicBooking, ClinicBookingCreate, ClinicBookingUpdate
)

router = APIRouter(prefix="/clinics", tags=["Clinics"])


# ============================================
# PUBLIC LIST-ALL ENDPOINTS (must be before /{id} routes)
# ============================================

@router.get("/all", response_model=List[ClinicDetails])
async def get_all_clinics():
    """Get all clinics (public)"""
    result = await database.fetch_all(
        "SELECT * FROM clinic_details ORDER BY created_at DESC"
    )
    return result


@router.get("/branches/all", response_model=List[ClinicBranch])
async def get_all_clinic_branches():
    """Get all clinic branches (public)"""
    result = await database.fetch_all(
        "SELECT * FROM clinic_branches ORDER BY created_at DESC"
    )
    return result


@router.get("/services/all", response_model=List[ClinicService])
async def get_all_clinic_services():
    """Get all clinic services (public)"""
    result = await database.fetch_all(
        "SELECT * FROM clinic_services ORDER BY created_at DESC"
    )
    return result


# ============================================
# CLINIC DETAILS ENDPOINTS
# ============================================

@router.post("/details", response_model=ClinicDetails, status_code=status.HTTP_201_CREATED)
async def create_clinic_details(details: ClinicDetailsCreate, current_user: dict = Depends(get_current_user)):
    """Create clinic details for the current user"""
    # Check if clinic details already exist
    existing = await database.fetch_one(
        "SELECT user_id FROM clinic_details WHERE user_id = :user_id",
        {"user_id": current_user["id"]}
    )

    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Clinic details already exist"
        )

    query = """
        INSERT INTO clinic_details (
            user_id, clinic_name, description, website_url,
            license_number, specializations, created_at, updated_at
        ) VALUES (
            :user_id, :clinic_name, :description, :website_url,
            :license_number, :specializations, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **details.dict()
    })

    return result


@router.get("/details", response_model=ClinicDetails)
async def get_my_clinic_details(current_user: dict = Depends(get_current_user)):
    """Get clinic details for the current user"""
    result = await database.fetch_one(
        "SELECT * FROM clinic_details WHERE user_id = :user_id",
        {"user_id": current_user["id"]}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Clinic details not found"
        )

    return result


@router.get("/details/{user_id}", response_model=ClinicDetails)
async def get_clinic_details(user_id: UUID4):
    """Get clinic details by user ID (public)"""
    result = await database.fetch_one(
        "SELECT * FROM clinic_details WHERE user_id = :user_id",
        {"user_id": str(user_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Clinic details not found"
        )

    return result


@router.put("/details", response_model=ClinicDetails)
async def update_clinic_details(details: ClinicDetailsUpdate, current_user: dict = Depends(get_current_user)):
    """Update clinic details for the current user"""
    update_fields = {k: v for k, v in details.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE clinic_details
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
            detail="Clinic details not found"
        )

    return result


# ============================================
# CLINIC BRANCH ENDPOINTS
# ============================================

@router.post("/branches", response_model=ClinicBranch, status_code=status.HTTP_201_CREATED)
async def create_branch(branch: ClinicBranchCreate, current_user: dict = Depends(get_current_user)):
    """Create a new clinic branch"""
    query = """
        INSERT INTO clinic_branches (
            user_id, location_name, governorate, city, location_url,
            number_of_beds, opening_hour, opening_minute, opening_ampm,
            closing_hour, closing_minute, closing_ampm, services_offered,
            created_at, updated_at
        ) VALUES (
            :user_id, :location_name, :governorate, :city, :location_url,
            :number_of_beds, :opening_hour, :opening_minute, :opening_ampm,
            :closing_hour, :closing_minute, :closing_ampm, :services_offered,
            NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **branch.dict()
    })

    return result


@router.get("/branches", response_model=List[ClinicBranch])
async def get_my_branches(current_user: dict = Depends(get_current_user)):
    """Get all branches for the current user's clinic"""
    result = await database.fetch_all(
        "SELECT * FROM clinic_branches WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/branches/clinic/{user_id}", response_model=List[ClinicBranch])
async def get_clinic_branches(user_id: UUID4):
    """Get all branches for a specific clinic (public)"""
    result = await database.fetch_all(
        "SELECT * FROM clinic_branches WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": str(user_id)}
    )

    return result


@router.get("/branches/{branch_id}", response_model=ClinicBranch)
async def get_branch(branch_id: UUID4):
    """Get a specific branch by ID"""
    result = await database.fetch_one(
        "SELECT * FROM clinic_branches WHERE id = :id",
        {"id": str(branch_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    return result


@router.put("/branches/{branch_id}", response_model=ClinicBranch)
async def update_branch(branch_id: UUID4, branch: ClinicBranchUpdate, current_user: dict = Depends(get_current_user)):
    """Update a clinic branch"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM clinic_branches WHERE id = :id",
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
        UPDATE clinic_branches
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
    """Delete a clinic branch"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM clinic_branches WHERE id = :id",
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
        "DELETE FROM clinic_branches WHERE id = :id",
        {"id": str(branch_id)}
    )


# ============================================
# CLINIC SERVICE ENDPOINTS
# ============================================

@router.post("/services", response_model=ClinicService, status_code=status.HTTP_201_CREATED)
async def create_service(service: ClinicServiceCreate, current_user: dict = Depends(get_current_user)):
    """Create a new clinic service"""
    query = """
        INSERT INTO clinic_services (
            user_id, title, category, price, duration, description,
            video_url, photo_url, created_at, updated_at
        ) VALUES (
            :user_id, :title, :category, :price, :duration, :description,
            :video_url, :photo_url, NOW(), NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "user_id": current_user["id"],
        **service.dict()
    })

    return result


@router.get("/services", response_model=List[ClinicService])
async def get_my_services(current_user: dict = Depends(get_current_user)):
    """Get all services for the current user's clinic"""
    result = await database.fetch_all(
        "SELECT * FROM clinic_services WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": current_user["id"]}
    )

    return result


@router.get("/services/clinic/{user_id}", response_model=List[ClinicService])
async def get_clinic_services(user_id: UUID4):
    """Get all services for a specific clinic (public)"""
    result = await database.fetch_all(
        "SELECT * FROM clinic_services WHERE user_id = :user_id ORDER BY created_at DESC",
        {"user_id": str(user_id)}
    )

    return result


@router.get("/services/{service_id}", response_model=ClinicService)
async def get_service(service_id: UUID4):
    """Get a specific service by ID"""
    result = await database.fetch_one(
        "SELECT * FROM clinic_services WHERE id = :id",
        {"id": str(service_id)}
    )

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Service not found"
        )

    return result


@router.put("/services/{service_id}", response_model=ClinicService)
async def update_service(service_id: UUID4, service: ClinicServiceUpdate, current_user: dict = Depends(get_current_user)):
    """Update a clinic service"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM clinic_services WHERE id = :id",
        {"id": str(service_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Service not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this service"
        )

    update_fields = {k: v for k, v in service.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE clinic_services
        SET {set_clause}, updated_at = NOW()
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(service_id),
        **update_fields
    })

    return result


@router.delete("/services/{service_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_service(service_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a clinic service"""
    # Verify ownership
    existing = await database.fetch_one(
        "SELECT user_id FROM clinic_services WHERE id = :id",
        {"id": str(service_id)}
    )

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Service not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this service"
        )

    await database.execute(
        "DELETE FROM clinic_services WHERE id = :id",
        {"id": str(service_id)}
    )


# ============================================
# CLINIC BOOKING ENDPOINTS
# ============================================

@router.post("/bookings", response_model=ClinicBooking, status_code=status.HTTP_201_CREATED)
async def create_booking(booking: ClinicBookingCreate, current_user: dict = Depends(get_current_user)):
    """Create a new clinic booking"""
    # Verify branch ownership
    branch = await database.fetch_one(
        "SELECT user_id FROM clinic_branches WHERE id = :id",
        {"id": str(booking.branch_id)}
    )

    if not branch:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    if str(branch["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to create bookings for this branch"
        )

    query = """
        INSERT INTO clinic_bookings (
            branch_id, service_id, client_name, client_age, phone,
            booking_date, booking_time, bed_number, created_at
        ) VALUES (
            :branch_id, :service_id, :client_name, :client_age, :phone,
            :booking_date, :booking_time, :bed_number, NOW()
        )
        RETURNING *
    """

    result = await database.fetch_one(query, booking.dict())

    return result


@router.get("/bookings/branch/{branch_id}", response_model=List[ClinicBooking])
async def get_branch_bookings(branch_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Get all bookings for a specific branch"""
    # Verify ownership
    branch = await database.fetch_one(
        "SELECT user_id FROM clinic_branches WHERE id = :id",
        {"id": str(branch_id)}
    )

    if not branch:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Branch not found"
        )

    if str(branch["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to view bookings for this branch"
        )

    result = await database.fetch_all(
        "SELECT * FROM clinic_bookings WHERE branch_id = :branch_id ORDER BY booking_date DESC, booking_time DESC",
        {"branch_id": str(branch_id)}
    )

    return result


@router.get("/bookings", response_model=List[ClinicBooking])
async def get_my_bookings(current_user: dict = Depends(get_current_user)):
    """Get all bookings for the current user's clinic"""
    result = await database.fetch_all("""
        SELECT cb.*
        FROM clinic_bookings cb
        JOIN clinic_branches br ON cb.branch_id = br.id
        WHERE br.user_id = :user_id
        ORDER BY cb.booking_date DESC, cb.booking_time DESC
    """, {"user_id": current_user["id"]})

    return result


@router.get("/bookings/{booking_id}", response_model=ClinicBooking)
async def get_booking(booking_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Get a specific booking by ID"""
    result = await database.fetch_one("""
        SELECT cb.*
        FROM clinic_bookings cb
        JOIN clinic_branches br ON cb.branch_id = br.id
        WHERE cb.id = :id AND br.user_id = :user_id
    """, {"id": str(booking_id), "user_id": current_user["id"]})

    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )

    return result


@router.put("/bookings/{booking_id}", response_model=ClinicBooking)
async def update_booking(booking_id: UUID4, booking: ClinicBookingUpdate, current_user: dict = Depends(get_current_user)):
    """Update a clinic booking"""
    # Verify ownership through branch
    existing = await database.fetch_one("""
        SELECT cb.*, br.user_id
        FROM clinic_bookings cb
        JOIN clinic_branches br ON cb.branch_id = br.id
        WHERE cb.id = :id
    """, {"id": str(booking_id)})

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this booking"
        )

    update_fields = {k: v for k, v in booking.dict(exclude_unset=True).items() if v is not None}

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    set_clause = ", ".join([f"{k} = :{k}" for k in update_fields.keys()])
    query = f"""
        UPDATE clinic_bookings
        SET {set_clause}
        WHERE id = :id
        RETURNING *
    """

    result = await database.fetch_one(query, {
        "id": str(booking_id),
        **update_fields
    })

    return result


@router.delete("/bookings/{booking_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_booking(booking_id: UUID4, current_user: dict = Depends(get_current_user)):
    """Delete a clinic booking"""
    # Verify ownership through branch
    existing = await database.fetch_one("""
        SELECT cb.*, br.user_id
        FROM clinic_bookings cb
        JOIN clinic_branches br ON cb.branch_id = br.id
        WHERE cb.id = :id
    """, {"id": str(booking_id)})

    if not existing:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )

    if str(existing["user_id"]) != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this booking"
        )

    await database.execute(
        "DELETE FROM clinic_bookings WHERE id = :id",
        {"id": str(booking_id)}
    )
