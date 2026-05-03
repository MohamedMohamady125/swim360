"""
Main FastAPI application
"""
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from contextlib import asynccontextmanager
import time

from app.core.config import (
    settings,
    API_TITLE,
    API_DESCRIPTION,
    API_VERSION_INFO,
    API_CONTACT,
    API_LICENSE,
)
from app.core.database import connect_db, disconnect_db, check_db_connection
from app.core.supabase import initialize_storage_buckets

# Import routers
from app.api.endpoints import auth
from app.api.endpoints import users
from app.api.endpoints import programs
from app.api.endpoints import services
from app.api.endpoints import products
from app.api.endpoints import bookings
from app.api.endpoints import orders
from app.api.endpoints import events
from app.api.endpoints import chat
from app.api.endpoints import reviews
from app.api.endpoints import academies
from app.api.endpoints import clinics
from app.api.endpoints import stores


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Lifecycle manager for startup and shutdown events
    """
    # Startup
    print("🚀 Starting Swim360 API...")

    # Try to connect to database (non-fatal if it fails)
    try:
        await connect_db()
    except Exception as e:
        print(f"⚠️  Database connection failed: {e}")
        print("⚠️  API will start without database connection")

    # Try to initialize storage buckets
    try:
        await initialize_storage_buckets()
    except Exception as e:
        print(f"⚠️  Storage initialization failed: {e}")

    print("✅ Swim360 API is ready!")

    yield

    # Shutdown
    print("⏳ Shutting down Swim360 API...")
    try:
        await disconnect_db()
    except Exception:
        pass
    print("👋 Swim360 API stopped")


# Initialize FastAPI app
app = FastAPI(
    title=API_TITLE,
    description=API_DESCRIPTION,
    version=API_VERSION_INFO,
    contact=API_CONTACT,
    license_info=API_LICENSE,
    docs_url=f"/api/{settings.api_version}/docs",
    redoc_url=f"/api/{settings.api_version}/redoc",
    openapi_url=f"/api/{settings.api_version}/openapi.json",
    lifespan=lifespan,
)


# ==================== MIDDLEWARE ====================

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
    max_age=3600,
)


# Request logging middleware
@app.middleware("http")
async def log_requests(request: Request, call_next):
    """Log all requests with timing"""
    start_time = time.time()

    response = await call_next(request)

    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)

    if settings.debug:
        print(f"{request.method} {request.url.path} - {response.status_code} - {process_time:.3f}s")

    return response


# ==================== EXCEPTION HANDLERS ====================

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """Handle validation errors"""
    errors = []
    for error in exc.errors():
        errors.append({
            "field": ".".join(str(loc) for loc in error["loc"]),
            "message": error["msg"],
            "type": error["type"],
        })

    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "success": False,
            "error": "Validation error",
            "details": errors,
        },
    )


@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    """Handle general exceptions"""
    if settings.debug:
        import traceback
        traceback.print_exc()

    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "success": False,
            "error": "Internal server error",
            "detail": str(exc) if settings.debug else "An unexpected error occurred",
        },
    )


# ==================== ROOT ENDPOINTS ====================

@app.get("/", tags=["Root"])
async def root():
    """API root endpoint"""
    return {
        "message": "Welcome to Swim360 API",
        "version": API_VERSION_INFO,
        "docs": f"/api/{settings.api_version}/docs",
        "health": "/health",
    }


@app.get("/health", tags=["Health"])
async def health_check():
    """Health check endpoint"""
    db_healthy = await check_db_connection()

    return {
        "status": "healthy" if db_healthy else "unhealthy",
        "version": API_VERSION_INFO,
        "environment": settings.environment,
        "database": "connected" if db_healthy else "disconnected",
    }


# ==================== API ROUTES ====================

API_PREFIX = f"/api/{settings.api_version}"

# Include routers
app.include_router(auth.router, prefix=API_PREFIX)
app.include_router(users.router, prefix=API_PREFIX)
app.include_router(programs.router, prefix=API_PREFIX)
app.include_router(services.router, prefix=API_PREFIX)
app.include_router(products.router, prefix=API_PREFIX)
app.include_router(bookings.router, prefix=API_PREFIX)
app.include_router(orders.router, prefix=API_PREFIX)
app.include_router(events.router, prefix=API_PREFIX)
app.include_router(chat.router, prefix=API_PREFIX)
app.include_router(reviews.router, prefix=API_PREFIX)
app.include_router(academies.router, prefix=API_PREFIX)
app.include_router(clinics.router, prefix=API_PREFIX)
app.include_router(stores.router, prefix=API_PREFIX)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "app.main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.debug,
        log_level=settings.log_level.lower(),
    )
