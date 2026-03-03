"""
Script to seed remaining tables that failed due to schema mismatch
"""
import asyncio
from uuid import uuid4
from datetime import datetime, timedelta
from databases import Database
from app.core.config import settings

# Create database instance with smaller pool size
db_url = str(settings.database_url)
if db_url.startswith("postgres://"):
    ASYNC_DATABASE_URL = db_url.replace("postgres://", "postgresql+asyncpg://")
elif db_url.startswith("postgresql://"):
    ASYNC_DATABASE_URL = db_url.replace("postgresql://", "postgresql+asyncpg://")
else:
    ASYNC_DATABASE_URL = db_url

database = Database(ASYNC_DATABASE_URL, min_size=1, max_size=3)

async def seed_events():
    """Seed events with correct schema"""
    print("\n🎉 Creating events...")

    # Check existing events
    existing_events_query = "SELECT COUNT(*) as count FROM events"
    result = await database.fetch_one(existing_events_query)
    existing_count = result['count'] if result else 0

    if existing_count >= 5:
        print(f"  ✓ Already have {existing_count} events. Skipping...")
        events_query = "SELECT id, event_name FROM events LIMIT 5"
        return await database.fetch_all(events_query)

    # Get organizers
    organizers_query = "SELECT id, full_name FROM profiles WHERE role = 'event_organizer'"
    organizers = await database.fetch_all(organizers_query)

    if len(organizers) < 2:
        print("  ⚠ Need at least 2 event organizers. Skipping events...")
        return []

    # Create events (at least 5) - using valid enum values
    events = []
    event_data = [
        ("Swimming Techniques Seminar", "seminar", "Professional seminar on advanced swimming techniques", (datetime.now() + timedelta(days=30)).date(), "09:00", "18:00", "Cairo International Stadium", "123 Sports St", "Cairo", "Cairo", 100, 0, 150.00),
        ("Kids Swimming Workshop", "workshop", "Interactive swimming workshop for children", (datetime.now() + timedelta(days=20)).date(), "10:00", "14:00", "Maadi Sports Club", "456 Club Rd", "Cairo", "Cairo", 200, 0, 50.00),
        ("Mediterranean Open Water Meet", "meet", "Open water swimming meet", (datetime.now() + timedelta(days=45)).date(), "07:00", "10:00", "Alexandria Beach", "Beach Front", "Alexandria", "Alexandria", 50, 0, 200.00),
        ("Summer Swimming Training Camp", "training_camp", "Intensive summer swimming training camp", (datetime.now() + timedelta(days=60)).date(), "08:00", "20:00", "Smouha Club", "789 Club Ave", "Alexandria", "Alexandria", 150, 0, 75.00),
        ("Online Swimming Webinar", "webinar", "Online webinar about swimming nutrition and training", (datetime.now() + timedelta(days=15)).date(), "06:00", "12:00", "Online", "N/A", "Cairo", "Cairo", 500, 0, 25.00),
    ]

    for i, (name, event_type, description, event_date, start_time, end_time, venue, address, city, governorate, max_participants, current_participants, fee) in enumerate(event_data):
        event_id = str(uuid4())
        organizer = organizers[i % len(organizers)]

        query = """
            INSERT INTO events (
                id, organizer_id, event_name, event_type, description,
                event_date, venue_name, address,
                city, governorate, max_participants, current_participants,
                registration_fee, is_active, is_featured, created_at, updated_at
            ) VALUES (
                :id, :organizer_id, :event_name, CAST(:event_type AS event_type_enum), :description,
                :event_date, :venue_name, :address,
                :city, :governorate, :max_participants, :current_participants,
                :registration_fee, true, false, NOW(), NOW()
            )
            RETURNING id, event_name
        """

        try:
            result = await database.fetch_one(
                query=query,
                values={
                    "id": event_id,
                    "organizer_id": str(organizer['id']),
                    "event_name": name,
                    "event_type": event_type,
                    "description": description,
                    "event_date": event_date,
                    "venue_name": venue,
                    "address": address,
                    "city": city,
                    "governorate": governorate,
                    "max_participants": max_participants,
                    "current_participants": current_participants,
                    "registration_fee": fee,
                }
            )
            events.append(result)
            print(f"  ✓ Created event: {name}")
        except Exception as e:
            print(f"  ✗ Failed to create event {name}: {e}")

    return events

async def seed_event_registrations(events):
    """Seed event registrations"""
    print("\n🎫 Creating event registrations...")

    if len(events) < 5:
        print("  ⚠ Not enough events. Skipping registrations...")
        return

    # Check existing registrations
    existing_regs_query = "SELECT COUNT(*) as count FROM event_registrations"
    result = await database.fetch_one(existing_regs_query)
    existing_count = result['count'] if result else 0

    if existing_count >= 5:
        print(f"  ✓ Already have {existing_count} event registrations. Skipping...")
        return

    # Get swimmers
    swimmers_query = "SELECT id, full_name FROM profiles WHERE role = 'swimmer' LIMIT 5"
    swimmers = await database.fetch_all(swimmers_query)

    if len(swimmers) < 5:
        print("  ⚠ Need at least 5 swimmers. Skipping registrations...")
        return

    # Convert events to list if needed and extract IDs
    event_ids = []
    for event in events[:5]:
        if hasattr(event, 'id'):
            event_ids.append(event.id)
        elif isinstance(event, dict):
            event_ids.append(event['id'])
        else:
            event_ids.append(str(event))

    # Create registrations (at least 5)
    registrations_data = [
        (event_ids[0], swimmers[0]['id'], "completed", 150.00, False),
        (event_ids[1], swimmers[1]['id'], "completed", 50.00, False),
        (event_ids[2], swimmers[2]['id'], "pending", 200.00, False),
        (event_ids[3], swimmers[3]['id'], "completed", 75.00, False),
        (event_ids[4], swimmers[4]['id'], "completed", 100.00, False),
    ]

    for event_id, user_id, payment_status, amount_paid, checked_in in registrations_data:
        registration_id = str(uuid4())
        query = """
            INSERT INTO event_registrations (
                id, event_id, user_id, payment_status, amount_paid,
                checked_in, created_at, updated_at
            ) VALUES (
                :id, :event_id, :user_id, CAST(:payment_status AS payment_status_type), :amount_paid,
                :checked_in, NOW(), NOW()
            )
        """

        try:
            await database.execute(
                query=query,
                values={
                    "id": registration_id,
                    "event_id": str(event_id),
                    "user_id": str(user_id),
                    "payment_status": payment_status,
                    "amount_paid": amount_paid,
                    "checked_in": checked_in,
                }
            )
            print(f"  ✓ Created registration for user {user_id[:8]}...")
        except Exception as e:
            print(f"  ✗ Failed to create registration: {e}")

async def seed_reviews():
    """Seed reviews with correct schema"""
    print("\n⭐ Creating reviews...")

    # Get users
    swimmers_query = "SELECT id, full_name FROM profiles WHERE role = 'swimmer' LIMIT 5"
    swimmers = await database.fetch_all(swimmers_query)

    academies_query = "SELECT id FROM profiles WHERE role = 'academy' LIMIT 3"
    academies = await database.fetch_all(academies_query)

    clinics_query = "SELECT id FROM profiles WHERE role = 'clinic' LIMIT 3"
    clinics = await database.fetch_all(clinics_query)

    stores_query = "SELECT id FROM profiles WHERE role = 'store' LIMIT 3"
    stores = await database.fetch_all(stores_query)

    coaches_query = "SELECT id FROM profiles WHERE role = 'online_coach' LIMIT 2"
    coaches = await database.fetch_all(coaches_query)

    if len(swimmers) < 5:
        print("  ⚠ Need at least 5 swimmers. Skipping reviews...")
        return

    # Create reviews (at least 5)
    reviews_data = [
        (swimmers[0]['id'], academies[0]['id'] if academies else None, "academy", 5, "Great Swimming Academy", "Excellent academy with great coaches!"),
        (swimmers[1]['id'], academies[1]['id'] if len(academies) > 1 else None, "academy", 4, "Good Facilities", "Good facilities and friendly staff."),
        (swimmers[2]['id'], clinics[0]['id'] if clinics else None, "clinic", 5, "Amazing Therapy", "Amazing therapy sessions, highly recommended."),
        (swimmers[3]['id'], stores[0]['id'] if stores else None, "store", 4, "Quality Products", "Quality products at good prices."),
        (swimmers[4]['id'], coaches[0]['id'] if coaches else None, "coach", 5, "Best Coach Ever", "Best coach ever! Improved my technique significantly."),
    ]

    for reviewer_id, target_id, target_type, rating, title, comment in reviews_data:
        if target_id is None:
            continue

        review_id = str(uuid4())
        query = """
            INSERT INTO reviews (
                id, reviewer_id, target_id, target_type, rating, title, comment,
                is_active, created_at, updated_at
            ) VALUES (
                :id, :reviewer_id, :target_id, :target_type, :rating, :title, :comment,
                true, NOW(), NOW()
            )
        """

        try:
            await database.execute(
                query=query,
                values={
                    "id": review_id,
                    "reviewer_id": reviewer_id,
                    "target_id": target_id,
                    "target_type": target_type,
                    "rating": rating,
                    "title": title,
                    "comment": comment,
                }
            )
            print(f"  ✓ Created review: {title}")
        except Exception as e:
            print(f"  ✗ Failed to create review: {e}")

async def main():
    """Main seeding function"""
    print("=" * 60)
    print("🌱 SEEDING REMAINING TABLES")
    print("=" * 60)

    try:
        # Connect to database
        await database.connect()
        print("✅ Connected to database")

        # Seed remaining data
        events = await seed_events()
        await seed_event_registrations(events)
        await seed_reviews()

        print("\n" + "=" * 60)
        print("✅ REMAINING TABLES SEEDED!")
        print("=" * 60)

    except Exception as e:
        print(f"\n❌ Error during seeding: {e}")
        import traceback
        traceback.print_exc()
    finally:
        await database.disconnect()
        print("\n🔌 Disconnected from database")

if __name__ == "__main__":
    asyncio.run(main())
