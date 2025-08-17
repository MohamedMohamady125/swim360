from supabase import create_client, Client
from typing import Optional
import os

class Database:
    _instance: Optional[Client] = None
    
    @classmethod
    def get_instance(cls) -> Client:
        if cls._instance is None:
            cls._instance = create_client(
                os.getenv("SUPABASE_URL"),
                os.getenv("SUPABASE_SERVICE_KEY")
            )
        return cls._instance

# Global database instance
db = Database.get_instance()