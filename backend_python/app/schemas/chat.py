# WHAT IT DOES:
# 1. Validates message content
# 2. Handles attachments
# 3. Validates conversation data
# 4. Manages read receipts

class SendMessageRequest(BaseModel):
    """Send message request"""
    recipient_id: str
    text: str
    listing_id: str = None  # Related listing
    
    @validator('text')
    def validate_text(cls, v):
        if len(v) > 1000:
            raise ValueError('Message too long')
        return v

class MessageResponse(BaseModel):
    """Message response"""
    id: str
    sender_id: str
    text: str
    created_at: datetime
    is_read: bool