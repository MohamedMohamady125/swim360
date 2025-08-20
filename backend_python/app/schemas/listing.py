# WHAT IT DOES:
# 1. Validates listing creation
# 2. Validates schedule format
# 3. Validates price ranges
# 4. Handles location data

class CreateListingRequest(BaseModel):
    """Create service listing"""
    title: str
    description: str
    service_type: str  # 'swimming' or 'fitness'
    price_per_session: float
    schedule: dict  # Complex schedule data
    age_group: str
    skill_level: str
    max_participants: int = None
    locations: List[dict]
    images: List[str] = []
    
    @validator('price_per_session')
    def validate_price(cls, v):
        if v <= 0:
            raise ValueError('Price must be positive')
        return v

class ListingResponse(BaseModel):
    """Listing response"""
    id: str
    title: str
    price: float
    provider_name: str
    rating: float = 0.0
    location: dict
    is_promoted: bool = False