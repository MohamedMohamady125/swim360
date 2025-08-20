# WHAT IT DOES:
# 1. Validates profile updates
# 2. Validates role enrollment
# 3. Defines user response format
# 4. Handles nested data

class UserProfile(BaseModel):
    """User profile schema"""
    id: str
    email: str
    full_name: str
    phone: str = None
    avatar_url: str = None
    bio: str = None
    roles: List[str] = []
    is_verified: bool = False

class UpdateProfileRequest(BaseModel):
    """Profile update request"""
    full_name: str = None
    phone: str = None
    bio: str = None
    avatar_url: str = None

class EnrollRoleRequest(BaseModel):
    """Role enrollment request"""
    role: str  # coach, vendor, etc.
    plan: str = "free"
    offers_swimming: bool = False
    offers_fitness: bool = False
    business_name: str = None