"""
Script to seed notifications
"""
import asyncio
from uuid import uuid4
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

async def seed_notifications():
    """Seed notifications"""
    print("🔔 Creating notifications...")

    # Check existing
    existing_query = "SELECT COUNT(*) as count FROM notifications"
    result = await database.fetch_one(existing_query)
    existing_count = result['count'] if result else 0

    if existing_count >= 5:
        print(f"  ✓ Already have {existing_count} notifications. Skipping...")
        return

    # Get users
    swimmers_query = "SELECT id FROM profiles WHERE role = 'swimmer' LIMIT 5"
    swimmers = await database.fetch_all(swimmers_query)

    academies_query = "SELECT id FROM profiles WHERE role = 'academy' LIMIT 3"
    academies = await database.fetch_all(academies_query)

    stores_query = "SELECT id FROM profiles WHERE role = 'store' LIMIT 3"
    stores = await database.fetch_all(stores_query)

    if len(swimmers) < 5:
        print("  ⚠ Need at least 5 swimmers. Skipping...")
        return

    # Create notifications (at least 5) - using valid enum values
    notifications_data = [
        (swimmers[0]['id'], "booking_confirmed", "Booking Confirmed", "Your swimming lesson booking has been confirmed for tomorrow."),
        (swimmers[1]['id'], "order_shipped", "Order Shipped", "Your order #ORD-002 has been shipped and is on the way."),
        (academies[0]['id'] if academies else swimmers[2]['id'], "new_message", "New Message", "You have a new message from a potential student."),
        (stores[0]['id'] if stores else swimmers[3]['id'], "payment_received", "Payment Received", "Payment of $150 has been received for order #ORD-004."),
        (swimmers[4]['id'], "event_reminder", "Event Reminder", "Swimming competition starts in 2 days. Don't forget to register!"),
    ]

    for user_id, notif_type, title, message in notifications_data:
        notification_id = str(uuid4())
        query = """
            INSERT INTO notifications (
                id, user_id, type, title, message, is_read, created_at
            ) VALUES (
                :id, :user_id, CAST(:type AS notification_type_enum), :title, :message, false, NOW()
            )
        """

        try:
            await database.execute(
                query=query,
                values={
                    "id": notification_id,
                    "user_id": str(user_id),
                    "type": notif_type,
                    "title": title,
                    "message": message,
                }
            )
            print(f"  ✓ Created notification: {title}")
        except Exception as e:
            print(f"  ✗ Failed to create notification: {e}")

async def main():
    try:
        await database.connect()
        print("=" * 60)
        await seed_notifications()
        print("=" * 60)
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        await database.disconnect()

if __name__ == "__main__":
    asyncio.run(main())
