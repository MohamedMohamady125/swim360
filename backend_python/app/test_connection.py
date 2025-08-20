import asyncio
from supabase import create_client, Client
import os
from dotenv import load_dotenv
import random
import string

load_dotenv()

async def test_connection():
    try:
        # Your credentials
        supabase_url = "https://lemmqyevlipsexqxvgpd.supabase.co"
        supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlbW1xeWV2bGlwc2V4cXh2Z3BkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUzOTc3ODQsImV4cCI6MjA3MDk3Mzc4NH0.SaIzDRTMf_Nn3qA0j5LyPC9F6XdvYnPXKSVuOmG4_fg"
        
        # Create client
        supabase: Client = create_client(supabase_url, supabase_key)
        
        print("✅ Connected to Supabase!")
        
        # Generate random email to avoid duplicates
        random_suffix = ''.join(random.choices(string.ascii_lowercase + string.digits, k=6))
        test_email = f"test_{random_suffix}@gmail.com"
        
        print(f"\n📝 Testing user creation with email: {test_email}")
        
        try:
            # First, try to sign up
            response = supabase.auth.sign_up({
                "email": test_email,
                "password": "Test123!456"
            })
            
            if response.user:
                print(f"✅ User created successfully!")
                print(f"   User ID: {response.user.id}")
                print(f"   Email: {response.user.email}")
                
                # Try to create profile
                profile_data = {
                    "id": response.user.id,
                    "email": test_email,
                    "full_name": "Test User",
                    "is_email_verified": False
                }
                
                profile_response = supabase.table("profiles").insert(profile_data).execute()
                
                if profile_response.data:
                    print(f"✅ Profile created successfully!")
                else:
                    print("❌ Failed to create profile")
                    
            else:
                print("❌ Failed to create user - check Supabase email settings")
                
        except Exception as auth_error:
            print(f"❌ Auth Error: {auth_error}")
            
        # Test database connection
        print("\n📊 Testing database access...")
        try:
            # Try to read from profiles table
            result = supabase.table("profiles").select("*").limit(1).execute()
            print(f"✅ Database access successful! Found {len(result.data)} profiles")
        except Exception as db_error:
            print(f"❌ Database Error: {db_error}")
            print("   Make sure you've created the tables in Supabase SQL Editor")
        
    except Exception as e:
        print(f"❌ Connection Error: {e}")

if __name__ == "__main__":
    asyncio.run(test_connection())