from supabase import create_client, Client
from .config import settings
import logging
from typing import Optional

logger = logging.getLogger(__name__)

class Database:
    _instance: Optional[Client] = None
    
    @classmethod
    def get_client(cls) -> Client:
        """Get Supabase client singleton"""
        if cls._instance is None:
            try:
                cls._instance = create_client(
                    settings.supabase_url,
                    settings.supabase_service_key  # Use service key for backend
                )
                logger.info("Supabase client initialized successfully")
            except Exception as e:
                logger.error(f"Failed to initialize Supabase client: {e}")
                raise
        return cls._instance
    
    @classmethod
    def reset_client(cls):
        """Reset client (useful for testing)"""
        cls._instance = None

# Global database instance
db = Database.get_client()