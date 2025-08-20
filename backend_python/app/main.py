from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from app.core.config import settings
from app.core.database import Database
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO if not settings.debug else logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="Swim360 API",
    description="Backend API for Swim360 - Egypt's Premier Wellness Platform",
    version=settings.app_version,
    docs_url="/api/docs",
    redoc_url="/api/redoc"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:8080"],  # Add your Flutter web URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Import and register routers
from app.api.auth import signup, login, verify_email

app.include_router(signup.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(login.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(verify_email.router, prefix="/api/v1/auth", tags=["Authentication"])

# Root endpoint
@app.get("/")
async def root():
    return {
        "name": settings.app_name,
        "version": settings.app_version,
        "status": "running",
        "documentation": "/api/docs"
    }

# Health check endpoint
@app.get("/health")
async def health_check():
    try:
        # Check database connection
        db = Database.get_client()
        # Simple query to test connection
        result = db.table("profiles").select("count").limit(1).execute()
        
        return {
            "status": "healthy",
            "service": "swim360-api",
            "database": "connected",
            "version": settings.app_version
        }
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return JSONResponse(
            status_code=503,
            content={
                "status": "unhealthy",
                "service": "swim360-api",
                "database": "disconnected",
                "error": str(e)
            }
        )

# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "message": "An unexpected error occurred",
            "detail": str(exc) if settings.debug else None
        }
    )

# Startup event
@app.on_event("startup")
async def startup_event():
    logger.info(f"{settings.app_name} v{settings.app_version} starting up...")
    
    # Initialize database connection
    try:
        db = Database.get_client()
        logger.info("Database connection established")
    except Exception as e:
        logger.error(f"Failed to connect to database: {e}")
        raise

# Shutdown event
@app.on_event("shutdown")
async def shutdown_event():
    logger.info(f"{settings.app_name} shutting down...")
    # Cleanup if needed