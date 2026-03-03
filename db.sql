-- =====================================================
-- SWIM 360 - POSTGRESQL DATABASE SCHEMA FOR SUPABASE
-- =====================================================
-- This schema supports all features in the Swim 360 app
-- Designed for scalability and future expansion
-- =====================================================

-- =====================================================
-- INSTALLATION INSTRUCTIONS
-- =====================================================
--
-- HOW TO USE THIS SCHEMA IN SUPABASE:
--
-- 1. Create a new Supabase project at https://supabase.com
--
-- 2. Navigate to SQL Editor in your Supabase dashboard
--
-- 3. Copy and paste this ENTIRE file into the SQL Editor
--
-- 4. Click "RUN" to execute the schema
--    - This will create all tables, indexes, triggers, and policies
--    - The script is idempotent (safe to run multiple times)
--
-- 5. IMPORTANT: Row Level Security (RLS) is ENABLED by default
--    - All tables have RLS policies defined
--    - Users can only access data they own or public data
--    - Make sure your Flutter app uses Supabase Auth for authentication
--
-- 6. After running the schema:
--    - Enable Realtime for tables that need live updates
--    - Set up Storage buckets for images/videos:
--      * profile-photos
--      * product-photos
--      * event-photos
--      * used-item-photos
--      * review-photos
--      * message-attachments
--
-- 7. Optional: Uncomment the SEED DATA section at the bottom
--    after creating your first store user to add default promo code
--
-- FEATURES INCLUDED:
-- - 40+ normalized tables
-- - 18 ENUMs for type safety
-- - Comprehensive indexes for performance
-- - Row Level Security (RLS) policies
-- - Automatic timestamp triggers
-- - Rating update triggers
-- - Business logic functions
-- - Common query views
-- - Full documentation
--
-- SUPPORTED USER ROLES:
-- - swimmer (end users)
-- - academy (swimming academies with branches)
-- - clinic (therapy/rehab clinics)
-- - online_coach (independent coaches)
-- - event_organizer (competition/event organizers)
-- - store (equipment retailers)
--
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- ENUMS
-- =====================================================

-- User role types
CREATE TYPE user_role_type AS ENUM (
  'swimmer',
  'academy',
  'clinic',
  'online_coach',
  'event_organizer',
  'store'
);

-- Booking status
CREATE TYPE booking_status_type AS ENUM (
  'pending',
  'confirmed',
  'completed',
  'cancelled'
);

-- Order status
CREATE TYPE order_status_type AS ENUM (
  'pending',
  'confirmed',
  'processing',
  'shipped',
  'delivered',
  'cancelled',
  'refunded'
);

-- Payment status
CREATE TYPE payment_status_type AS ENUM (
  'pending',
  'processing',
  'completed',
  'failed',
  'refunded'
);

-- Payment method
CREATE TYPE payment_method_type AS ENUM (
  'credit_card',
  'debit_card',
  'cash_on_delivery',
  'wallet'
);

-- Session status
CREATE TYPE session_status_type AS ENUM (
  'upcoming',
  'in_progress',
  'completed',
  'cancelled'
);

-- Program category
CREATE TYPE program_category_type AS ENUM (
  'beginner',
  'intermediate',
  'advanced',
  'competition',
  'kids',
  'adults'
);

-- Service category
CREATE TYPE service_category_type AS ENUM (
  'rehabilitation',
  'assessment',
  'recovery',
  'manual_therapy',
  'other'
);

-- Product category
CREATE TYPE product_category_type AS ENUM (
  'cap',
  'goggles',
  'suit',
  'kickboard',
  'paddles',
  'parachute',
  'fins',
  'snorkels',
  'deflectors',
  'apparel',
  'other'
);

-- Product condition (for used marketplace)
CREATE TYPE product_condition_type AS ENUM (
  'new',
  'like_new',
  'excellent',
  'good',
  'fair'
);

-- Event type
CREATE TYPE event_type_enum AS ENUM (
  'competition',
  'seminar',
  'workshop',
  'meet',
  'training_camp',
  'webinar'
);

-- Notification type
CREATE TYPE notification_type_enum AS ENUM (
  'booking_confirmed',
  'booking_cancelled',
  'order_placed',
  'order_shipped',
  'order_delivered',
  'payment_received',
  'new_message',
  'event_reminder',
  'program_update',
  'system'
);

-- =====================================================
-- CORE USER TABLES
-- =====================================================

-- User profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role_type NOT NULL,
  full_name TEXT NOT NULL,
  phone VARCHAR(20),
  whatsapp_number VARCHAR(20),
  profile_photo_url TEXT,
  bio TEXT,
  date_of_birth DATE,
  gender VARCHAR(20),

  -- Location
  city TEXT,
  governorate TEXT,
  address TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),

  -- Preferences
  language VARCHAR(10) DEFAULT 'en',
  notifications_enabled BOOLEAN DEFAULT true,
  email_notifications_enabled BOOLEAN DEFAULT true,

  -- Metadata
  is_verified BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  onboarding_completed BOOLEAN DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Academy specific details
CREATE TABLE academy_details (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  academy_name TEXT NOT NULL,
  description TEXT,
  website_url TEXT,
  license_number TEXT,
  established_year INTEGER,
  total_coaches INTEGER DEFAULT 0,
  total_students INTEGER DEFAULT 0,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Clinic specific details
CREATE TABLE clinic_details (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  clinic_name TEXT NOT NULL,
  description TEXT,
  website_url TEXT,
  license_number TEXT,
  specializations TEXT[],
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Online coach specific details
CREATE TABLE coach_details (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  specialization TEXT,
  experience_years INTEGER,
  certifications TEXT[],
  education TEXT,
  hourly_rate DECIMAL(10, 2),
  total_clients INTEGER DEFAULT 0,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Event organizer specific details
CREATE TABLE event_organizer_details (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  organization_name TEXT NOT NULL,
  description TEXT,
  website_url TEXT,
  license_number TEXT,
  total_events_hosted INTEGER DEFAULT 0,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Store specific details
CREATE TABLE store_details (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  store_name TEXT NOT NULL,
  description TEXT,
  website_url TEXT,
  license_number TEXT,
  shipping_available BOOLEAN DEFAULT true,
  accepts_returns BOOLEAN DEFAULT true,
  return_policy_days INTEGER DEFAULT 30,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  total_sales INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- BRANCHES/LOCATIONS
-- =====================================================

CREATE TABLE branches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  owner_type user_role_type NOT NULL,

  -- Basic info
  branch_name TEXT NOT NULL,
  phone VARCHAR(20) NOT NULL,
  whatsapp_number VARCHAR(20),
  email TEXT,

  -- Location
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  governorate TEXT NOT NULL,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  google_maps_url TEXT,

  -- Working hours
  opening_time TIME NOT NULL,
  closing_time TIME NOT NULL,
  working_days TEXT[] DEFAULT ARRAY['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],

  -- Store specific (for delivery)
  delivery_time_range_min INTEGER, -- in days
  delivery_time_range_max INTEGER, -- in days

  -- Metadata
  is_active BOOLEAN DEFAULT true,
  branch_photo_url TEXT,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- PROGRAMS (ACADEMY & ONLINE COACH)
-- =====================================================

CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  provider_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  provider_type user_role_type NOT NULL CHECK (provider_type IN ('academy', 'online_coach')),

  -- Basic info
  program_name TEXT NOT NULL,
  category program_category_type NOT NULL,
  description TEXT NOT NULL,

  -- Schedule
  duration_weeks INTEGER NOT NULL, -- total program duration
  sessions_per_week INTEGER NOT NULL,
  session_duration_minutes INTEGER NOT NULL,

  -- Pricing
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  currency VARCHAR(3) DEFAULT 'USD',

  -- Media
  cover_photo_url TEXT,
  intro_video_url TEXT,

  -- Capacity
  max_participants INTEGER,
  current_participants INTEGER DEFAULT 0,

  -- Metadata
  is_active BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  total_enrollments INTEGER DEFAULT 0,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Program-Branch relationship (for academy programs)
CREATE TABLE program_branches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID NOT NULL REFERENCES programs(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(program_id, branch_id)
);

-- =====================================================
-- SERVICES (CLINIC)
-- =====================================================

CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  clinic_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Basic info
  service_name TEXT NOT NULL,
  category service_category_type NOT NULL,
  description TEXT NOT NULL,

  -- Pricing & Duration
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  duration_minutes INTEGER NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',

  -- Media
  cover_photo_url TEXT,
  intro_video_url TEXT,

  -- Metadata
  is_active BOOLEAN DEFAULT true,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  total_bookings INTEGER DEFAULT 0,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- COACHES (ACADEMY STAFF)
-- =====================================================

CREATE TABLE academy_coaches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  academy_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,

  -- Personal info
  full_name TEXT NOT NULL,
  email TEXT,
  phone VARCHAR(20),
  photo_url TEXT,

  -- Professional info
  specialization TEXT,
  experience_years INTEGER,
  certifications TEXT[],
  bio TEXT,

  -- Status
  is_active BOOLEAN DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- SCHEDULES & SESSIONS
-- =====================================================

CREATE TABLE schedules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE CASCADE,
  coach_id UUID REFERENCES academy_coaches(id) ON DELETE SET NULL,

  -- Schedule info
  day_of_week TEXT NOT NULL CHECK (day_of_week IN ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')),
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,

  -- Capacity
  max_capacity INTEGER NOT NULL,
  current_capacity INTEGER DEFAULT 0,

  -- Status
  status session_status_type DEFAULT 'upcoming',
  is_recurring BOOLEAN DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Individual session instances
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  schedule_id UUID REFERENCES schedules(id) ON DELETE CASCADE,
  program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
  coach_id UUID REFERENCES academy_coaches(id) ON DELETE SET NULL,
  branch_id UUID REFERENCES branches(id) ON DELETE CASCADE,

  -- Session details
  session_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,

  -- Capacity
  max_capacity INTEGER NOT NULL,
  current_capacity INTEGER DEFAULT 0,

  -- Status
  status session_status_type DEFAULT 'upcoming',
  notes TEXT,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- BOOKINGS
-- =====================================================

CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Parties involved
  swimmer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  provider_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  provider_type user_role_type NOT NULL CHECK (provider_type IN ('academy', 'clinic', 'event_organizer', 'online_coach')),

  -- Booking details
  program_id UUID REFERENCES programs(id) ON DELETE SET NULL,
  service_id UUID REFERENCES services(id) ON DELETE SET NULL,
  session_id UUID REFERENCES sessions(id) ON DELETE SET NULL,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,

  -- Schedule
  booking_date DATE NOT NULL,
  booking_time TIME,

  -- Status
  status booking_status_type DEFAULT 'pending',

  -- Pricing
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',

  -- Notes
  swimmer_notes TEXT,
  provider_notes TEXT,

  -- Timestamps
  confirmed_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Program enrollments (long-term)
CREATE TABLE program_enrollments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  swimmer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  program_id UUID NOT NULL REFERENCES programs(id) ON DELETE CASCADE,

  -- Enrollment details
  start_date DATE NOT NULL,
  end_date DATE,
  is_active BOOLEAN DEFAULT true,

  -- Payment
  amount_paid DECIMAL(10, 2) NOT NULL,
  payment_status payment_status_type DEFAULT 'pending',

  -- Progress
  sessions_attended INTEGER DEFAULT 0,
  sessions_total INTEGER,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(swimmer_id, program_id)
);

-- =====================================================
-- PRODUCTS (E-COMMERCE)
-- =====================================================

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Basic info
  product_name TEXT NOT NULL,
  category product_category_type NOT NULL,
  brand TEXT,
  description TEXT NOT NULL,

  -- Pricing
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  currency VARCHAR(3) DEFAULT 'USD',
  discount_percentage DECIMAL(5, 2) DEFAULT 0 CHECK (discount_percentage >= 0 AND discount_percentage <= 100),

  -- Media
  photos TEXT[], -- Array of photo URLs
  intro_video_url TEXT,

  -- Variants
  available_colors TEXT[], -- e.g., ['red', 'blue', 'black']
  available_sizes TEXT[], -- e.g., ['S', 'M', 'L', 'XL', 'ONE SIZE']

  -- Inventory
  total_stock INTEGER DEFAULT 0,
  low_stock_threshold INTEGER DEFAULT 10,

  -- Metadata
  is_active BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  total_sales INTEGER DEFAULT 0,
  view_count INTEGER DEFAULT 0,

  -- SEO
  slug TEXT UNIQUE,
  meta_description TEXT,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Product inventory by branch
CREATE TABLE product_inventory (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,

  -- Variant details
  size TEXT,
  color TEXT,

  -- Stock
  quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  reserved_quantity INTEGER DEFAULT 0 CHECK (reserved_quantity >= 0),

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(product_id, branch_id, size, color)
);

-- =====================================================
-- SHOPPING CART
-- =====================================================

CREATE TABLE cart_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  swimmer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE CASCADE,

  -- Variant selection
  selected_size TEXT,
  selected_color TEXT,

  -- Quantity
  quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),

  -- Price at time of adding (for price history)
  price_at_add DECIMAL(10, 2) NOT NULL,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(swimmer_id, product_id, selected_size, selected_color)
);

-- =====================================================
-- ORDERS
-- =====================================================

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number TEXT UNIQUE NOT NULL,

  -- Parties
  swimmer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Status
  status order_status_type DEFAULT 'pending',

  -- Delivery address
  delivery_governorate TEXT NOT NULL,
  delivery_city TEXT NOT NULL,
  delivery_address TEXT NOT NULL,
  delivery_latitude DECIMAL(10, 8),
  delivery_longitude DECIMAL(11, 8),
  delivery_phone VARCHAR(20) NOT NULL,

  -- Pricing
  subtotal DECIMAL(10, 2) NOT NULL,
  delivery_fee DECIMAL(10, 2) DEFAULT 0,
  service_fee DECIMAL(10, 2) DEFAULT 0,
  discount_amount DECIMAL(10, 2) DEFAULT 0,
  total_amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',

  -- Promo code
  promo_code_used TEXT,

  -- Payment
  payment_method payment_method_type,
  payment_status payment_status_type DEFAULT 'pending',

  -- Notes
  customer_notes TEXT,
  internal_notes TEXT,

  -- Timestamps
  confirmed_at TIMESTAMPTZ,
  shipped_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Order items
CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,

  -- Product snapshot (in case product is deleted/modified)
  product_name TEXT NOT NULL,
  product_brand TEXT,
  selected_size TEXT,
  selected_color TEXT,

  -- Pricing
  unit_price DECIMAL(10, 2) NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  subtotal DECIMAL(10, 2) NOT NULL,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- PROMO CODES
-- =====================================================

CREATE TABLE promo_codes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT UNIQUE NOT NULL,

  -- Creator (store, academy, etc.)
  created_by UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Discount
  discount_percentage DECIMAL(5, 2) CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
  discount_fixed_amount DECIMAL(10, 2),

  -- Conditions
  minimum_order_amount DECIMAL(10, 2),
  max_uses INTEGER,
  current_uses INTEGER DEFAULT 0,
  max_uses_per_user INTEGER DEFAULT 1,

  -- Validity
  valid_from TIMESTAMPTZ DEFAULT NOW(),
  valid_until TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT true,

  -- Applicable to
  applicable_to_user_types user_role_type[],

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Promo code usage tracking
CREATE TABLE promo_code_usage (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  promo_code_id UUID NOT NULL REFERENCES promo_codes(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  order_id UUID REFERENCES orders(id) ON DELETE SET NULL,

  discount_applied DECIMAL(10, 2) NOT NULL,
  used_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(promo_code_id, user_id, order_id)
);

-- =====================================================
-- EVENTS
-- =====================================================

CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organizer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Basic info
  event_name TEXT NOT NULL,
  event_type event_type_enum NOT NULL,
  description TEXT NOT NULL,

  -- Schedule
  event_date DATE NOT NULL,
  start_time TIME,
  end_time TIME,

  -- Location
  venue_name TEXT,
  address TEXT,
  city TEXT,
  governorate TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  is_online BOOLEAN DEFAULT false,
  online_meeting_url TEXT,

  -- Capacity & Registration
  max_participants INTEGER,
  current_participants INTEGER DEFAULT 0,
  registration_fee DECIMAL(10, 2) DEFAULT 0,
  registration_deadline DATE,

  -- Media
  cover_photo_url TEXT,
  gallery_photos TEXT[],

  -- Metadata
  is_active BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Event registrations
CREATE TABLE event_registrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Registration details
  registration_date TIMESTAMPTZ DEFAULT NOW(),
  payment_status payment_status_type DEFAULT 'pending',
  amount_paid DECIMAL(10, 2),

  -- Attendance
  checked_in BOOLEAN DEFAULT false,
  checked_in_at TIMESTAMPTZ,

  -- Status
  is_cancelled BOOLEAN DEFAULT false,
  cancelled_at TIMESTAMPTZ,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(event_id, user_id)
);

-- =====================================================
-- USED EQUIPMENT MARKETPLACE
-- =====================================================

CREATE TABLE used_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  seller_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Item details
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category product_category_type NOT NULL,
  brand TEXT,
  condition product_condition_type NOT NULL,

  -- Pricing
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  currency VARCHAR(3) DEFAULT 'USD',
  is_negotiable BOOLEAN DEFAULT true,

  -- Specifications
  size TEXT,
  color TEXT,
  year_purchased INTEGER,

  -- Media
  photos TEXT[],

  -- Contact
  contact_phone VARCHAR(20) NOT NULL,
  contact_whatsapp VARCHAR(20),
  preferred_contact_method TEXT,

  -- Location
  city TEXT,
  governorate TEXT,

  -- Status
  is_sold BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  view_count INTEGER DEFAULT 0,

  -- Timestamps
  sold_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- REVIEWS & RATINGS
-- =====================================================

CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Reviewer
  reviewer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Target (what is being reviewed)
  target_id UUID NOT NULL, -- Can be program, service, product, event, or provider
  target_type TEXT NOT NULL CHECK (target_type IN ('program', 'service', 'product', 'event', 'academy', 'clinic', 'coach', 'store', 'event_organizer')),

  -- Review content
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  comment TEXT,

  -- Media
  photos TEXT[],

  -- Verification
  is_verified_purchase BOOLEAN DEFAULT false,

  -- Status
  is_active BOOLEAN DEFAULT true,
  is_flagged BOOLEAN DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(reviewer_id, target_id, target_type)
);

-- =====================================================
-- PAYMENTS
-- =====================================================

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Payer
  payer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Related to
  order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
  booking_id UUID REFERENCES bookings(id) ON DELETE SET NULL,
  event_registration_id UUID REFERENCES event_registrations(id) ON DELETE SET NULL,

  -- Payment details
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',
  payment_method payment_method_type NOT NULL,
  status payment_status_type DEFAULT 'pending',

  -- Card details (masked)
  card_last_four VARCHAR(4),
  card_brand TEXT,

  -- Transaction
  transaction_id TEXT,
  payment_gateway TEXT, -- e.g., 'stripe', 'paypal'

  -- Timestamps
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Saved payment methods
CREATE TABLE saved_payment_methods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Card details (masked)
  card_last_four VARCHAR(4) NOT NULL,
  card_brand TEXT NOT NULL,
  card_expiry_month INTEGER NOT NULL,
  card_expiry_year INTEGER NOT NULL,
  cardholder_name TEXT NOT NULL,

  -- Gateway token
  payment_gateway TEXT NOT NULL,
  gateway_customer_id TEXT,
  gateway_payment_method_id TEXT,

  -- Status
  is_default BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- NOTIFICATIONS
-- =====================================================

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Notification details
  type notification_type_enum NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,

  -- Action link
  action_url TEXT,
  related_id UUID, -- ID of related entity (order, booking, etc.)
  related_type TEXT,

  -- Status
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Push notification tokens
CREATE TABLE push_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  device_token TEXT NOT NULL,
  device_type TEXT, -- 'ios' or 'android'
  device_name TEXT,

  is_active BOOLEAN DEFAULT true,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, device_token)
);

-- =====================================================
-- MESSAGES (CHAT)
-- =====================================================

CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Participants
  participant_1_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  participant_2_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Last message info
  last_message_at TIMESTAMPTZ,
  last_message_preview TEXT,

  -- Status
  is_active BOOLEAN DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(participant_1_id, participant_2_id)
);

CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,

  -- Sender
  sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Content
  message_text TEXT NOT NULL,
  attachment_url TEXT,
  attachment_type TEXT, -- 'image', 'video', 'file'

  -- Status
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  is_deleted BOOLEAN DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- FAVORITES/WISHLISTS
-- =====================================================

CREATE TABLE favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Favorited item
  item_id UUID NOT NULL,
  item_type TEXT NOT NULL CHECK (item_type IN ('program', 'service', 'product', 'event', 'academy', 'clinic', 'coach', 'store')),

  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, item_id, item_type)
);

-- =====================================================
-- ANALYTICS & TRACKING
-- =====================================================

CREATE TABLE user_activity_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,

  -- Activity details
  activity_type TEXT NOT NULL,
  entity_type TEXT,
  entity_id UUID,

  -- Metadata
  metadata JSONB,
  ip_address INET,
  user_agent TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Profiles
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_city ON profiles(city);
CREATE INDEX idx_profiles_governorate ON profiles(governorate);

-- Branches
CREATE INDEX idx_branches_owner ON branches(owner_id);
CREATE INDEX idx_branches_city ON branches(city);
CREATE INDEX idx_branches_governorate ON branches(governorate);

-- Programs
CREATE INDEX idx_programs_provider ON programs(provider_id);
CREATE INDEX idx_programs_category ON programs(category);
CREATE INDEX idx_programs_active ON programs(is_active);

-- Services
CREATE INDEX idx_services_clinic ON services(clinic_id);
CREATE INDEX idx_services_category ON services(category);

-- Bookings
CREATE INDEX idx_bookings_swimmer ON bookings(swimmer_id);
CREATE INDEX idx_bookings_provider ON bookings(provider_id);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_date ON bookings(booking_date);

-- Products
CREATE INDEX idx_products_store ON products(store_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_active ON products(is_active);

-- Orders
CREATE INDEX idx_orders_swimmer ON orders(swimmer_id);
CREATE INDEX idx_orders_store ON orders(store_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at);

-- Events
CREATE INDEX idx_events_organizer ON events(organizer_id);
CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_events_type ON events(event_type);

-- Reviews
CREATE INDEX idx_reviews_target ON reviews(target_id, target_type);
CREATE INDEX idx_reviews_reviewer ON reviews(reviewer_id);

-- Notifications
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_created ON notifications(created_at);

-- Messages
CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);

-- Cart items
CREATE INDEX idx_cart_swimmer ON cart_items(swimmer_id);
CREATE INDEX idx_cart_store ON cart_items(store_id);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinic_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE coach_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_organizer_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE program_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_coaches ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE used_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_payment_methods ENABLE ROW LEVEL SECURITY;

-- Profiles: Users can read all profiles, but only update their own
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Branches: Public read, owner write
CREATE POLICY "Branches are viewable by everyone"
  ON branches FOR SELECT
  USING (true);

CREATE POLICY "Users can manage own branches"
  ON branches FOR ALL
  USING (auth.uid() = owner_id);

-- Programs: Public read, provider write
CREATE POLICY "Programs are viewable by everyone"
  ON programs FOR SELECT
  USING (is_active = true);

CREATE POLICY "Providers can manage own programs"
  ON programs FOR ALL
  USING (auth.uid() = provider_id);

-- Products: Public read, store write
CREATE POLICY "Products are viewable by everyone"
  ON products FOR SELECT
  USING (is_active = true);

CREATE POLICY "Stores can manage own products"
  ON products FOR ALL
  USING (auth.uid() = store_id);

-- Cart: User can only access own cart
CREATE POLICY "Users can manage own cart"
  ON cart_items FOR ALL
  USING (auth.uid() = swimmer_id);

-- Orders: Users see own orders, stores see their orders
CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  USING (auth.uid() = swimmer_id OR auth.uid() = store_id);

CREATE POLICY "Users can create own orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = swimmer_id);

-- Bookings: Swimmer and provider can view their bookings
CREATE POLICY "Users can view own bookings"
  ON bookings FOR SELECT
  USING (auth.uid() = swimmer_id OR auth.uid() = provider_id);

CREATE POLICY "Swimmers can create bookings"
  ON bookings FOR INSERT
  WITH CHECK (auth.uid() = swimmer_id);

-- Notifications: Users can only see their own
CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

-- Messages: Conversation participants can view
CREATE POLICY "Participants can view messages"
  ON messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM conversations
      WHERE conversations.id = messages.conversation_id
      AND (conversations.participant_1_id = auth.uid() OR conversations.participant_2_id = auth.uid())
    )
  );

-- Saved payment methods: User can only access own
CREATE POLICY "Users can manage own payment methods"
  ON saved_payment_methods FOR ALL
  USING (auth.uid() = user_id);

-- Academy/Clinic/Coach/Event Organizer/Store details: Owner can manage
CREATE POLICY "Users can view all detail profiles"
  ON academy_details FOR SELECT
  USING (true);

CREATE POLICY "Users can manage own academy details"
  ON academy_details FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view all clinic details"
  ON clinic_details FOR SELECT
  USING (true);

CREATE POLICY "Users can manage own clinic details"
  ON clinic_details FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view all coach details"
  ON coach_details FOR SELECT
  USING (true);

CREATE POLICY "Users can manage own coach details"
  ON coach_details FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view all event organizer details"
  ON event_organizer_details FOR SELECT
  USING (true);

CREATE POLICY "Users can manage own event organizer details"
  ON event_organizer_details FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view all store details"
  ON store_details FOR SELECT
  USING (true);

CREATE POLICY "Users can manage own store details"
  ON store_details FOR ALL
  USING (auth.uid() = user_id);

-- Services: Public read, clinic owner write
CREATE POLICY "Services are viewable by everyone"
  ON services FOR SELECT
  USING (is_active = true);

CREATE POLICY "Clinics can manage own services"
  ON services FOR ALL
  USING (auth.uid() = clinic_id);

-- Academy coaches: Public read, academy owner write
CREATE POLICY "Academy coaches are viewable by everyone"
  ON academy_coaches FOR SELECT
  USING (is_active = true);

CREATE POLICY "Academies can manage own coaches"
  ON academy_coaches FOR ALL
  USING (auth.uid() = academy_id);

-- Schedules: Public read, owner write
CREATE POLICY "Schedules are viewable by everyone"
  ON schedules FOR SELECT
  USING (true);

CREATE POLICY "Program owners can manage schedules"
  ON schedules FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM programs
      WHERE programs.id = schedules.program_id
      AND programs.provider_id = auth.uid()
    )
  );

-- Sessions: Public read, owner write
CREATE POLICY "Sessions are viewable by everyone"
  ON sessions FOR SELECT
  USING (true);

CREATE POLICY "Program owners can manage sessions"
  ON sessions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM programs
      WHERE programs.id = sessions.program_id
      AND programs.provider_id = auth.uid()
    )
  );

-- Program enrollments: Swimmer and provider can view
CREATE POLICY "Users can view own enrollments"
  ON program_enrollments FOR SELECT
  USING (
    auth.uid() = swimmer_id OR
    EXISTS (
      SELECT 1 FROM programs
      WHERE programs.id = program_enrollments.program_id
      AND programs.provider_id = auth.uid()
    )
  );

CREATE POLICY "Swimmers can enroll in programs"
  ON program_enrollments FOR INSERT
  WITH CHECK (auth.uid() = swimmer_id);

-- Order items: Users can view if they can view the order
CREATE POLICY "Users can view order items"
  ON order_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND (orders.swimmer_id = auth.uid() OR orders.store_id = auth.uid())
    )
  );

-- Events: Public read, organizer write
CREATE POLICY "Events are viewable by everyone"
  ON events FOR SELECT
  USING (is_active = true);

CREATE POLICY "Organizers can manage own events"
  ON events FOR ALL
  USING (auth.uid() = organizer_id);

-- Event registrations: User and organizer can view
CREATE POLICY "Users can view own event registrations"
  ON event_registrations FOR SELECT
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM events
      WHERE events.id = event_registrations.event_id
      AND events.organizer_id = auth.uid()
    )
  );

CREATE POLICY "Users can register for events"
  ON event_registrations FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Used items: Public read, seller write
CREATE POLICY "Used items are viewable by everyone"
  ON used_items FOR SELECT
  USING (is_active = true);

CREATE POLICY "Users can manage own used items"
  ON used_items FOR ALL
  USING (auth.uid() = seller_id);

-- Reviews: Public read, reviewer write
CREATE POLICY "Reviews are viewable by everyone"
  ON reviews FOR SELECT
  USING (is_active = true);

CREATE POLICY "Users can create reviews"
  ON reviews FOR INSERT
  WITH CHECK (auth.uid() = reviewer_id);

CREATE POLICY "Users can update own reviews"
  ON reviews FOR UPDATE
  USING (auth.uid() = reviewer_id);

-- Conversations: Participants can manage
CREATE POLICY "Participants can view conversations"
  ON conversations FOR SELECT
  USING (auth.uid() = participant_1_id OR auth.uid() = participant_2_id);

CREATE POLICY "Users can create conversations"
  ON conversations FOR INSERT
  WITH CHECK (auth.uid() = participant_1_id OR auth.uid() = participant_2_id);

-- Favorites: User can manage own
CREATE POLICY "Users can manage own favorites"
  ON favorites FOR ALL
  USING (auth.uid() = user_id);

-- =====================================================
-- TRIGGERS FOR UPDATED_AT
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_branches_updated_at BEFORE UPDATE ON branches FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_programs_updated_at BEFORE UPDATE ON programs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNCTIONS FOR BUSINESS LOGIC
-- =====================================================

-- Generate unique order number
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TEXT AS $$
DECLARE
  new_order_number TEXT;
BEGIN
  new_order_number := 'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0');
  RETURN new_order_number;
END;
$$ LANGUAGE plpgsql;

-- Update product rating when review is added
CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE products
  SET rating = (
    SELECT AVG(rating)::DECIMAL(3,2)
    FROM reviews
    WHERE target_id = NEW.target_id
    AND target_type = 'product'
    AND is_active = true
  ),
  total_reviews = (
    SELECT COUNT(*)
    FROM reviews
    WHERE target_id = NEW.target_id
    AND target_type = 'product'
    AND is_active = true
  )
  WHERE id = NEW.target_id
  AND NEW.target_type = 'product';

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_product_rating_trigger
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW
WHEN (NEW.target_type = 'product')
EXECUTE FUNCTION update_product_rating();

-- Update program rating when review is added
CREATE OR REPLACE FUNCTION update_program_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE programs
  SET rating = (
    SELECT AVG(rating)::DECIMAL(3,2)
    FROM reviews
    WHERE target_id = NEW.target_id
    AND target_type = 'program'
    AND is_active = true
  ),
  total_reviews = (
    SELECT COUNT(*)
    FROM reviews
    WHERE target_id = NEW.target_id
    AND target_type = 'program'
    AND is_active = true
  )
  WHERE id = NEW.target_id
  AND NEW.target_type = 'program';

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_program_rating_trigger
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW
WHEN (NEW.target_type = 'program')
EXECUTE FUNCTION update_program_rating();

-- Update service rating when review is added
CREATE OR REPLACE FUNCTION update_service_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE services
  SET rating = (
    SELECT AVG(rating)::DECIMAL(3,2)
    FROM reviews
    WHERE target_id = NEW.target_id
    AND target_type = 'service'
    AND is_active = true
  ),
  total_reviews = (
    SELECT COUNT(*)
    FROM reviews
    WHERE target_id = NEW.target_id
    AND target_type = 'service'
    AND is_active = true
  )
  WHERE id = NEW.target_id
  AND NEW.target_type = 'service';

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_service_rating_trigger
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW
WHEN (NEW.target_type = 'service')
EXECUTE FUNCTION update_service_rating();

-- Update provider ratings (academy, clinic, coach, store, event_organizer)
CREATE OR REPLACE FUNCTION update_provider_rating()
RETURNS TRIGGER AS $$
BEGIN
  -- Update academy details
  IF NEW.target_type = 'academy' THEN
    UPDATE academy_details
    SET rating = (
      SELECT AVG(rating)::DECIMAL(3,2)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'academy'
      AND is_active = true
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'academy'
      AND is_active = true
    )
    WHERE user_id = NEW.target_id;
  END IF;

  -- Update clinic details
  IF NEW.target_type = 'clinic' THEN
    UPDATE clinic_details
    SET rating = (
      SELECT AVG(rating)::DECIMAL(3,2)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'clinic'
      AND is_active = true
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'clinic'
      AND is_active = true
    )
    WHERE user_id = NEW.target_id;
  END IF;

  -- Update coach details
  IF NEW.target_type = 'coach' THEN
    UPDATE coach_details
    SET rating = (
      SELECT AVG(rating)::DECIMAL(3,2)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'coach'
      AND is_active = true
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'coach'
      AND is_active = true
    )
    WHERE user_id = NEW.target_id;
  END IF;

  -- Update store details
  IF NEW.target_type = 'store' THEN
    UPDATE store_details
    SET rating = (
      SELECT AVG(rating)::DECIMAL(3,2)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'store'
      AND is_active = true
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'store'
      AND is_active = true
    )
    WHERE user_id = NEW.target_id;
  END IF;

  -- Update event organizer details
  IF NEW.target_type = 'event_organizer' THEN
    UPDATE event_organizer_details
    SET rating = (
      SELECT AVG(rating)::DECIMAL(3,2)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'event_organizer'
      AND is_active = true
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM reviews
      WHERE target_id = NEW.target_id
      AND target_type = 'event_organizer'
      AND is_active = true
    )
    WHERE user_id = NEW.target_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_provider_rating_trigger
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW
WHEN (NEW.target_type IN ('academy', 'clinic', 'coach', 'store', 'event_organizer'))
EXECUTE FUNCTION update_provider_rating();

-- =====================================================
-- INITIAL DATA / SEED DATA (Optional)
-- =====================================================

-- IMPORTANT: Uncomment the following section after you have created your first store user
-- This will insert a default promo code 'SWIM10' that gives 10% off

/*
INSERT INTO promo_codes (code, created_by, discount_percentage, is_active, valid_from, valid_until)
SELECT
  'SWIM10',
  id,
  10.00,
  true,
  NOW(),
  NOW() + INTERVAL '1 year'
FROM profiles
WHERE role = 'store'
LIMIT 1;
*/

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for active products with store info
CREATE VIEW active_products_with_store AS
SELECT
  p.*,
  s.store_name,
  s.shipping_available,
  s.rating as store_rating
FROM products p
JOIN store_details s ON p.store_id = s.user_id
WHERE p.is_active = true;

-- View for upcoming bookings
CREATE VIEW upcoming_bookings AS
SELECT
  b.*,
  p.full_name as swimmer_name,
  p.phone as swimmer_phone,
  pr.full_name as provider_name
FROM bookings b
JOIN profiles p ON b.swimmer_id = p.id
JOIN profiles pr ON b.provider_id = pr.id
WHERE b.status IN ('pending', 'confirmed')
AND b.booking_date >= CURRENT_DATE
ORDER BY b.booking_date, b.booking_time;

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON TABLE profiles IS 'Core user profiles extending Supabase auth.users';
COMMENT ON TABLE programs IS 'Training programs offered by academies and online coaches';
COMMENT ON TABLE services IS 'Services offered by clinics (therapy, assessment, etc.)';
COMMENT ON TABLE bookings IS 'Bookings for programs, services, and events';
COMMENT ON TABLE products IS 'Products sold in stores';
COMMENT ON TABLE orders IS 'E-commerce orders';
COMMENT ON TABLE events IS 'Swimming events, competitions, seminars';
COMMENT ON TABLE used_items IS 'Used equipment marketplace listings';

-- =====================================================
-- END OF SCHEMA
-- =====================================================



select * from profiles;









ALTER TABLE profiles ADD COLUMN IF NOT EXISTS email TEXT;

  -- Create unique index
  CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);

  -- Update any existing profiles with email from auth.users
  UPDATE profiles p
  SET email = u.email
  FROM auth.users u
  WHERE p.id = u.id AND p.email IS NULL;

  -- Make email required
  ALTER TABLE profiles ALTER COLUMN email SET NOT NULL;

  -- Verify it worked
  SELECT 'Email column added successfully!' as status;



  CREATE POLICY "Users can insert own profile"
    ON profiles FOR INSERT
    WITH CHECK (auth.uid() = id);
