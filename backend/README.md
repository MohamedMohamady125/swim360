# Swim360 Backend API

A comprehensive FastAPI backend for the Swim360 platform - connecting swimmers with academies, clinics, coaches, event organizers, and equipment stores.

## Features

- **🔐 Authentication**: JWT-based auth with Supabase integration
- **👥 Multi-Role System**: 6 user types (swimmer, academy, clinic, coach, event organizer, store)
- **🏊 Programs & Services**: Training programs and rehabilitation services
- **🛒 E-Commerce**: Product catalog, shopping cart, orders, payments
- **📅 Bookings**: Book programs, services, and events
- **🎉 Events**: Swimming competitions, seminars, and workshops
- **💬 Real-time Chat**: One-on-one messaging
- **⭐ Reviews & Ratings**: Rate and review services and products
- **🔔 Notifications**: Push notifications and in-app alerts
- **📍 Location-based Search**: Find services near you
- **🖼️ File Storage**: Supabase Storage integration

## Tech Stack

- **Framework**: FastAPI 0.109+
- **Database**: PostgreSQL (via Supabase)
- **ORM**: SQLAlchemy 2.0 + Databases (async)
- **Authentication**: Supabase Auth + JWT
- **Storage**: Supabase Storage
- **Validation**: Pydantic v2
- **Deployment**: Docker + Docker Compose

## Project Structure

```
backend/
├── app/
│   ├── api/
│   │   ├── dependencies/    # Auth and common dependencies
│   │   │   └── auth.py      # Authentication dependencies
│   │   └── endpoints/       # API route handlers
│   │       ├── auth.py      # Authentication endpoints
│   │       ├── users.py     # User and profile management
│   │       ├── programs.py  # Training programs
│   │       ├── services.py  # Clinic services
│   │       ├── products.py  # E-commerce products
│   │       ├── bookings.py  # Booking management
│   │       ├── orders.py    # Order management
│   │       ├── events.py    # Events and registrations
│   │       ├── chat.py      # Messaging
│   │       └── reviews.py   # Reviews, ratings, favorites
│   ├── core/
│   │   ├── config.py        # Settings and configuration
│   │   ├── database.py      # Database connection
│   │   ├── security.py      # JWT and password hashing
│   │   └── supabase.py      # Supabase client
│   ├── models/              # SQLAlchemy models
│   ├── schemas/             # Pydantic schemas
│   │   ├── auth.py          # Auth schemas
│   │   ├── user.py          # User schemas
│   │   ├── program.py       # Program schemas
│   │   ├── service.py       # Service schemas
│   │   ├── product.py       # Product schemas
│   │   ├── booking.py       # Booking schemas
│   │   ├── order.py         # Order schemas
│   │   ├── event.py         # Event schemas
│   │   ├── chat.py          # Chat schemas
│   │   ├── review.py        # Review schemas
│   │   └── common.py        # Common schemas and enums
│   ├── services/            # Business logic
│   ├── utils/               # Utility functions
│   └── main.py              # FastAPI app entry point
├── tests/                   # Test suite
├── .env.example             # Environment variables template
├── requirements.txt         # Python dependencies
├── Dockerfile               # Docker configuration
├── docker-compose.yml       # Docker Compose setup
└── README.md                # This file
```

## Quick Start

### Prerequisites

- Python 3.11+
- PostgreSQL (or Supabase account)
- Docker & Docker Compose (optional)

### 1. Clone and Install

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configure Environment

Copy `.env.example` to `.env` and update with your credentials:

```bash
cp .env.example .env
```

**Required Environment Variables:**

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/swim360
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-key

# Security
SECRET_KEY=your-secret-key-change-in-production
SUPABASE_JWT_SECRET=your-supabase-jwt-secret

# Optional Services
SENDGRID_API_KEY=your-sendgrid-key
TWILIO_ACCOUNT_SID=your-twilio-sid
TWILIO_AUTH_TOKEN=your-twilio-token
STRIPE_SECRET_KEY=your-stripe-key
```

### 3. Set Up Database

Run the database schema from `/db.sql`:

```bash
# If using local PostgreSQL
psql -U swim360 -d swim360_db -f ../db.sql

# If using Supabase
# Paste the contents of db.sql into Supabase SQL Editor and execute
```

### 4. Run the Server

**Development Mode:**

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Production Mode:**

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

**Using Docker:**

```bash
docker-compose up -d
```

The API will be available at:
- **API**: http://localhost:8000
- **Docs**: http://localhost:8000/api/v1/docs
- **ReDoc**: http://localhost:8000/api/v1/redoc

## API Documentation

### Authentication

All protected endpoints require a Bearer token:

```bash
Authorization: Bearer <your_access_token>
```

Get your token by calling `/api/v1/auth/login`

### Key Endpoints

#### Authentication
- `POST /api/v1/auth/signup` - Register new user
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - Logout
- `POST /api/v1/auth/verify-email` - Verify email
- `POST /api/v1/auth/forgot-password` - Request password reset
- `POST /api/v1/auth/reset-password` - Reset password
- `GET /api/v1/auth/me` - Get current user

#### Users & Profiles
- `GET /api/v1/users/profile` - Get my profile
- `PUT /api/v1/users/profile` - Update profile
- `GET /api/v1/users/profile/{user_id}` - Get user profile
- `GET /api/v1/users/branches` - Get my branches
- `POST /api/v1/users/branches` - Create branch
- `PUT /api/v1/users/branches/{id}` - Update branch

#### Programs
- `GET /api/v1/programs` - List all programs
- `POST /api/v1/programs` - Create program (Academy/Coach)
- `GET /api/v1/programs/{id}` - Get program details
- `PUT /api/v1/programs/{id}` - Update program
- `DELETE /api/v1/programs/{id}` - Delete program
- `POST /api/v1/programs/{id}/enroll` - Enroll in program

#### Services
- `GET /api/v1/services` - List all services
- `POST /api/v1/services` - Create service (Clinic)
- `GET /api/v1/services/{id}` - Get service details
- `PUT /api/v1/services/{id}` - Update service
- `DELETE /api/v1/services/{id}` - Delete service

#### Products & Marketplace
- `GET /api/v1/products` - List all products
- `POST /api/v1/products` - Create product (Store)
- `GET /api/v1/products/{id}` - Get product details
- `PUT /api/v1/products/{id}` - Update product
- `GET /api/v1/products/cart` - Get shopping cart
- `POST /api/v1/products/cart` - Add to cart
- `DELETE /api/v1/products/cart/{id}` - Remove from cart

#### Orders
- `GET /api/v1/orders` - List my orders
- `POST /api/v1/orders` - Create order (checkout)
- `GET /api/v1/orders/{id}` - Get order details
- `PUT /api/v1/orders/{id}/status` - Update order status (Store)

#### Bookings
- `GET /api/v1/bookings` - List my bookings
- `POST /api/v1/bookings` - Create booking
- `PUT /api/v1/bookings/{id}` - Update booking

#### Events
- `GET /api/v1/events` - List all events
- `POST /api/v1/events` - Create event (Organizer)
- `GET /api/v1/events/{id}` - Get event details
- `POST /api/v1/events/{id}/register` - Register for event

#### Chat
- `GET /api/v1/chat/conversations` - List conversations
- `POST /api/v1/chat/conversations` - Create conversation
- `GET /api/v1/chat/conversations/{id}/messages` - Get messages
- `POST /api/v1/chat/messages` - Send message

#### Reviews & Social
- `GET /api/v1/reviews` - List reviews
- `POST /api/v1/reviews` - Create review
- `PUT /api/v1/reviews/{id}` - Update review
- `GET /api/v1/reviews/favorites` - Get favorites
- `POST /api/v1/reviews/favorites` - Add to favorites
- `GET /api/v1/reviews/notifications` - Get notifications

## Testing

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run specific test file
pytest tests/test_auth.py
```

## Deployment

### Using Docker

```bash
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f api

# Stop
docker-compose down
```

### Manual Deployment

1. Set environment variables
2. Install dependencies: `pip install -r requirements.txt`
3. Run with gunicorn or uvicorn:

```bash
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

### Environment-specific Settings

- **Development**: Set `DEBUG=True`, `ENVIRONMENT=development`
- **Staging**: Set `DEBUG=False`, `ENVIRONMENT=staging`
- **Production**: Set `DEBUG=False`, `ENVIRONMENT=production`, use strong SECRET_KEY

## Security Best Practices

1. **Never commit `.env` files** - Use environment variables
2. **Use strong SECRET_KEY** - Generate with `openssl rand -hex 32`
3. **Enable HTTPS** in production
4. **Use Supabase RLS** - Row Level Security is enabled by default
5. **Rate limiting** - Consider adding rate limiting middleware
6. **Input validation** - All inputs are validated via Pydantic
7. **SQL injection prevention** - Use parameterized queries

## Performance Optimization

- **Database indexes**: Already defined in db.sql
- **Connection pooling**: Configured in database.py
- **Async operations**: All database queries are async
- **Caching**: Consider adding Redis for frequently accessed data
- **CDN**: Use CDN for static files and images

## Monitoring & Logging

Logs are stored in `logs/app.log`. Configure log level via `LOG_LEVEL` environment variable.

**Available log levels**: DEBUG, INFO, WARNING, ERROR, CRITICAL

## Contributing

1. Create a feature branch
2. Make your changes
3. Write tests
4. Run tests: `pytest`
5. Format code: `black app/`
6. Submit pull request

## Troubleshooting

### Database Connection Error

```bash
# Check database is running
docker-compose ps

# Check connection string
echo $DATABASE_URL
```

### Import Errors

```bash
# Reinstall dependencies
pip install -r requirements.txt --force-reinstall
```

### Supabase Auth Issues

- Verify `SUPABASE_URL` and `SUPABASE_KEY` are correct
- Check Supabase dashboard for auth settings
- Ensure JWT secret matches Supabase project

## Support

For issues, questions, or contributions:
- GitHub Issues: [github.com/your-repo/issues](https://github.com/your-repo/issues)
- Email: support@swim360.com

## License

Proprietary - All rights reserved

---

**Built with ❤️ for the swimming community**
