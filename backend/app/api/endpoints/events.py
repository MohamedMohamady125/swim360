"""
Event management endpoints
"""
from typing import List, Optional
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user, require_event_organizer, get_current_user_optional
from app.schemas.event import *

router = APIRouter(prefix="/events", tags=["Events"])


@router.get("", response_model=EventListResponse)
async def list_events(
    event_type: Optional[EventType] = None,
    organizer_id: Optional[str] = None,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    city: Optional[str] = None,
    governorate: Optional[str] = None,
    is_online: Optional[bool] = None,
    is_featured: Optional[bool] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100)
):
    """List all active events with filters"""
    conditions = ["is_active = true"]
    params = {}

    if event_type:
        conditions.append("event_type = :event_type")
        params["event_type"] = event_type.value

    if organizer_id:
        conditions.append("organizer_id = :organizer_id")
        params["organizer_id"] = organizer_id

    if from_date:
        conditions.append("event_date >= :from_date")
        params["from_date"] = from_date

    if to_date:
        conditions.append("event_date <= :to_date")
        params["to_date"] = to_date

    if city:
        conditions.append("city ILIKE :city")
        params["city"] = f"%{city}%"

    if governorate:
        conditions.append("governorate ILIKE :governorate")
        params["governorate"] = f"%{governorate}%"

    if is_online is not None:
        conditions.append("is_online = :is_online")
        params["is_online"] = is_online

    if is_featured is not None:
        conditions.append("is_featured = :is_featured")
        params["is_featured"] = is_featured

    where_clause = " AND ".join(conditions)

    count_query = f"SELECT COUNT(*) as count FROM events WHERE {where_clause}"
    count_result = await database.fetch_one(count_query, params)
    total = count_result["count"]

    params["skip"] = skip
    params["limit"] = limit

    query = f"""
        SELECT * FROM events
        WHERE {where_clause}
        ORDER BY is_featured DESC, event_date ASC
        LIMIT :limit OFFSET :skip
    """

    events = await database.fetch_all(query, params)

    return EventListResponse(
        total=total,
        events=[dict(e) for e in events]
    )


@router.post("", response_model=EventResponse, status_code=status.HTTP_201_CREATED)
async def create_event(
    event: EventCreate,
    current_user: dict = Depends(require_event_organizer)
):
    """Create a new event (Event Organizer only)"""
    query = """
        INSERT INTO events (
            organizer_id, event_name, event_type, description, event_date,
            start_time, end_time, venue_name, address, city, governorate,
            latitude, longitude, is_online, online_meeting_url, max_participants,
            registration_fee, registration_deadline, cover_photo_url, gallery_photos,
            created_at, updated_at
        ) VALUES (
            :organizer_id, :event_name, :event_type, :description, :event_date,
            :start_time, :end_time, :venue_name, :address, :city, :governorate,
            :latitude, :longitude, :is_online, :online_meeting_url, :max_participants,
            :registration_fee, :registration_deadline, :cover_photo_url, :gallery_photos,
            NOW(), NOW()
        ) RETURNING *
    """

    values = event.dict()
    values["organizer_id"] = current_user["id"]

    new_event = await database.fetch_one(query=query, values=values)
    return dict(new_event)


@router.post("/{event_id}/register", response_model=EventRegistrationResponse)
async def register_for_event(
    event_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Register for an event"""
    # Check if event exists
    event = await database.fetch_one(
        "SELECT * FROM events WHERE id = :event_id AND is_active = true",
        {"event_id": event_id}
    )

    if not event:
        raise HTTPException(status_code=404, detail="Event not found")

    # Check if already registered
    existing = await database.fetch_one(
        "SELECT * FROM event_registrations WHERE event_id = :event_id AND user_id = :user_id AND is_cancelled = false",
        {"event_id": event_id, "user_id": current_user["id"]}
    )

    if existing:
        raise HTTPException(status_code=400, detail="Already registered for this event")

    # Create registration
    query = """
        INSERT INTO event_registrations (
            event_id, user_id, amount_paid, created_at, updated_at
        ) VALUES (
            :event_id, :user_id, :amount_paid, NOW(), NOW()
        ) RETURNING *
    """

    new_registration = await database.fetch_one(
        query=query,
        values={
            "event_id": event_id,
            "user_id": current_user["id"],
            "amount_paid": event["registration_fee"]
        }
    )

    # Update event participant count
    await database.execute(
        "UPDATE events SET current_participants = current_participants + 1 WHERE id = :event_id",
        {"event_id": event_id}
    )

    return dict(new_registration)
