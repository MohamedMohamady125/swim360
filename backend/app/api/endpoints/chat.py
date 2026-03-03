"""
Chat and messaging endpoints
"""
from typing import List
from fastapi import APIRouter, HTTPException, status, Depends, Query
from app.core.database import database
from app.api.dependencies.auth import get_current_user
from app.schemas.chat import *

router = APIRouter(prefix="/chat", tags=["Chat & Messaging"])


@router.get("/conversations", response_model=ConversationListResponse)
async def list_conversations(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """List all conversations for current user"""
    query = """
        SELECT * FROM conversations
        WHERE (participant_1_id = :user_id OR participant_2_id = :user_id)
        AND is_active = true
        ORDER BY last_message_at DESC NULLS LAST
        LIMIT :limit OFFSET :skip
    """

    conversations = await database.fetch_all(
        query,
        {"user_id": current_user["id"], "skip": skip, "limit": limit}
    )

    count_query = """
        SELECT COUNT(*) as count FROM conversations
        WHERE (participant_1_id = :user_id OR participant_2_id = :user_id)
        AND is_active = true
    """

    count_result = await database.fetch_one(count_query, {"user_id": current_user["id"]})

    return ConversationListResponse(
        total=count_result["count"],
        conversations=[dict(c) for c in conversations]
    )


@router.post("/conversations", response_model=ConversationResponse, status_code=status.HTTP_201_CREATED)
async def create_conversation(
    data: ConversationCreate,
    current_user: dict = Depends(get_current_user)
):
    """Create a new conversation or get existing one"""
    # Check if conversation already exists
    existing = await database.fetch_one(
        """
        SELECT * FROM conversations
        WHERE ((participant_1_id = :user_id AND participant_2_id = :other_user_id)
        OR (participant_1_id = :other_user_id AND participant_2_id = :user_id))
        """,
        {"user_id": current_user["id"], "other_user_id": data.participant_2_id}
    )

    if existing:
        return dict(existing)

    # Create new conversation
    query = """
        INSERT INTO conversations (
            participant_1_id, participant_2_id, created_at, updated_at
        ) VALUES (
            :participant_1_id, :participant_2_id, NOW(), NOW()
        ) RETURNING *
    """

    new_conversation = await database.fetch_one(
        query,
        {"participant_1_id": current_user["id"], "participant_2_id": data.participant_2_id}
    )

    return dict(new_conversation)


@router.get("/conversations/{conversation_id}/messages", response_model=MessageListResponse)
async def list_messages(
    conversation_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """List messages in a conversation"""
    # Verify user is participant
    conversation = await database.fetch_one(
        """
        SELECT * FROM conversations
        WHERE id = :conversation_id
        AND (participant_1_id = :user_id OR participant_2_id = :user_id)
        """,
        {"conversation_id": conversation_id, "user_id": current_user["id"]}
    )

    if not conversation:
        raise HTTPException(status_code=404, detail="Conversation not found or access denied")

    # Fetch messages
    query = """
        SELECT * FROM messages
        WHERE conversation_id = :conversation_id
        AND is_deleted = false
        ORDER BY created_at DESC
        LIMIT :limit OFFSET :skip
    """

    messages = await database.fetch_all(
        query,
        {"conversation_id": conversation_id, "skip": skip, "limit": limit}
    )

    count_query = """
        SELECT COUNT(*) as count FROM messages
        WHERE conversation_id = :conversation_id AND is_deleted = false
    """

    count_result = await database.fetch_one(count_query, {"conversation_id": conversation_id})

    return MessageListResponse(
        total=count_result["count"],
        messages=[dict(m) for m in messages]
    )


@router.post("/messages", response_model=MessageResponse, status_code=status.HTTP_201_CREATED)
async def send_message(
    message: MessageCreate,
    current_user: dict = Depends(get_current_user)
):
    """Send a message in a conversation"""
    # Verify user is participant
    conversation = await database.fetch_one(
        """
        SELECT * FROM conversations
        WHERE id = :conversation_id
        AND (participant_1_id = :user_id OR participant_2_id = :user_id)
        """,
        {"conversation_id": message.conversation_id, "user_id": current_user["id"]}
    )

    if not conversation:
        raise HTTPException(status_code=404, detail="Conversation not found or access denied")

    # Create message
    query = """
        INSERT INTO messages (
            conversation_id, sender_id, message_text, attachment_url,
            attachment_type, created_at
        ) VALUES (
            :conversation_id, :sender_id, :message_text, :attachment_url,
            :attachment_type, NOW()
        ) RETURNING *
    """

    new_message = await database.fetch_one(
        query=query,
        values={
            **message.dict(),
            "sender_id": current_user["id"]
        }
    )

    # Update conversation last message
    await database.execute(
        """
        UPDATE conversations
        SET last_message_at = NOW(),
            last_message_preview = :preview,
            updated_at = NOW()
        WHERE id = :conversation_id
        """,
        {
            "conversation_id": message.conversation_id,
            "preview": message.message_text[:100]
        }
    )

    return dict(new_message)


@router.put("/messages/{message_id}/read")
async def mark_message_read(
    message_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Mark a message as read"""
    result = await database.execute(
        """
        UPDATE messages
        SET is_read = true, read_at = NOW()
        WHERE id = :message_id
        AND conversation_id IN (
            SELECT id FROM conversations
            WHERE participant_1_id = :user_id OR participant_2_id = :user_id
        )
        """,
        {"message_id": message_id, "user_id": current_user["id"]}
    )

    if result == 0:
        raise HTTPException(status_code=404, detail="Message not found or access denied")

    return {"success": True, "message": "Message marked as read"}
