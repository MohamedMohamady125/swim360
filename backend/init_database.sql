-- Swim360 Database Schema
-- This script creates all necessary tables for the Swim360 application

-- ============================================
-- CORE TABLES (Already exist)
-- ============================================
-- profiles table (already exists with auth integration)
-- Contains: id, email, role, full_name, phone, governorate, city, password_hash, is_active, is_verified, created_at, updated_at

-- ============================================
-- ACADEMY TABLES
-- ============================================

-- Academy branches
CREATE TABLE IF NOT EXISTS academy_branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    governorate VARCHAR(100),
    location_url TEXT,
    opening_time VARCHAR(10),
    closing_time VARCHAR(10),
    operating_days TEXT[], -- Array of days: ['Mon', 'Tue', 'Wed']
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Academy pools
CREATE TABLE IF NOT EXISTS academy_pools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID NOT NULL REFERENCES academy_branches(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    lanes INTEGER DEFAULT 6,
    capacity INTEGER DEFAULT 30,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Academy programs
CREATE TABLE IF NOT EXISTS academy_programs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) DEFAULT 0,
    duration VARCHAR(100), -- e.g., "3 Months"
    capacity INTEGER DEFAULT 20,
    enrolled INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Academy swimmers
CREATE TABLE IF NOT EXISTS academy_swimmers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE, -- Academy owner
    swimmer_name VARCHAR(255) NOT NULL,
    program_id UUID REFERENCES academy_programs(id) ON DELETE SET NULL,
    branch_id UUID REFERENCES academy_branches(id) ON DELETE SET NULL,
    phone VARCHAR(20),
    end_date DATE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- CLINIC TABLES
-- ============================================

-- Clinic branches
CREATE TABLE IF NOT EXISTS clinic_branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    location_name VARCHAR(255) NOT NULL,
    governorate VARCHAR(100),
    city VARCHAR(100),
    location_url TEXT,
    number_of_beds INTEGER DEFAULT 1,
    opening_hour VARCHAR(10),
    opening_minute VARCHAR(10),
    opening_ampm VARCHAR(5),
    closing_hour VARCHAR(10),
    closing_minute VARCHAR(10),
    closing_ampm VARCHAR(5),
    services_offered TEXT[], -- Array of service IDs or names
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Clinic services
CREATE TABLE IF NOT EXISTS clinic_services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) DEFAULT 0,
    duration VARCHAR(50), -- e.g., "60 min"
    description TEXT,
    video_url TEXT,
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Clinic bookings
CREATE TABLE IF NOT EXISTS clinic_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID NOT NULL REFERENCES clinic_branches(id) ON DELETE CASCADE,
    service_id UUID REFERENCES clinic_services(id) ON DELETE SET NULL,
    client_name VARCHAR(255) NOT NULL,
    client_age INTEGER,
    phone VARCHAR(20),
    booking_date DATE NOT NULL,
    booking_time VARCHAR(10) NOT NULL,
    bed_number VARCHAR(50),
    status VARCHAR(50) DEFAULT 'confirmed', -- confirmed, completed, cancelled
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- EVENT ORGANIZER TABLES
-- ============================================

-- Events
CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    event_date DATE NOT NULL,
    event_time VARCHAR(10),
    duration_value VARCHAR(10),
    duration_unit VARCHAR(20), -- hours, days
    price DECIMAL(10, 2) DEFAULT 0,
    total_tickets INTEGER DEFAULT 100,
    available_tickets INTEGER DEFAULT 100,
    location_name VARCHAR(255),
    location_url TEXT,
    age_range VARCHAR(50),
    target_audience VARCHAR(100),
    event_type VARCHAR(100),
    description TEXT,
    video_url TEXT,
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Event attendees
CREATE TABLE IF NOT EXISTS event_attendees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    attendee_name VARCHAR(255) NOT NULL,
    age INTEGER,
    phone VARCHAR(20),
    ticket_type VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- ONLINE COACH TABLES
-- ============================================

-- Coach programs
CREATE TABLE IF NOT EXISTS coach_programs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) DEFAULT 0,
    duration VARCHAR(100), -- e.g., "12 Weeks"
    goal VARCHAR(255), -- e.g., "Technique", "Endurance"
    video_url TEXT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Coach clients
CREATE TABLE IF NOT EXISTS coach_clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE, -- Coach
    client_name VARCHAR(255) NOT NULL,
    program_id UUID REFERENCES coach_programs(id) ON DELETE SET NULL,
    phone VARCHAR(20),
    age INTEGER,
    gender VARCHAR(20),
    end_date DATE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- STORE TABLES
-- ============================================

-- Store branches
CREATE TABLE IF NOT EXISTS store_branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    location_name VARCHAR(255) NOT NULL,
    governorate VARCHAR(100),
    city VARCHAR(100),
    location_url TEXT,
    branch_phone VARCHAR(20),
    opening_hour VARCHAR(10),
    opening_minute VARCHAR(10),
    opening_ampm VARCHAR(5),
    closing_hour VARCHAR(10),
    closing_minute VARCHAR(10),
    closing_ampm VARCHAR(5),
    delivery_options TEXT[], -- Array: ['pickup-only', 'governorate-delivery', etc.]
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Store products
CREATE TABLE IF NOT EXISTS store_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10, 2) DEFAULT 0,
    description TEXT,
    available_sizes TEXT[], -- Array: ['S', 'M', 'L']
    available_colors TEXT[], -- Array: ['Black', 'Blue', 'Red']
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Product-Branch relationship (which products are available at which branches)
CREATE TABLE IF NOT EXISTS product_branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES store_products(id) ON DELETE CASCADE,
    branch_id UUID NOT NULL REFERENCES store_branches(id) ON DELETE CASCADE,
    in_stock BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(product_id, branch_id)
);

-- Store orders
CREATE TABLE IF NOT EXISTS store_orders (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL, -- Customer
    store_owner_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE, -- Store owner
    branch_id UUID REFERENCES store_branches(id) ON DELETE SET NULL,
    customer_name VARCHAR(255),
    customer_phone VARCHAR(20),
    delivery_address TEXT,
    delivery_type VARCHAR(100),
    status VARCHAR(50) DEFAULT 'requested', -- requested, confirmed, delivered, cancelled
    total_amount DECIMAL(10, 2) DEFAULT 0,
    delivery_date DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Order items
CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id INTEGER NOT NULL REFERENCES store_orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES store_products(id) ON DELETE SET NULL,
    product_name VARCHAR(255),
    quantity INTEGER DEFAULT 1,
    price DECIMAL(10, 2) DEFAULT 0,
    size VARCHAR(50),
    color VARCHAR(50)
);

-- ============================================
-- MARKETPLACE (USED ITEMS) TABLES
-- ============================================

-- Used items marketplace
CREATE TABLE IF NOT EXISTS used_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    condition VARCHAR(50), -- New, Excellent, Good, Fair
    governorate VARCHAR(100),
    brand VARCHAR(100),
    size VARCHAR(50),
    price DECIMAL(10, 2) DEFAULT 0,
    contact_number VARCHAR(20),
    photos TEXT[], -- Array of photo URLs
    status VARCHAR(50) DEFAULT 'available', -- available, sold, withdrawn
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- SHARED/UTILITY TABLES
-- ============================================

-- Reviews (for all services)
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    target_type VARCHAR(50) NOT NULL, -- 'academy', 'clinic', 'event', 'store', 'coach'
    target_id UUID NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Chat messages
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    type VARCHAR(50), -- 'order', 'booking', 'message', 'review', etc.
    title VARCHAR(255),
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Academy indexes
CREATE INDEX IF NOT EXISTS idx_academy_branches_user ON academy_branches(user_id);
CREATE INDEX IF NOT EXISTS idx_academy_pools_branch ON academy_pools(branch_id);
CREATE INDEX IF NOT EXISTS idx_academy_programs_user ON academy_programs(user_id);
CREATE INDEX IF NOT EXISTS idx_academy_swimmers_user ON academy_swimmers(user_id);

-- Clinic indexes
CREATE INDEX IF NOT EXISTS idx_clinic_branches_user ON clinic_branches(user_id);
CREATE INDEX IF NOT EXISTS idx_clinic_services_user ON clinic_services(user_id);
CREATE INDEX IF NOT EXISTS idx_clinic_bookings_branch ON clinic_bookings(branch_id);
CREATE INDEX IF NOT EXISTS idx_clinic_bookings_date ON clinic_bookings(booking_date);

-- Event indexes
CREATE INDEX IF NOT EXISTS idx_events_user ON events(user_id);
CREATE INDEX IF NOT EXISTS idx_events_date ON events(event_date);
CREATE INDEX IF NOT EXISTS idx_event_attendees_event ON event_attendees(event_id);

-- Coach indexes
CREATE INDEX IF NOT EXISTS idx_coach_programs_user ON coach_programs(user_id);
CREATE INDEX IF NOT EXISTS idx_coach_clients_user ON coach_clients(user_id);

-- Store indexes
CREATE INDEX IF NOT EXISTS idx_store_branches_user ON store_branches(user_id);
CREATE INDEX IF NOT EXISTS idx_store_products_user ON store_products(user_id);
CREATE INDEX IF NOT EXISTS idx_store_orders_user ON store_orders(user_id);
CREATE INDEX IF NOT EXISTS idx_store_orders_owner ON store_orders(store_owner_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);

-- Marketplace indexes
CREATE INDEX IF NOT EXISTS idx_used_items_user ON used_items(user_id);
CREATE INDEX IF NOT EXISTS idx_used_items_status ON used_items(status);

-- Shared indexes
CREATE INDEX IF NOT EXISTS idx_reviews_user ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_target ON reviews(target_type, target_id);
CREATE INDEX IF NOT EXISTS idx_chat_sender ON chat_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_chat_receiver ON chat_messages(receiver_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);

-- ============================================
-- TRIGGER FUNCTIONS FOR updated_at
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to all tables with updated_at
CREATE TRIGGER update_academy_branches_updated_at BEFORE UPDATE ON academy_branches FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_academy_programs_updated_at BEFORE UPDATE ON academy_programs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_clinic_branches_updated_at BEFORE UPDATE ON clinic_branches FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_clinic_services_updated_at BEFORE UPDATE ON clinic_services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_coach_programs_updated_at BEFORE UPDATE ON coach_programs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_branches_updated_at BEFORE UPDATE ON store_branches FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_products_updated_at BEFORE UPDATE ON store_products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_orders_updated_at BEFORE UPDATE ON store_orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_used_items_updated_at BEFORE UPDATE ON used_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
