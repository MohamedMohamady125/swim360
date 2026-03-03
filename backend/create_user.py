"""
Script to manually create a user in the database
"""
import asyncio
import sys
from uuid import uuid4
from passlib.context import CryptContext
from app.core.database import database

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def create_user(email: str, password: str, full_name: str):
    """Create a user directly in the database"""

    # Connect to database
    await database.connect()

    try:
        # Hash password
        hashed_password = pwd_context.hash(password)
        user_id = str(uuid4())

        # Insert into profiles table
        query = """
            INSERT INTO profiles (
                id, email, role, full_name, password_hash,
                created_at, updated_at
            ) VALUES (
                :id, :email, :role, :full_name, :password_hash,
                NOW(), NOW()
            )
            RETURNING id, email, full_name, role
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": user_id,
                "email": email,
                "role": "swimmer",
                "full_name": full_name,
                "password_hash": hashed_password,
            }
        )

        print(f"✅ User created successfully!")
        print(f"   ID: {result['id']}")
        print(f"   Email: {result['email']}")
        print(f"   Name: {result['full_name']}")
        print(f"   Role: {result['role']}")

    except Exception as e:
        print(f"❌ Error creating user: {e}")
        sys.exit(1)
    finally:
        await database.disconnect()

if __name__ == "__main__":
    email = "mohamadhany97@gmail.com"
    password = "MmmM1234!"
    full_name = "Mohamed Mohamady"

    asyncio.run(create_user(email, password, full_name))
