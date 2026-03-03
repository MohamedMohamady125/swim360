"""
Service management endpoints (Clinics)
"""
from typing import List, Optional
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user, require_clinic, get_current_user_optional
from app.schemas.service import (
    ServiceCreate, ServiceUpdate, ServiceResponse,
    ServiceListResponse, ServiceFilterParams, ServiceCategory
)

router = APIRouter(prefix="/services", tags=["Services"])


@router.get("", response_model=ServiceListResponse)
async def list_services(
    category: Optional[ServiceCategory] = None,
    clinic_id: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    city: Optional[str] = None,
    governorate: Optional[str] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    current_user: Optional[dict] = Depends(get_current_user_optional)
):
    """List all active services with filters"""
    conditions = ["is_active = true"]
    params = {}

    if category:
        conditions.append("category = :category")
        params["category"] = category.value

    if clinic_id:
        conditions.append("clinic_id = :clinic_id")
        params["clinic_id"] = clinic_id

    if min_price is not None:
        conditions.append("price >= :min_price")
        params["min_price"] = min_price

    if max_price is not None:
        conditions.append("price <= :max_price")
        params["max_price"] = max_price

    where_clause = " AND ".join(conditions)

    # Count total
    count_query = f"SELECT COUNT(*) as count FROM services WHERE {where_clause}"
    count_result = await database.fetch_one(count_query, params)
    total = count_result["count"]

    # Fetch services
    params["skip"] = skip
    params["limit"] = limit

    query = f"""
        SELECT * FROM services
        WHERE {where_clause}
        ORDER BY created_at DESC
        LIMIT :limit OFFSET :skip
    """

    services = await database.fetch_all(query, params)

    return ServiceListResponse(
        total=total,
        services=[dict(s) for s in services]
    )


@router.get("/{service_id}", response_model=ServiceResponse)
async def get_service(service_id: str):
    """Get service by ID"""
    service = await database.fetch_one(
        "SELECT * FROM services WHERE id = :service_id",
        {"service_id": service_id}
    )

    if not service:
        raise HTTPException(status_code=404, detail="Service not found")

    return dict(service)


@router.post("", response_model=ServiceResponse, status_code=status.HTTP_201_CREATED)
async def create_service(
    service: ServiceCreate,
    current_user: dict = Depends(require_clinic)
):
    """Create a new service (Clinic only)"""
    query = """
        INSERT INTO services (
            clinic_id, service_name, category, description,
            price, duration_minutes, currency, cover_photo_url, intro_video_url,
            created_at, updated_at
        ) VALUES (
            :clinic_id, :service_name, :category, :description,
            :price, :duration_minutes, :currency, :cover_photo_url, :intro_video_url,
            NOW(), NOW()
        ) RETURNING *
    """

    values = service.dict()
    values["clinic_id"] = current_user["id"]

    new_service = await database.fetch_one(query=query, values=values)

    return dict(new_service)


@router.put("/{service_id}", response_model=ServiceResponse)
async def update_service(
    service_id: str,
    updates: ServiceUpdate,
    current_user: dict = Depends(require_clinic)
):
    """Update a service (owner only)"""
    # Check ownership
    existing = await database.fetch_one(
        "SELECT * FROM services WHERE id = :service_id AND clinic_id = :user_id",
        {"service_id": service_id, "user_id": current_user["id"]}
    )

    if not existing:
        raise HTTPException(status_code=404, detail="Service not found or access denied")

    update_data = updates.dict(exclude_unset=True)

    if not update_data:
        return dict(existing)

    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE services SET {set_clause}, updated_at = NOW() WHERE id = :service_id RETURNING *"

    update_data["service_id"] = service_id

    updated_service = await database.fetch_one(query=query, values=update_data)

    return dict(updated_service)


@router.delete("/{service_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_service(
    service_id: str,
    current_user: dict = Depends(require_clinic)
):
    """Delete a service (owner only)"""
    result = await database.execute(
        "DELETE FROM services WHERE id = :service_id AND clinic_id = :user_id",
        {"service_id": service_id, "user_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Service not found or access denied")
