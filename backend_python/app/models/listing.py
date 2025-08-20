# WHAT IT DOES:
# 1. Defines ServiceListing table
# 2. Defines listing attributes
# 3. Sets up location relationships
# 4. Handles schedule data

class ServiceListing(Base):
    """Swimming/Fitness service listing"""
    __tablename__ = "service_listings"
    
    id = Column(String, primary_key=True)
    provider_id = Column(String, ForeignKey("users.id"))
    title = Column(String, nullable=False)
    description = Column(Text)
    service_type = Column(String)  # 'swimming' or 'fitness'
    price_per_session = Column(Float)
    schedule_data = Column(JSON)  # Complex schedule
    age_group = Column(String)
    skill_level = Column(String)
    max_participants = Column(Integer)
    images = Column(JSON)
    is_active = Column(Boolean, default=True)
    is_promoted = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)