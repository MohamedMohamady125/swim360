"""
Script to seed the database with test data for all tables
"""
import asyncio
from uuid import uuid4
from datetime import datetime, timedelta
from passlib.context import CryptContext
from databases import Database
from app.core.config import settings

# Create database instance with smaller pool size for seeding
db_url = str(settings.database_url)
if db_url.startswith("postgres://"):
    ASYNC_DATABASE_URL = db_url.replace("postgres://", "postgresql+asyncpg://")
elif db_url.startswith("postgresql://"):
    ASYNC_DATABASE_URL = db_url.replace("postgresql://", "postgresql+asyncpg://")
else:
    ASYNC_DATABASE_URL = db_url

database = Database(ASYNC_DATABASE_URL, min_size=1, max_size=3)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def clear_all_tables():
    """Clear all existing data from tables"""
    print("\n🗑️  Clearing existing data...")

    tables = [
        # Dependent tables first
        'order_items', 'orders', 'products', 'store_orders', 'product_branches', 'store_products', 'store_branches',
        'clinic_bookings', 'clinic_services', 'clinic_branches',
        'academy_swimmers', 'academy_programs', 'academy_pools', 'academy_branches',
        'used_items',
        'event_attendees', 'events',
        'coach_clients', 'coach_programs',
        'reviews', 'chat_messages', 'notifications',
        # Users last
        'profiles'
    ]

    for table in tables:
        try:
            await database.execute(f"DELETE FROM {table}")
            print(f"  ✓ Cleared {table}")
        except Exception as e:
            print(f"  ⚠ Could not clear {table}: {e}")

async def seed_users():
    """Create test users for all roles"""
    print("\n👥 Creating users...")

    users = []
    user_data = [
        # Academy owners (3)
        ("academy1@swim360.com", "Elite Swim Academy Owner", "academy", "Cairo", "Nasr City", "01012345671"),
        ("academy2@swim360.com", "Mediterranean Swim Owner", "academy", "Alexandria", "Smouha", "01012345672"),
        ("academy3@swim360.com", "Champions Academy Owner", "academy", "Giza", "Mohandessin", "01012345691"),

        # Clinic owners (3)
        ("clinic1@swim360.com", "AquaTherapy Owner", "clinic", "Cairo", "Maadi", "01012345673"),
        ("clinic2@swim360.com", "SwimWell Clinic Owner", "clinic", "Giza", "Dokki", "01012345674"),
        ("clinic3@swim360.com", "HealthWave Clinic Owner", "clinic", "Alexandria", "Mandara", "01012345692"),

        # Store owners (3)
        ("store1@swim360.com", "SwimGear Pro Owner", "store", "Cairo", "Heliopolis", "01012345675"),
        ("store2@swim360.com", "AquaSport Shop Owner", "store", "Alexandria", "San Stefano", "01012345676"),
        ("store3@swim360.com", "ProSwim Store Owner", "store", "Giza", "Sheikh Zayed", "01012345693"),

        # Swimmers (5)
        ("swimmer1@swim360.com", "Ahmed Mohamed", "swimmer", "Cairo", "Nasr City", "01012345677"),
        ("swimmer2@swim360.com", "Sara Ali", "swimmer", "Alexandria", "Smouha", "01012345678"),
        ("swimmer3@swim360.com", "Omar Hassan", "swimmer", "Giza", "6th October", "01012345679"),
        ("swimmer4@swim360.com", "Fatma Ibrahim", "swimmer", "Cairo", "Heliopolis", "01012345694"),
        ("swimmer5@swim360.com", "Youssef Khaled", "swimmer", "Alexandria", "Miami", "01012345695"),

        # Online coaches (2)
        ("onlinecoach1@swim360.com", "Coach Karim", "online_coach", "Cairo", "Zamalek", "01012345680"),
        ("onlinecoach2@swim360.com", "Coach Amira", "online_coach", "Alexandria", "Sporting", "01012345696"),

        # Event organizers (2)
        ("organizer1@swim360.com", "Egypt Swim Events", "event_organizer", "Cairo", "Downtown", "01012345697"),
        ("organizer2@swim360.com", "Med Sea Events", "event_organizer", "Alexandria", "Corniche", "01012345698"),
    ]

    for email, full_name, role, governorate, city, phone in user_data:
        user_id = str(uuid4())
        hashed_password = pwd_context.hash("password123")

        query = """
            INSERT INTO profiles (
                id, email, role, full_name, governorate, city, phone,
                password_hash, is_active, is_verified, created_at, updated_at
            ) VALUES (
                :id, :email, :role, :full_name, :governorate, :city, :phone,
                :password_hash, true, true, NOW(), NOW()
            )
            RETURNING id, email, full_name, role
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": user_id,
                "email": email,
                "role": role,
                "full_name": full_name,
                "governorate": governorate,
                "city": city,
                "phone": phone,
                "password_hash": hashed_password,
            }
        )

        users.append(result)
        print(f"  ✓ Created {role}: {email}")

    return users

async def seed_academies(users):
    """Seed academy module data"""
    print("\n🏊 Creating academy data...")

    # Get academy owners
    academy_owners = [u for u in users if u['role'] == 'academy']

    # Create academy branches (at least 5)
    branches = []
    branch_data = [
        (academy_owners[0]['id'], "Elite Swim Academy - Nasr City", "Cairo", "Nasr City", "9:00", "9:00", ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']),
        (academy_owners[0]['id'], "Elite Swim Academy - Maadi", "Cairo", "Maadi", "8:00", "8:00", ['Sun', 'Mon', 'Tue', 'Wed', 'Thu']),
        (academy_owners[1]['id'], "Mediterranean Swim - Smouha", "Alexandria", "Smouha", "10:00", "7:00", ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']),
        (academy_owners[1]['id'], "Mediterranean Swim - Mandara", "Alexandria", "Mandara", "8:00", "8:00", ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']),
        (academy_owners[2]['id'], "Champions Academy - Mohandessin", "Giza", "Mohandessin", "7:00", "10:00", ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']),
    ]

    for user_id, name, city, governorate, opening, closing, days in branch_data:
        branch_id = str(uuid4())
        query = """
            INSERT INTO academy_branches (
                id, user_id, name, city, governorate, opening_time, closing_time,
                operating_days, created_at, updated_at
            ) VALUES (
                :id, :user_id, :name, :city, :governorate, :opening_time, :closing_time,
                :operating_days, NOW(), NOW()
            )
            RETURNING id, user_id, name
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": branch_id,
                "user_id": user_id,
                "name": name,
                "city": city,
                "governorate": governorate,
                "opening_time": opening,
                "closing_time": closing,
                "operating_days": days,
            }
        )
        branches.append(result)
        print(f"  ✓ Created branch: {name}")

    # Create pools for each branch (at least 5)
    pool_data = [
        (branches[0]['id'], "Olympic Pool", 8, 50),
        (branches[1]['id'], "Training Pool", 6, 30),
        (branches[2]['id'], "Main Pool", 10, 60),
        (branches[3]['id'], "Kids Pool", 4, 20),
        (branches[4]['id'], "Competition Pool", 10, 80),
    ]

    for branch_id, name, lanes, capacity in pool_data:
        pool_id = str(uuid4())
        query = """
            INSERT INTO academy_pools (
                id, branch_id, name, lanes, capacity, created_at
            ) VALUES (
                :id, :branch_id, :name, :lanes, :capacity, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": pool_id,
                "branch_id": branch_id,
                "name": name,
                "lanes": lanes,
                "capacity": capacity,
            }
        )
        print(f"  ✓ Created pool: {name}")

    # Create programs (at least 5)
    programs = []
    program_data = [
        (academy_owners[0]['id'], "Beginner Swimming Course", "Learn the basics of swimming", 500.00, "3 Months", 20, 5),
        (academy_owners[0]['id'], "Competitive Swimming Training", "Advanced training for competitions", 800.00, "6 Months", 15, 8),
        (academy_owners[1]['id'], "Adult Swimming Classes", "Swimming classes for adults", 600.00, "2 Months", 12, 3),
        (academy_owners[1]['id'], "Kids Swimming Program", "Fun swimming lessons for kids ages 5-12", 400.00, "3 Months", 25, 12),
        (academy_owners[2]['id'], "Professional Training", "Elite training for competitive swimmers", 1000.00, "6 Months", 10, 6),
    ]

    for user_id, name, description, price, duration, capacity, enrolled in program_data:
        program_id = str(uuid4())
        query = """
            INSERT INTO academy_programs (
                id, user_id, name, description, price, duration, capacity, enrolled,
                created_at, updated_at
            ) VALUES (
                :id, :user_id, :name, :description, :price, :duration, :capacity, :enrolled,
                NOW(), NOW()
            )
            RETURNING id, user_id, name
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": program_id,
                "user_id": user_id,
                "name": name,
                "description": description,
                "price": price,
                "duration": duration,
                "capacity": capacity,
                "enrolled": enrolled,
            }
        )
        programs.append(result)
        print(f"  ✓ Created program: {name}")

    # Create swimmers (at least 5)
    swimmer_data = [
        (academy_owners[0]['id'], "Youssef Ibrahim", "01098765431", programs[0]['id'], branches[0]['id']),
        (academy_owners[0]['id'], "Nour Ahmed", "01098765432", programs[1]['id'], branches[0]['id']),
        (academy_owners[1]['id'], "Layla Mahmoud", "01098765433", programs[2]['id'], branches[2]['id']),
        (academy_owners[1]['id'], "Hassan Mohamed", "01098765434", programs[3]['id'], branches[3]['id']),
        (academy_owners[2]['id'], "Mariam Saeed", "01098765435", programs[4]['id'], branches[4]['id']),
    ]

    for user_id, swimmer_name, phone, program_id, branch_id in swimmer_data:
        swimmer_id = str(uuid4())
        end_date = (datetime.now() + timedelta(days=90)).date()

        query = """
            INSERT INTO academy_swimmers (
                id, user_id, swimmer_name, phone, program_id, branch_id, end_date, created_at
            ) VALUES (
                :id, :user_id, :swimmer_name, :phone, :program_id, :branch_id, :end_date, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": swimmer_id,
                "user_id": user_id,
                "swimmer_name": swimmer_name,
                "phone": phone,
                "program_id": program_id,
                "branch_id": branch_id,
                "end_date": end_date,
            }
        )
        print(f"  ✓ Created swimmer: {swimmer_name}")

async def seed_clinics(users):
    """Seed clinic module data"""
    print("\n🏥 Creating clinic data...")

    # Get clinic owners
    clinic_owners = [u for u in users if u['role'] == 'clinic']

    # Create clinic branches (at least 5)
    branches = []
    branch_data = [
        (clinic_owners[0]['id'], "AquaTherapy Center - Maadi", "Cairo", "Maadi", 5, "09", "00", "AM", "06", "00", "PM"),
        (clinic_owners[1]['id'], "SwimWell Clinic - Dokki", "Giza", "Dokki", 3, "10", "00", "AM", "08", "00", "PM"),
        (clinic_owners[0]['id'], "AquaTherapy Center - Nasr City", "Cairo", "Nasr City", 4, "08", "00", "AM", "09", "00", "PM"),
        (clinic_owners[2]['id'], "HealthWave Clinic - Mandara", "Alexandria", "Mandara", 6, "09", "00", "AM", "07", "00", "PM"),
        (clinic_owners[2]['id'], "HealthWave Clinic - Smouha", "Alexandria", "Smouha", 4, "10", "00", "AM", "08", "00", "PM"),
    ]

    for user_id, location_name, governorate, city, beds, open_h, open_m, open_ap, close_h, close_m, close_ap in branch_data:
        branch_id = str(uuid4())
        query = """
            INSERT INTO clinic_branches (
                id, user_id, location_name, governorate, city, number_of_beds,
                opening_hour, opening_minute, opening_ampm,
                closing_hour, closing_minute, closing_ampm,
                created_at, updated_at
            ) VALUES (
                :id, :user_id, :location_name, :governorate, :city, :number_of_beds,
                :opening_hour, :opening_minute, :opening_ampm,
                :closing_hour, :closing_minute, :closing_ampm,
                NOW(), NOW()
            )
            RETURNING id, user_id, location_name
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": branch_id,
                "user_id": user_id,
                "location_name": location_name,
                "governorate": governorate,
                "city": city,
                "number_of_beds": beds,
                "opening_hour": open_h,
                "opening_minute": open_m,
                "opening_ampm": open_ap,
                "closing_hour": close_h,
                "closing_minute": close_m,
                "closing_ampm": close_ap,
            }
        )
        branches.append(result)
        print(f"  ✓ Created clinic branch: {location_name}")

    # Create clinic services (at least 5)
    services = []
    service_data = [
        (clinic_owners[0]['id'], "Hydrotherapy Session", "Therapy", 200.00, "60 min", "Full body hydrotherapy session"),
        (clinic_owners[0]['id'], "Sports Injury Treatment", "Rehabilitation", 300.00, "45 min", "Treatment for swimming-related injuries"),
        (clinic_owners[1]['id'], "Swimming Therapy", "Therapy", 250.00, "90 min", "Therapeutic swimming session"),
        (clinic_owners[1]['id'], "Massage Therapy", "Wellness", 150.00, "60 min", "Relaxing massage for swimmers"),
        (clinic_owners[2]['id'], "Physical Therapy", "Rehabilitation", 280.00, "60 min", "Comprehensive physical therapy for athletes"),
    ]

    for user_id, title, category, price, duration, description in service_data:
        service_id = str(uuid4())
        query = """
            INSERT INTO clinic_services (
                id, user_id, title, category, price, duration, description,
                created_at, updated_at
            ) VALUES (
                :id, :user_id, :title, :category, :price, :duration, :description,
                NOW(), NOW()
            )
            RETURNING id, user_id, title
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": service_id,
                "user_id": user_id,
                "title": title,
                "category": category,
                "price": price,
                "duration": duration,
                "description": description,
            }
        )
        services.append(result)
        print(f"  ✓ Created service: {title}")

    # Create bookings (at least 5)
    booking_data = [
        (branches[0]['id'], services[0]['id'], "Ahmed Mohamed", 25, "01012345677", (datetime.now() + timedelta(days=2)).date(), "10:00", "Bed 1", "confirmed"),
        (branches[1]['id'], services[2]['id'], "Sara Ali", 22, "01012345678", (datetime.now() + timedelta(days=5)).date(), "14:00", "Bed 2", "confirmed"),
        (branches[2]['id'], services[1]['id'], "Omar Hassan", 28, "01012345679", (datetime.now() + timedelta(days=3)).date(), "11:00", "Bed 1", "confirmed"),
        (branches[3]['id'], services[4]['id'], "Fatma Ibrahim", 30, "01012345694", (datetime.now() + timedelta(days=7)).date(), "15:00", "Bed 3", "confirmed"),
        (branches[4]['id'], services[3]['id'], "Youssef Khaled", 24, "01012345695", (datetime.now() + timedelta(days=4)).date(), "16:00", "Bed 2", "completed"),
    ]

    for branch_id, service_id, client_name, age, phone, booking_date, booking_time, bed, status in booking_data:
        booking_id = str(uuid4())
        query = """
            INSERT INTO clinic_bookings (
                id, branch_id, service_id, client_name, client_age, phone,
                booking_date, booking_time, bed_number, status, created_at
            ) VALUES (
                :id, :branch_id, :service_id, :client_name, :client_age, :phone,
                :booking_date, :booking_time, :bed_number, :status, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": booking_id,
                "branch_id": branch_id,
                "service_id": service_id,
                "client_name": client_name,
                "client_age": age,
                "phone": phone,
                "booking_date": booking_date,
                "booking_time": booking_time,
                "bed_number": bed,
                "status": status,
            }
        )
        print(f"  ✓ Created booking for {client_name}")

async def seed_stores(users):
    """Seed store module data"""
    print("\n🏪 Creating store data...")

    # Get store owners
    store_owners = [u for u in users if u['role'] == 'store']

    # Create products (at least 5)
    products = []
    product_data = [
        (store_owners[0]['id'], "Speedo Competition Swimsuit", "suit", "Speedo", 450.00, "High-performance competition swimsuit", ['S', 'M', 'L', 'XL'], ['Black', 'Blue', 'Red'], 50),
        (store_owners[0]['id'], "Arena Racing Goggles", "goggles", "Arena", 120.00, "Professional racing goggles", None, ['Clear', 'Smoke', 'Blue'], 100),
        (store_owners[1]['id'], "Finis Training Fins", "fins", "Finis", 250.00, "Swimming training fins", ['M', 'L', 'XL'], ['Yellow', 'Blue'], 30),
        (store_owners[1]['id'], "TYR Kickboard", "kickboard", "TYR", 80.00, "Training kickboard", None, ['Red', 'Blue', 'Green'], 75),
        (store_owners[2]['id'], "Aqua Sphere Training Paddles", "paddles", "Aqua Sphere", 95.00, "Hand paddles for technique training", ['S', 'M', 'L'], ['Black', 'Orange'], 60),
    ]

    for store_id, product_name, category, brand, price, description, sizes, colors, stock in product_data:
        product_id = str(uuid4())
        query = """
            INSERT INTO products (
                id, store_id, product_name, category, brand, price, description,
                currency, available_sizes, available_colors, total_stock,
                low_stock_threshold, is_active, is_featured,
                rating, total_reviews, total_sales, view_count,
                created_at, updated_at
            ) VALUES (
                :id, :store_id, :product_name, :category, :brand, :price, :description,
                'EGP', :available_sizes, :available_colors, :total_stock,
                10, true, false,
                0, 0, 0, 0,
                NOW(), NOW()
            )
            RETURNING id, store_id, product_name
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": product_id,
                "store_id": store_id,
                "product_name": product_name,
                "category": category,
                "brand": brand,
                "price": price,
                "description": description,
                "available_sizes": sizes,
                "available_colors": colors,
                "total_stock": stock,
            }
        )
        products.append(result)
        print(f"  ✓ Created product: {product_name}")

    # Create orders (at least 5)
    swimmers = [u for u in users if u['role'] == 'swimmer']
    orders = []
    order_data = [
        (swimmers[0]['id'], store_owners[0]['id'], "ORD-001", "Cairo", "Nasr City", "123 Main St, Cairo", "01012345677", "processing", 570.00, 20.00, 5.00),
        (swimmers[1]['id'], store_owners[1]['id'], "ORD-002", "Alexandria", "Smouha", "456 Beach Rd, Alexandria", "01012345678", "shipped", 330.00, 25.00, 5.00),
        (swimmers[2]['id'], store_owners[0]['id'], "ORD-003", "Giza", "6th October", "789 Street, Giza", "01012345679", "delivered", 450.00, 30.00, 5.00),
        (swimmers[3]['id'], store_owners[2]['id'], "ORD-004", "Cairo", "Heliopolis", "321 Avenue, Cairo", "01012345694", "processing", 95.00, 15.00, 5.00),
        (swimmers[4]['id'], store_owners[1]['id'], "ORD-005", "Alexandria", "Miami", "654 Boulevard, Alex", "01012345695", "confirmed", 250.00, 20.00, 5.00),
    ]

    for swimmer_id, store_id, order_num, gov, city, address, phone, status, subtotal, delivery_fee, service_fee in order_data:
        order_id = str(uuid4())
        total = subtotal + delivery_fee + service_fee

        # Insert order with UUID
        order_query = """
            INSERT INTO orders (
                id, order_number, swimmer_id, store_id, status,
                delivery_governorate, delivery_city, delivery_address, delivery_phone,
                subtotal, delivery_fee, service_fee, total_amount,
                currency, payment_method, payment_status,
                created_at, updated_at
            ) VALUES (
                :id, :order_number, :swimmer_id, :store_id, :status,
                :delivery_governorate, :delivery_city, :delivery_address, :delivery_phone,
                :subtotal, :delivery_fee, :service_fee, :total_amount,
                'EGP', 'cash_on_delivery', 'pending',
                NOW(), NOW()
            )
            RETURNING id, order_number, status
        """

        result = await database.fetch_one(
            query=order_query,
            values={
                "id": order_id,
                "order_number": order_num,
                "swimmer_id": swimmer_id,
                "store_id": store_id,
                "status": status,
                "delivery_governorate": gov,
                "delivery_city": city,
                "delivery_address": address,
                "delivery_phone": phone,
                "subtotal": subtotal,
                "delivery_fee": delivery_fee,
                "service_fee": service_fee,
                "total_amount": total,
            }
        )
        orders.append(result)
        print(f"  ✓ Created order: {order_num} ({status})")

    # Create order items (at least 5)
    order_items_data = [
        # Order 1 items
        (orders[0]['id'], products[0]['id'], "Speedo Competition Swimsuit", "Speedo", "M", "Blue", 450.00, 1),
        (orders[0]['id'], products[1]['id'], "Arena Racing Goggles", "Arena", None, "Clear", 120.00, 1),
        # Order 2 items
        (orders[1]['id'], products[2]['id'], "Finis Training Fins", "Finis", "L", "Yellow", 250.00, 1),
        (orders[1]['id'], products[3]['id'], "TYR Kickboard", "TYR", None, "Red", 80.00, 1),
        # Order 3 items
        (orders[2]['id'], products[0]['id'], "Speedo Competition Swimsuit", "Speedo", "L", "Black", 450.00, 1),
        # Order 4 items
        (orders[3]['id'], products[4]['id'], "Aqua Sphere Training Paddles", "Aqua Sphere", "M", "Black", 95.00, 1),
        # Order 5 items
        (orders[4]['id'], products[2]['id'], "Finis Training Fins", "Finis", "M", "Blue", 250.00, 1),
    ]

    for order_id, product_id, product_name, brand, size, color, unit_price, quantity in order_items_data:
        subtotal = unit_price * quantity

        item_query = """
            INSERT INTO order_items (
                id, order_id, product_id, product_name, product_brand,
                selected_size, selected_color, unit_price, quantity, subtotal, created_at
            ) VALUES (
                :id, :order_id, :product_id, :product_name, :product_brand,
                :selected_size, :selected_color, :unit_price, :quantity, :subtotal, NOW()
            )
        """

        await database.execute(
            query=item_query,
            values={
                "id": str(uuid4()),
                "order_id": order_id,
                "product_id": product_id,
                "product_name": product_name,
                "product_brand": brand,
                "selected_size": size,
                "selected_color": color,
                "unit_price": unit_price,
                "quantity": quantity,
                "subtotal": subtotal,
            }
        )
        print(f"  ✓ Created order item: {product_name}")

async def seed_marketplace(users):
    """Seed marketplace used items"""
    print("\n🛒 Creating marketplace data...")

    swimmers = [u for u in users if u['role'] == 'swimmer']

    items_data = [
        (swimmers[0]['id'], "Used Speedo Goggles", "goggles", "Lightly used racing goggles", "excellent", "Speedo", 80.00, "M", "Black", "Cairo", "Nasr City", "01012345677", False),
        (swimmers[1]['id'], "Training Swimsuit", "suit", "Used for 6 months", "good", "Arena", 200.00, "L", "Blue", "Alexandria", "Smouha", "01012345678", False),
        (swimmers[2]['id'], "Swimming Fins", "fins", "Almost new training fins", "excellent", "Finis", 150.00, "L", "Yellow", "Giza", "6th October", "01012345679", False),
        (swimmers[0]['id'], "Kickboard Set", "kickboard", "Set of 2 kickboards", "good", "TYR", 50.00, None, "Red", "Cairo", "Maadi", "01012345677", True),
        (swimmers[3]['id'], "Arena Swim Cap", "cap", "Barely used silicon swim cap", "excellent", "Arena", 25.00, None, "Blue", "Cairo", "Heliopolis", "01012345694", False),
    ]

    for seller_id, title, category, description, condition, brand, price, size, color, governorate, city, phone, is_sold in items_data:
        item_id = str(uuid4())
        query = """
            INSERT INTO used_items (
                id, seller_id, title, category, description, condition, brand, price, currency,
                is_negotiable, size, color, contact_phone, contact_whatsapp,
                governorate, city, is_sold, is_active, view_count,
                created_at, updated_at
            ) VALUES (
                :id, :seller_id, :title, :category, :description, :condition, :brand, :price, 'EGP',
                true, :size, :color, :contact_phone, :contact_whatsapp,
                :governorate, :city, :is_sold, true, 0,
                NOW(), NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": item_id,
                "seller_id": seller_id,
                "title": title,
                "category": category,
                "description": description,
                "condition": condition,
                "brand": brand,
                "price": price,
                "size": size,
                "color": color,
                "contact_phone": phone,
                "contact_whatsapp": phone,
                "governorate": governorate,
                "city": city,
                "is_sold": is_sold,
            }
        )
        status = "SOLD" if is_sold else "available"
        print(f"  ✓ Created used item: {title} ({status})")

async def seed_events(users):
    """Seed event organizer data"""
    print("\n🎉 Creating events data...")

    # Get event organizers
    organizers = [u for u in users if u['role'] == 'event_organizer']

    # Create events (at least 5)
    events = []
    event_data = [
        (organizers[0]['id'], "Cairo Swimming Championship 2024", (datetime.now() + timedelta(days=30)).date(), "09:00", "2", "days", 150.00, 100, 100, "Cairo International Stadium", "Cairo", "Nasr City", "12-60", "Competitive Swimmers", "Competition"),
        (organizers[0]['id'], "Kids Swimming Gala", (datetime.now() + timedelta(days=20)).date(), "10:00", "4", "hours", 50.00, 200, 180, "Maadi Sports Club", "Cairo", "Maadi", "5-15", "Children", "Fun Event"),
        (organizers[1]['id'], "Mediterranean Open Water Race", (datetime.now() + timedelta(days=45)).date(), "07:00", "3", "hours", 200.00, 50, 35, "Alexandria Beach", "Alexandria", "Mandara", "18+", "Adults", "Competition"),
        (organizers[1]['id'], "Summer Swimming Festival", (datetime.now() + timedelta(days=60)).date(), "08:00", "1", "days", 75.00, 150, 120, "Smouha Club", "Alexandria", "Smouha", "All Ages", "Everyone", "Festival"),
        (organizers[0]['id'], "Charity Swim Marathon", (datetime.now() + timedelta(days=15)).date(), "06:00", "6", "hours", 100.00, 80, 65, "Zamalek Club", "Cairo", "Zamalek", "16+", "Adults", "Charity"),
    ]

    for organizer_id, name, event_date, event_time, duration_val, duration_unit, price, total_tickets, available_tickets, location, governorate, city, age_range, target_audience, event_type in event_data:
        event_id = str(uuid4())
        query = """
            INSERT INTO events (
                id, user_id, name, event_date, event_time, duration_value, duration_unit,
                price, total_tickets, available_tickets, location_name,
                age_range, target_audience, event_type, created_at, updated_at
            ) VALUES (
                :id, :user_id, :name, :event_date, :event_time, :duration_value, :duration_unit,
                :price, :total_tickets, :available_tickets, :location_name,
                :age_range, :target_audience, :event_type, NOW(), NOW()
            )
            RETURNING id, user_id, name
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": event_id,
                "user_id": organizer_id,
                "name": name,
                "event_date": event_date,
                "event_time": event_time,
                "duration_value": duration_val,
                "duration_unit": duration_unit,
                "price": price,
                "total_tickets": total_tickets,
                "available_tickets": available_tickets,
                "location_name": location,
                "age_range": age_range,
                "target_audience": target_audience,
                "event_type": event_type,
            }
        )
        events.append(result)
        print(f"  ✓ Created event: {name}")

    # Create event attendees (at least 5)
    attendees_data = [
        (events[0]['id'], "Mohamed Hassan", 25, "01098765441", "VIP"),
        (events[1]['id'], "Layla Ahmed", 10, "01098765442", "Standard"),
        (events[2]['id'], "Khaled Ibrahim", 30, "01098765443", "VIP"),
        (events[3]['id'], "Nour Mahmoud", 22, "01098765444", "Standard"),
        (events[4]['id'], "Omar Saeed", 28, "01098765445", "Standard"),
    ]

    for event_id, attendee_name, age, phone, ticket_type in attendees_data:
        attendee_id = str(uuid4())
        query = """
            INSERT INTO event_attendees (
                id, event_id, attendee_name, age, phone, ticket_type, created_at
            ) VALUES (
                :id, :event_id, :attendee_name, :age, :phone, :ticket_type, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": attendee_id,
                "event_id": event_id,
                "attendee_name": attendee_name,
                "age": age,
                "phone": phone,
                "ticket_type": ticket_type,
            }
        )
        print(f"  ✓ Created attendee: {attendee_name}")

async def seed_coaches(users):
    """Seed online coach data"""
    print("\n👨‍🏫 Creating coach data...")

    # Get coaches
    coaches = [u for u in users if u['role'] == 'online_coach']

    # Create coach programs (at least 5)
    programs = []
    program_data = [
        (coaches[0]['id'], "Freestyle Mastery", "Master the freestyle stroke with personalized coaching", 800.00, "12 Weeks", "Technique"),
        (coaches[0]['id'], "Endurance Builder", "Build swimming endurance and stamina", 700.00, "10 Weeks", "Endurance"),
        (coaches[1]['id'], "Competition Prep", "Prepare for swimming competitions", 1000.00, "16 Weeks", "Competition"),
        (coaches[1]['id'], "Beginner to Intermediate", "Progress from beginner to intermediate level", 600.00, "8 Weeks", "Skill Development"),
        (coaches[0]['id'], "Open Water Training", "Training for open water swimming", 900.00, "12 Weeks", "Open Water"),
    ]

    for coach_id, title, description, price, duration, goal in program_data:
        program_id = str(uuid4())
        query = """
            INSERT INTO coach_programs (
                id, user_id, title, description, price, duration, goal, created_at, updated_at
            ) VALUES (
                :id, :user_id, :title, :description, :price, :duration, :goal, NOW(), NOW()
            )
            RETURNING id, user_id, title
        """

        result = await database.fetch_one(
            query=query,
            values={
                "id": program_id,
                "user_id": coach_id,
                "title": title,
                "description": description,
                "price": price,
                "duration": duration,
                "goal": goal,
            }
        )
        programs.append(result)
        print(f"  ✓ Created coach program: {title}")

    # Create coach clients (at least 5)
    clients_data = [
        (coaches[0]['id'], "Ali Hassan", programs[0]['id'], "01098765451", 24, "male"),
        (coaches[0]['id'], "Mona Ahmed", programs[1]['id'], "01098765452", 28, "female"),
        (coaches[1]['id'], "Tarek Ibrahim", programs[2]['id'], "01098765453", 22, "male"),
        (coaches[1]['id'], "Salma Mahmoud", programs[3]['id'], "01098765454", 26, "female"),
        (coaches[0]['id'], "Hossam Saeed", programs[4]['id'], "01098765455", 30, "male"),
    ]

    for coach_id, client_name, program_id, phone, age, gender in clients_data:
        client_id = str(uuid4())
        end_date = (datetime.now() + timedelta(days=90)).date()

        query = """
            INSERT INTO coach_clients (
                id, user_id, client_name, program_id, phone, age, gender, end_date, created_at
            ) VALUES (
                :id, :user_id, :client_name, :program_id, :phone, :age, :gender, :end_date, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": client_id,
                "user_id": coach_id,
                "client_name": client_name,
                "program_id": program_id,
                "phone": phone,
                "age": age,
                "gender": gender,
                "end_date": end_date,
            }
        )
        print(f"  ✓ Created coach client: {client_name}")

async def seed_reviews_and_interactions(users):
    """Seed reviews, chat messages, and notifications"""
    print("\n⭐ Creating reviews, chats, and notifications...")

    swimmers = [u for u in users if u['role'] == 'swimmer']
    academies = [u for u in users if u['role'] == 'academy']
    clinics = [u for u in users if u['role'] == 'clinic']
    stores = [u for u in users if u['role'] == 'store']
    coaches = [u for u in users if u['role'] == 'online_coach']

    # Create reviews (at least 5)
    reviews_data = [
        (swimmers[0]['id'], "academy", academies[0]['id'], 5, "Excellent academy with great coaches!"),
        (swimmers[1]['id'], "academy", academies[1]['id'], 4, "Good facilities and friendly staff."),
        (swimmers[2]['id'], "clinic", clinics[0]['id'], 5, "Amazing therapy sessions, highly recommended."),
        (swimmers[3]['id'], "store", stores[0]['id'], 4, "Quality products at good prices."),
        (swimmers[4]['id'], "coach", coaches[0]['id'], 5, "Best coach ever! Improved my technique significantly."),
    ]

    for user_id, target_type, target_id, rating, comment in reviews_data:
        review_id = str(uuid4())
        query = """
            INSERT INTO reviews (
                id, user_id, target_type, target_id, rating, comment, created_at
            ) VALUES (
                :id, :user_id, :target_type, :target_id, :rating, :comment, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": review_id,
                "user_id": user_id,
                "target_type": target_type,
                "target_id": target_id,
                "rating": rating,
                "comment": comment,
            }
        )
        print(f"  ✓ Created review by swimmer for {target_type}")

    # Create chat messages (at least 5)
    messages_data = [
        (swimmers[0]['id'], academies[0]['id'], "Hi, I'm interested in your beginner swimming course. Is there availability?"),
        (academies[0]['id'], swimmers[0]['id'], "Hello! Yes, we have spots available. The next session starts in 2 weeks."),
        (swimmers[1]['id'], clinics[0]['id'], "Do you offer weekend appointments for hydrotherapy?"),
        (swimmers[2]['id'], stores[0]['id'], "Is the Speedo competition swimsuit available in size XL?"),
        (coaches[0]['id'], swimmers[4]['id'], "Great job on your last training session! Keep up the good work."),
    ]

    for sender_id, receiver_id, message in messages_data:
        message_id = str(uuid4())
        query = """
            INSERT INTO chat_messages (
                id, sender_id, receiver_id, message, is_read, created_at
            ) VALUES (
                :id, :sender_id, :receiver_id, :message, false, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": message_id,
                "sender_id": sender_id,
                "receiver_id": receiver_id,
                "message": message,
            }
        )
        print(f"  ✓ Created chat message")

    # Create notifications (at least 5)
    notifications_data = [
        (swimmers[0]['id'], "order", "Order Confirmed", "Your order #ORD-001 has been confirmed and is being processed."),
        (swimmers[1]['id'], "booking", "Booking Reminder", "Your therapy session is scheduled for tomorrow at 2:00 PM."),
        (academies[0]['id'], "message", "New Message", "You have a new message from a potential student."),
        (stores[0]['id'], "order", "New Order", "You have received a new order #ORD-004."),
        (swimmers[4]['id'], "review", "New Review", "Someone reviewed your profile!"),
    ]

    for user_id, notif_type, title, message in notifications_data:
        notification_id = str(uuid4())
        query = """
            INSERT INTO notifications (
                id, user_id, type, title, message, is_read, created_at
            ) VALUES (
                :id, :user_id, :type, :title, :message, false, NOW()
            )
        """

        await database.execute(
            query=query,
            values={
                "id": notification_id,
                "user_id": user_id,
                "type": notif_type,
                "title": title,
                "message": message,
            }
        )
        print(f"  ✓ Created notification: {title}")

async def main():
    """Main seeding function"""
    print("=" * 60)
    print("🌱 SWIM360 DATABASE SEEDING")
    print("=" * 60)

    try:
        # Connect to database
        await database.connect()
        print("✅ Connected to database")

        # Clear existing data
        await clear_all_tables()

        # Seed data
        users = await seed_users()
        await seed_academies(users)
        await seed_clinics(users)
        await seed_stores(users)
        await seed_marketplace(users)
        await seed_events(users)
        await seed_coaches(users)
        await seed_reviews_and_interactions(users)

        print("\n" + "=" * 60)
        print("✅ DATABASE SEEDING COMPLETED!")
        print("=" * 60)
        print("\n📋 Test Credentials (password: password123):")
        print("  Academy:        academy1@swim360.com")
        print("  Clinic:         clinic1@swim360.com")
        print("  Store:          store1@swim360.com")
        print("  Swimmer:        swimmer1@swim360.com")
        print("  Online Coach:   onlinecoach1@swim360.com")
        print("  Event Organizer: organizer1@swim360.com")
        print("\n💡 All tables seeded with at least 5 rows of data!")

    except Exception as e:
        print(f"\n❌ Error during seeding: {e}")
        import traceback
        traceback.print_exc()
    finally:
        await database.disconnect()
        print("\n🔌 Disconnected from database")

if __name__ == "__main__":
    asyncio.run(main())
