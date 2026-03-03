# Swim360 Backend - Quick Start Guide

Get your Swim360 backend up and running in 5 minutes!

## 🚀 Quick Start (5 minutes)

### Step 1: Set Up Supabase (2 minutes)

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Go to **SQL Editor** in Supabase dashboard
4. Copy the entire contents of `/db.sql` and paste it into the SQL Editor
5. Click **RUN** to create all tables, indexes, and policies
6. Go to **Settings > API** and copy:
   - `Project URL` (SUPABASE_URL)
   - `anon public` key (SUPABASE_KEY)
   - `service_role` key (SUPABASE_SERVICE_KEY)
7. Go to **Settings > API > JWT Settings** and copy the JWT Secret

### Step 2: Configure Backend (1 minute)

```bash
cd backend

# Copy environment template
cp .env.example .env

# Edit .env and add your Supabase credentials
nano .env  # or use your preferred editor
```

**Required settings in `.env`:**

```env
# From Supabase Settings > API
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_JWT_SECRET=your-jwt-secret-from-supabase

# Database URL (use your Supabase PostgreSQL connection string)
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.xxxxxxxxxxxxx.supabase.co:5432/postgres

# Generate a secure secret key
SECRET_KEY=your-secret-key-here-change-this-to-something-random
```

To generate a secure SECRET_KEY:
```bash
openssl rand -hex 32
```

### Step 3: Run the Backend (2 minutes)

**Option A: Using the Quick Start Script (Recommended)**

```bash
./run.sh
```

**Option B: Manual Setup**

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Option C: Using Docker**

```bash
docker-compose up -d
```

### Step 4: Test the API ✅

Open your browser and go to:
- **API Health**: http://localhost:8000/health
- **API Docs**: http://localhost:8000/api/v1/docs

You should see the Swagger UI with all available endpoints!

## 🧪 Test with Sample Requests

### 1. Register a New User

```bash
curl -X POST "http://localhost:8000/api/v1/auth/signup" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123!",
    "full_name": "Test User",
    "phone": "+201234567890",
    "role": "swimmer",
    "governorate": "Cairo",
    "city": "Maadi"
  }'
```

### 2. Login

```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123!"
  }'
```

Save the `access_token` from the response!

### 3. Get Your Profile

```bash
curl -X GET "http://localhost:8000/api/v1/users/profile" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

## 🎯 Next Steps

### For Swimmers:
- Browse programs: `GET /api/v1/programs`
- Browse products: `GET /api/v1/products`
- Browse events: `GET /api/v1/events`

### For Service Providers (Academy, Clinic, Coach, Store, Organizer):
1. Update your role-specific details
2. Create branches (if applicable)
3. Create your listings (programs, services, products, events)

### Set Up Storage Buckets

The backend will automatically create required storage buckets on startup:
- profile-photos
- product-photos
- event-photos
- used-item-photos
- review-photos
- message-attachments
- branch-photos

But you should set appropriate permissions in Supabase Storage dashboard.

## 📖 API Documentation

Once running, comprehensive API documentation is available at:
- **Swagger UI**: http://localhost:8000/api/v1/docs
- **ReDoc**: http://localhost:8000/api/v1/redoc

## 🐛 Troubleshooting

### Database Connection Error

**Error**: `connection to server failed`

**Solution**:
1. Check your `DATABASE_URL` in `.env`
2. Make sure it matches your Supabase PostgreSQL connection string
3. Find it in Supabase: Settings > Database > Connection String

### Supabase Auth Error

**Error**: `Invalid Supabase token`

**Solution**:
1. Verify `SUPABASE_URL`, `SUPABASE_KEY`, and `SUPABASE_SERVICE_KEY`
2. Make sure you're using the correct keys from Supabase Settings > API
3. Check that `SUPABASE_JWT_SECRET` matches your project's JWT secret

### Import Errors

**Error**: `ModuleNotFoundError: No module named 'app'`

**Solution**:
```bash
# Make sure you're in the backend directory
cd backend

# Reinstall dependencies
pip install -r requirements.txt
```

### Port Already in Use

**Error**: `Address already in use`

**Solution**:
```bash
# Find and kill the process using port 8000
lsof -ti:8000 | xargs kill -9

# Or use a different port
uvicorn app.main:app --reload --port 8001
```

## 🔑 User Roles

The system supports 6 user roles:

1. **swimmer** - End users who book services and buy products
2. **academy** - Swimming training centers with branches and programs
3. **clinic** - Therapy/rehab clinics offering services
4. **online_coach** - Independent coaches offering personalized training
5. **event_organizer** - Organizations hosting swimming events
6. **store** - Equipment retailers selling swimming gear

Each role has different permissions and capabilities!

## 📞 Need Help?

- Check the full [README.md](README.md) for detailed documentation
- Review the database schema in `/db.sql`
- Test endpoints using the Swagger UI at `/api/v1/docs`

---

**Happy Coding! 🏊‍♂️🚀**
