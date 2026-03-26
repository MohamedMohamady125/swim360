"""
Database connection and session management
"""
from typing import AsyncGenerator
from sqlalchemy import create_engine, MetaData, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy.pool import NullPool

from app.core.config import settings


# Convert postgres:// to postgresql:// for SQLAlchemy
db_url = str(settings.database_url)
# Handle both postgres:// and postgresql:// formats
if db_url.startswith("postgres://"):
    DATABASE_URL = db_url.replace("postgres://", "postgresql://")
    ASYNC_DATABASE_URL = db_url.replace("postgres://", "postgresql+asyncpg://")
elif db_url.startswith("postgresql://"):
    DATABASE_URL = db_url
    ASYNC_DATABASE_URL = db_url.replace("postgresql://", "postgresql+asyncpg://")
else:
    DATABASE_URL = db_url
    ASYNC_DATABASE_URL = db_url

# SQLAlchemy
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    echo=settings.debug,
)

async_engine = create_async_engine(
    ASYNC_DATABASE_URL,
    poolclass=NullPool,
    echo=settings.debug,
)

# Session factories
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
AsyncSessionLocal = async_sessionmaker(
    async_engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)

class DatabaseWrapper:
    """Drop-in replacement for the 'databases' library API using SQLAlchemy async engine."""

    def __init__(self, engine):
        self._engine = engine

    async def connect(self):
        pass

    async def disconnect(self):
        await self._engine.dispose()

    async def fetch_one(self, query, values=None):
        async with self._engine.begin() as conn:
            result = await conn.execute(text(query), values or {})
            row = result.mappings().first()
            return row

    async def fetch_all(self, query, values=None):
        async with self._engine.begin() as conn:
            result = await conn.execute(text(query), values or {})
            return result.mappings().all()

    async def execute(self, query, values=None):
        async with self._engine.begin() as conn:
            result = await conn.execute(text(query), values or {})
            return result


database = DatabaseWrapper(async_engine)

# Metadata for reflection
metadata = MetaData()

# Base class for models
Base = declarative_base()


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """
    Dependency function to get database session

    Usage in endpoints:
        @app.get("/items")
        async def get_items(db: AsyncSession = Depends(get_db)):
            ...
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()


async def connect_db():
    """Connect to database on startup"""
    async with async_engine.begin() as conn:
        await conn.execute(text("SELECT 1"))
    print("✅ Database connected")


async def disconnect_db():
    """Disconnect from database on shutdown"""
    await async_engine.dispose()
    print("❌ Database disconnected")


# Health check
async def check_db_connection() -> bool:
    """Check if database connection is alive"""
    try:
        async with async_engine.connect() as conn:
            await conn.execute(text("SELECT 1"))
        return True
    except Exception as e:
        print(f"Database connection error: {e}")
        return False
