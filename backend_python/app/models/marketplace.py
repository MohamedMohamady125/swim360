# WHAT IT DOES:
# 1. Defines Product table
# 2. Defines category relationships
# 3. Handles inventory tracking
# 4. Manages product attributes

class Product(Base):
    """Marketplace product"""
    __tablename__ = "marketplace_listings"
    
    id = Column(String, primary_key=True)
    seller_id = Column(String, ForeignKey("users.id"))
    title = Column(String, nullable=False)
    description = Column(Text)
    category = Column(String)
    price = Column(Float)
    condition = Column(String)  # 'new' or 'used'
    quantity = Column(Integer, default=1)
    images = Column(JSON)
    attributes = Column(JSON)  # Size, color, etc.
    is_active = Column(Boolean, default=True)
    is_sold = Column(Boolean, default=False)