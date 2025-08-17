from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from supabase import create_client, Client
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize FastAPI
app = FastAPI(
    title="Swim360 API",
    description="Backend API for Swim360 - Egypt's Wellness Platform",
    version="1.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Supabase
supabase: Client = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_SERVICE_KEY")
)

# Import routers
from app.api.auth import signup, login, verify_email
from app.api.users import profile, roles
from app.api.listings import services
from app.api.marketplace import products

# Include routers
app.include_router(signup.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(login.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(profile.router, prefix="/api/v1/users", tags=["users"])
app.include_router(services.router, prefix="/api/v1/listings", tags=["listings"])
app.include_router(products.router, prefix="/api/v1/marketplace", tags=["marketplace"])

@app.get("/")
async def root():
    return {"message": "Swim360 API is running!"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "swim360-api"}