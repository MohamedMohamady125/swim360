# WHAT IT DOES:
# 1. Validates product data
# 2. Validates categories
# 3. Handles product attributes
# 4. Validates inventory

class CreateProductRequest(BaseModel):
    """Create product listing"""
    title: str
    description: str
    category: str
    price: float
    condition: str  # 'new' or 'used'
    quantity: int = 1
    images: List[str]
    attributes: dict = {}  # Size, color, etc.
    
    @validator('condition')
    def validate_condition(cls, v):
        if v not in ['new', 'used']:
            raise ValueError('Condition must be new or used')
        return v

class ProductResponse(BaseModel):
    """Product response"""
    id: str
    title: str
    price: float
    condition: str
    seller_name: str
    seller_type: str  # individual, reseller, vendor
    images: List[str]