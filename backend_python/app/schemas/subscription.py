# WHAT IT DOES:
# 1. Validates subscription plans
# 2. Handles payment data
# 3. Validates billing cycles
# 4. Tracks usage limits

class SubscriptionPlan(BaseModel):
    """Subscription plan"""
    role: str
    plan: str  # 'free' or 'premium'
    price_monthly: float
    price_annual: float
    max_listings: int = None
    features: List[str]

class SubscribeRequest(BaseModel):
    """Subscribe to plan"""
    plan_id: str
    billing_cycle: str  # 'monthly' or 'annual'
    payment_method: str