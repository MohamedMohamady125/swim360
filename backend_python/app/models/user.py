# WHAT IT DOES:
# 1. Defines User table structure
# 2. Defines Profile table structure
# 3. Defines UserRole table structure
# 4. Sets up relationships

from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship

class User(Base):
    """Auth user model"""
    __tablename__ = "users"
    
    id = Column(String, primary_key=True)
    email = Column(String, unique=True, nullable=False)
    full_name = Column(String, nullable=False)
    is_email_verified = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    profile = relationship("Profile", back_populates="user")
    roles = relationship("UserRole", back_populates="user")

class Profile(Base):
    """User profile model"""
    __tablename__ = "profiles"
    
    id = Column(String, ForeignKey("users.id"), primary_key=True)
    phone = Column(String)
    avatar_url = Column(String)
    bio = Column(String)
    location = Column(JSON)
    
class UserRole(Base):
    """User roles model"""
    __tablename__ = "user_roles"
    
    id = Column(String, primary_key=True)
    user_id = Column(String, ForeignKey("users.id"))
    role = Column(String)  # customer, coach, vendor, etc.
    is_active = Column(Boolean, default=True)