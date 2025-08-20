# WHAT IT DOES:
# 1. Defines Review table
# 2. Tracks ratings
# 3. Handles provider responses
# 4. Manages verification status

class Review(Base):
    """User review"""
    __tablename__ = "reviews"
    
    id = Column(String, primary_key=True)
    reviewer_id = Column(String, ForeignKey("users.id"))
    reviewed_entity_id = Column(String)
    entity_type = Column(String)  # 'coach', 'product', etc.
    rating = Column(Integer)  # 1-5
    comment = Column(Text)
    provider_response = Column(Text)
    is_verified_purchase = Column(Boolean)
    created_at = Column(DateTime)