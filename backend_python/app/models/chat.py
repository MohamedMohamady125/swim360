# WHAT IT DOES:
# 1. Defines Conversation table
# 2. Defines Message table
# 3. Tracks read status
# 4. Handles attachments

class Conversation(Base):
    """Chat conversation"""
    __tablename__ = "conversations"
    
    id = Column(String, primary_key=True)
    participant_1_id = Column(String, ForeignKey("users.id"))
    participant_2_id = Column(String, ForeignKey("users.id"))
    last_message_at = Column(DateTime)
    is_active = Column(Boolean, default=True)

class Message(Base):
    """Chat message"""
    __tablename__ = "messages"
    
    id = Column(String, primary_key=True)
    conversation_id = Column(String, ForeignKey("conversations.id"))
    sender_id = Column(String, ForeignKey("users.id"))
    text = Column(Text)
    attachments = Column(JSON)
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)