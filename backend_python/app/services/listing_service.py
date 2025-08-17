from typing import List, Dict, Optional
from app.core.database import db
from datetime import datetime

class ListingService:
    
    async def create_service_listing(self, user_id: str, listing_data: Dict) -> Dict:
        """Create a new service listing (swimming/fitness)"""
        
        # Check user's subscription
        subscription = db.table("user_subscriptions")\
            .select("*")\
            .eq("user_id", user_id)\
            .eq("status", "active")\
            .execute()
        
        if not subscription.data:
            return {"success": False, "error": "No active subscription"}
        
        # Check listing limit
        can_create = db.rpc("can_create_listing", {
            "p_user_id": user_id,
            "p_role": listing_data["provider_role"]
        }).execute()
        
        if not can_create.data[0]["can_create"]:
            return {"success": False, "error": can_create.data[0]["message"]}
        
        # Create listing
        listing = {
            "provider_id": user_id,
            "title": listing_data["title"],
            "description": listing_data["description"],
            "service_type": listing_data["service_type"],  # swimming or fitness
            "price_per_session": listing_data["price"],
            "schedule_data": listing_data["schedule"],
            "age_group": listing_data["age_group"],
            "skill_level": listing_data["skill_level"],
            "max_participants": listing_data.get("max_participants"),
            "is_active": True
        }
        
        result = db.table("service_listings").insert(listing).execute()
        
        return {
            "success": True,
            "listing_id": result.data[0]["id"],
            "message": "Listing created successfully"
        }
    
    async def get_listings(self, service_type: Optional[str] = None, 
                          governorate_id: Optional[int] = None) -> List[Dict]:
        """Get all active listings with filters"""
        
        query = db.table("service_listings").select(
            "*",
            "profiles(full_name, avatar_url)",
            "locations(governorate_id, city_id)"
        ).eq("is_active", True)
        
        if service_type:
            query = query.eq("service_type", service_type)
        
        result = query.execute()
        return result.data