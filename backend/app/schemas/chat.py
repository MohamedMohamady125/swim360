"""
Chat and messaging schemas
"""
from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel, UUID4, Field
from app.schemas.common import TimestampMixin


class ConversationCreate(BaseModel):
    """Create conversation"""
    participant_2_id: UUID4


class MessageCreate(BaseModel):
    """Create message"""
    conversation_id: UUID4
    message_text: str = Field(..., min_length=1)
    attachment_url: Optional[str] = None
    attachment_type: Optional[str] = None


class MessageResponse(BaseModel):
    """Message response"""
    id: UUID4
    conversation_id: UUID4
    sender_id: UUID4
    message_text: str
    attachment_url: Optional[str] = None
    attachment_type: Optional[str] = None
    is_read: bool
    read_at: Optional[datetime] = None
    is_deleted: bool
    created_at: datetime

    class Config:
        from_attributes = True


class ConversationResponse(TimestampMixin):
    """Conversation response"""
    id: UUID4
    participant_1_id: UUID4
    participant_2_id: UUID4
    last_message_at: Optional[datetime] = None
    last_message_preview: Optional[str] = None
    is_active: bool

    # Optional: include last message
    last_message: Optional[MessageResponse] = None

    class Config:
        from_attributes = True


class ConversationListResponse(BaseModel):
    """List of conversations"""
    total: int
    conversations: List[ConversationResponse]


class MessageListResponse(BaseModel):
    """List of messages"""
    total: int
    messages: List[MessageResponse]


class MarkMessageReadRequest(BaseModel):
    """Mark message as read"""
    message_id: UUID4
