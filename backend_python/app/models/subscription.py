# WHAT IT DOES:
# 1. Defines subscription plans
# 2. Tracks user subscriptions
# 3. Manages billing cycles
# 4. Handles payment history

class Subscription(Base):
    """User subscription"""
    __tablename__ = "user_subscriptions"
    
    id = Column(String, primary_key=True)
    user_id = Column(String, ForeignKey("users.id"))
    role = Column(String)  # coach, vendor, etc.
    plan = Column(String)  # 'free' or 'premium'
    status = Column(String)  # 'active', 'expired', 'cancelled'
    price_paid = Column(Float)
    started_at = Column(DateTime)
    expires_at = Column(DateTime)
    listings_used = Column(Integer, default=0)
    max_listings = Column(Integer)