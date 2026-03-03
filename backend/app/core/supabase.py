"""
Supabase client initialization and utilities
"""
from supabase import create_client, Client
from gotrue import SyncGoTrueClient
from app.core.config import settings


# Initialize Supabase client
supabase: Client = create_client(
    settings.supabase_url,
    settings.supabase_service_key  # Use service key for admin operations
)

# Auth client
auth_client = supabase.auth


def get_supabase_client() -> Client:
    """Get Supabase client instance"""
    return supabase


def get_storage_client():
    """Get Supabase storage client"""
    return supabase.storage


async def upload_file(bucket: str, path: str, file_data: bytes, content_type: str = None) -> str:
    """
    Upload file to Supabase Storage

    Args:
        bucket: Storage bucket name
        path: File path within bucket
        file_data: File bytes
        content_type: MIME type

    Returns:
        Public URL of uploaded file
    """
    try:
        # Upload file
        result = supabase.storage.from_(bucket).upload(
            path,
            file_data,
            file_options={"content-type": content_type} if content_type else None
        )

        # Get public URL
        public_url = supabase.storage.from_(bucket).get_public_url(path)

        return public_url
    except Exception as e:
        raise Exception(f"Failed to upload file: {str(e)}")


async def delete_file(bucket: str, path: str) -> bool:
    """
    Delete file from Supabase Storage

    Args:
        bucket: Storage bucket name
        path: File path within bucket

    Returns:
        True if successful
    """
    try:
        supabase.storage.from_(bucket).remove([path])
        return True
    except Exception as e:
        raise Exception(f"Failed to delete file: {str(e)}")


async def create_bucket_if_not_exists(bucket_name: str, public: bool = True):
    """
    Create storage bucket if it doesn't exist

    Args:
        bucket_name: Name of bucket to create
        public: Whether bucket should be publicly accessible
    """
    try:
        # Try to get bucket
        buckets = supabase.storage.list_buckets()
        bucket_names = [b.name for b in buckets]

        if bucket_name not in bucket_names:
            # Create bucket
            supabase.storage.create_bucket(
                bucket_name,
                options={"public": public}
            )
            print(f"✅ Created storage bucket: {bucket_name}")
        else:
            print(f"✓ Storage bucket already exists: {bucket_name}")
    except Exception as e:
        print(f"❌ Failed to create bucket {bucket_name}: {str(e)}")


async def initialize_storage_buckets():
    """Initialize all required storage buckets"""
    buckets = [
        "profile-photos",
        "product-photos",
        "event-photos",
        "used-item-photos",
        "review-photos",
        "message-attachments",
        "branch-photos",
    ]

    for bucket in buckets:
        await create_bucket_if_not_exists(bucket, public=True)
