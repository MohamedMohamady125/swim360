"""
Script to verify all tables have at least 5 rows
"""
import asyncio
from databases import Database
from app.core.config import settings

# Create database instance
db_url = str(settings.database_url)
if db_url.startswith("postgres://"):
    ASYNC_DATABASE_URL = db_url.replace("postgres://", "postgresql+asyncpg://")
elif db_url.startswith("postgresql://"):
    ASYNC_DATABASE_URL = db_url.replace("postgresql://", "postgresql+asyncpg://")
else:
    ASYNC_DATABASE_URL = db_url

database = Database(ASYNC_DATABASE_URL, min_size=1, max_size=3)

async def check_table_counts():
    """Check row counts for all major tables"""
    print("=" * 60)
    print("📊 DATABASE TABLE ROW COUNTS")
    print("=" * 60)

    tables = [
        'profiles',
        'academy_branches',
        'academy_pools',
        'academy_programs',
        'academy_swimmers',
        'clinic_branches',
        'clinic_services',
        'clinic_bookings',
        'products',
        'orders',
        'order_items',
        'used_items',
        'events',
        'event_registrations',
        'reviews',
        'notifications',
    ]

    total_pass = 0
    total_tables = len(tables)

    for table in tables:
        try:
            query = f"SELECT COUNT(*) as count FROM {table}"
            result = await database.fetch_one(query)
            count = result['count'] if result else 0

            status = "✅" if count >= 5 else "⚠️ "
            if count >= 5:
                total_pass += 1

            print(f"{status} {table:30} {count:5} rows")
        except Exception as e:
            print(f"❌ {table:30} Error: {str(e)[:40]}")

    print("\n" + "=" * 60)
    print(f"SUMMARY: {total_pass}/{total_tables} tables have >= 5 rows")
    print("=" * 60)

async def main():
    try:
        await database.connect()
        await check_table_counts()
    except Exception as e:
        print(f"\n❌ Error: {e}")
    finally:
        await database.disconnect()

if __name__ == "__main__":
    asyncio.run(main())
