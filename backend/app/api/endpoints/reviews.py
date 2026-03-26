"""
Reviews, ratings, favorites, and notifications
"""
from typing import List, Optional
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user
from app.schemas.review import *

router = APIRouter(prefix="/reviews", tags=["Reviews & Social"])


# ==================== REVIEWS ====================

@router.get("", response_model=ReviewListResponse)
async def list_reviews(
    target_id: Optional[str] = None,
    target_type: Optional[str] = None,
    min_rating: Optional[int] = Query(None, ge=1, le=5),
    verified_only: bool = False,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100)
):
    """List reviews with filters"""
    conditions = ["r.is_active = true"]
    params = {}

    if target_id:
        conditions.append("target_id = :target_id")
        params["target_id"] = target_id

    if target_type:
        conditions.append("target_type = :target_type")
        params["target_type"] = target_type

    if min_rating is not None:
        conditions.append("rating >= :min_rating")
        params["min_rating"] = min_rating

    if verified_only:
        conditions.append("is_verified_purchase = true")

    where_clause = " AND ".join(conditions)

    # Count total
    count_query = f"SELECT COUNT(*) as count FROM reviews r WHERE {where_clause}"
    count_result = await database.fetch_one(count_query, params)

    # Calculate average rating
    avg_query = f"SELECT AVG(r.rating)::float as avg_rating FROM reviews r WHERE {where_clause}"
    avg_result = await database.fetch_one(avg_query, params)

    params["skip"] = skip
    params["limit"] = limit

    # Fetch reviews
    query = f"""
        SELECT r.*, p.full_name as reviewer_name, p.profile_photo_url as reviewer_photo
        FROM reviews r
        LEFT JOIN profiles p ON r.reviewer_id = p.id
        WHERE {where_clause}
        ORDER BY r.created_at DESC
        LIMIT :limit OFFSET :skip
    """

    reviews = await database.fetch_all(query, params)

    return ReviewListResponse(
        total=count_result["count"],
        average_rating=avg_result["avg_rating"] or 0.0,
        reviews=[dict(r) for r in reviews]
    )


@router.post("", response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
async def create_review(
    review: ReviewCreate,
    current_user: dict = Depends(get_current_user)
):
    """Create a new review"""
    # Check if already reviewed
    existing = await database.fetch_one(
        """
        SELECT * FROM reviews
        WHERE reviewer_id = :reviewer_id AND target_id = :target_id AND target_type = :target_type
        """,
        {
            "reviewer_id": current_user["id"],
            "target_id": review.target_id,
            "target_type": review.target_type
        }
    )

    if existing:
        raise HTTPException(status_code=400, detail="You have already reviewed this item")

    # Create review
    query = """
        INSERT INTO reviews (
            reviewer_id, target_id, target_type, rating, title, comment, photos,
            created_at, updated_at
        ) VALUES (
            :reviewer_id, :target_id, :target_type, :rating, :title, :comment, :photos,
            NOW(), NOW()
        ) RETURNING *
    """

    new_review = await database.fetch_one(
        query=query,
        values={
            **review.dict(),
            "reviewer_id": current_user["id"]
        }
    )

    return dict(new_review)


@router.put("/{review_id}", response_model=ReviewResponse)
async def update_review(
    review_id: str,
    updates: ReviewUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update own review"""
    existing = await database.fetch_one(
        "SELECT * FROM reviews WHERE id = :review_id AND reviewer_id = :user_id",
        {"review_id": review_id, "user_id": current_user["id"]}
    )

    if not existing:
        raise HTTPException(status_code=404, detail="Review not found or access denied")

    update_data = updates.dict(exclude_unset=True)
    if not update_data:
        return dict(existing)

    set_clause = ", ".join([f"{key} = :{key}" for key in update_data.keys()])
    query = f"UPDATE reviews SET {set_clause}, updated_at = NOW() WHERE id = :review_id RETURNING *"
    update_data["review_id"] = review_id

    updated_review = await database.fetch_one(query=query, values=update_data)
    return dict(updated_review)


# ==================== FAVORITES ====================

@router.get("/favorites", response_model=List[FavoriteResponse])
async def list_favorites(
    item_type: Optional[str] = None,
    current_user: dict = Depends(get_current_user)
):
    """Get current user's favorites"""
    conditions = ["user_id = :user_id"]
    params = {"user_id": current_user["id"]}

    if item_type:
        conditions.append("item_type = :item_type")
        params["item_type"] = item_type

    where_clause = " AND ".join(conditions)

    query = f"""
        SELECT * FROM favorites
        WHERE {where_clause}
        ORDER BY created_at DESC
    """

    favorites = await database.fetch_all(query, params)
    return [dict(f) for f in favorites]


@router.post("/favorites", response_model=FavoriteResponse, status_code=status.HTTP_201_CREATED)
async def add_favorite(
    favorite: FavoriteCreate,
    current_user: dict = Depends(get_current_user)
):
    """Add item to favorites"""
    # Check if already favorited
    existing = await database.fetch_one(
        "SELECT * FROM favorites WHERE user_id = :user_id AND item_id = :item_id AND item_type = :item_type",
        {
            "user_id": current_user["id"],
            "item_id": favorite.item_id,
            "item_type": favorite.item_type
        }
    )

    if existing:
        return dict(existing)

    # Add favorite
    query = """
        INSERT INTO favorites (user_id, item_id, item_type, created_at)
        VALUES (:user_id, :item_id, :item_type, NOW())
        RETURNING *
    """

    new_favorite = await database.fetch_one(
        query=query,
        values={
            **favorite.dict(),
            "user_id": current_user["id"]
        }
    )

    return dict(new_favorite)


@router.delete("/favorites/{favorite_id}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_favorite(
    favorite_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Remove item from favorites"""
    result = await database.execute(
        "DELETE FROM favorites WHERE id = :favorite_id AND user_id = :user_id",
        {"favorite_id": favorite_id, "user_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Favorite not found")


# ==================== NOTIFICATIONS ====================

@router.get("/notifications", response_model=NotificationListResponse)
async def list_notifications(
    unread_only: bool = False,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Get current user's notifications"""
    conditions = ["user_id = :user_id"]
    params = {"user_id": current_user["id"]}

    if unread_only:
        conditions.append("is_read = false")

    where_clause = " AND ".join(conditions)

    # Count total and unread
    count_query = f"SELECT COUNT(*) as count FROM notifications WHERE user_id = :user_id"
    count_result = await database.fetch_one(count_query, {"user_id": current_user["id"]})

    unread_query = f"SELECT COUNT(*) as count FROM notifications WHERE user_id = :user_id AND is_read = false"
    unread_result = await database.fetch_one(unread_query, {"user_id": current_user["id"]})

    params["skip"] = skip
    params["limit"] = limit

    query = f"""
        SELECT * FROM notifications
        WHERE {where_clause}
        ORDER BY created_at DESC
        LIMIT :limit OFFSET :skip
    """

    notifications = await database.fetch_all(query, params)

    return NotificationListResponse(
        total=count_result["count"],
        unread_count=unread_result["count"],
        notifications=[dict(n) for n in notifications]
    )


@router.put("/notifications/{notification_id}/read")
async def mark_notification_read(
    notification_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Mark notification as read"""
    result = await database.execute(
        "UPDATE notifications SET is_read = true, read_at = NOW() WHERE id = :notification_id AND user_id = :user_id",
        {"notification_id": notification_id, "user_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Notification not found")

    return {"success": True, "message": "Notification marked as read"}


@router.put("/notifications/read-all")
async def mark_all_notifications_read(current_user: dict = Depends(get_current_user)):
    """Mark all notifications as read"""
    await database.execute(
        "UPDATE notifications SET is_read = true, read_at = NOW() WHERE user_id = :user_id AND is_read = false",
        {"user_id": current_user["id"]}
    )

    return {"success": True, "message": "All notifications marked as read"}
