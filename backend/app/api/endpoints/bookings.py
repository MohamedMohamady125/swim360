"""
Booking management endpoints
"""
from typing import List, Optional
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user
from app.schemas.booking import *

router = APIRouter(prefix="/bookings", tags=["Bookings"])


@router.get("", response_model=List[BookingResponse])
async def list_bookings(
    status_filter: Optional[BookingStatus] = None,
    provider_id: Optional[str] = None,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """List bookings for current user (as swimmer or provider)"""
    conditions = []
    params = {"user_id": current_user["id"]}

    # User can see their own bookings (as swimmer or provider)
    conditions.append("(swimmer_id = :user_id OR provider_id = :user_id)")

    if status_filter:
        conditions.append("status = :status")
        params["status"] = status_filter.value

    if provider_id:
        conditions.append("provider_id = :provider_id")
        params["provider_id"] = provider_id

    if from_date:
        conditions.append("booking_date >= :from_date")
        params["from_date"] = from_date

    if to_date:
        conditions.append("booking_date <= :to_date")
        params["to_date"] = to_date

    where_clause = " AND ".join(conditions)
    params["skip"] = skip
    params["limit"] = limit

    query = f"""
        SELECT * FROM bookings
        WHERE {where_clause}
        ORDER BY booking_date DESC, booking_time DESC
        LIMIT :limit OFFSET :skip
    """

    bookings = await database.fetch_all(query, params)
    return [dict(b) for b in bookings]


@router.post("", response_model=BookingResponse, status_code=status.HTTP_201_CREATED)
async def create_booking(
    booking: BookingCreate,
    current_user: dict = Depends(get_current_user)
):
    """Create a new booking"""
    query = """
        INSERT INTO bookings (
            swimmer_id, provider_id, provider_type, program_id, service_id,
            session_id, branch_id, booking_date, booking_time, amount, currency,
            swimmer_notes, created_at, updated_at
        ) VALUES (
            :swimmer_id, :provider_id, :provider_type, :program_id, :service_id,
            :session_id, :branch_id, :booking_date, :booking_time, :amount, :currency,
            :swimmer_notes, NOW(), NOW()
        ) RETURNING *
    """

    values = booking.dict()
    values["swimmer_id"] = current_user["id"]

    new_booking = await database.fetch_one(query=query, values=values)
    return dict(new_booking)


@router.put("/{booking_id}", response_model=BookingResponse)
async def update_booking(
    booking_id: str,
    updates: BookingUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update booking status or details"""
    # Check access (swimmer or provider)
    existing = await database.fetch_one(
        "SELECT * FROM bookings WHERE id = :booking_id AND (swimmer_id = :user_id OR provider_id = :user_id)",
        {"booking_id": booking_id, "user_id": current_user["id"]}
    )

    if not existing:
        raise HTTPException(status_code=404, detail="Booking not found or access denied")

    update_data = updates.dict(exclude_unset=True)
    if not update_data:
        return dict(existing)

    # Handle status changes with timestamps
    if "status" in update_data:
        if update_data["status"] == BookingStatus.CONFIRMED.value:
            update_data["confirmed_at"] = "NOW()"
        elif update_data["status"] == BookingStatus.COMPLETED.value:
            update_data["completed_at"] = "NOW()"
        elif update_data["status"] == BookingStatus.CANCELLED.value:
            update_data["cancelled_at"] = "NOW()"

    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE bookings SET {set_clause}, updated_at = NOW() WHERE id = :booking_id RETURNING *"
    update_data["booking_id"] = booking_id

    updated_booking = await database.fetch_one(query=query, values=update_data)
    return dict(updated_booking)
