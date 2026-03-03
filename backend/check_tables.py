"""
Check what tables and columns exist
"""
import psycopg2
from urllib.parse import unquote
from app.core.config import settings

def check_tables():
    """Check existing tables and columns"""
    # Get database URL
    db_url = str(settings.database_url)
    url_parts = db_url.replace('postgresql://', '').replace('postgres://', '')
    auth_parts, host_parts = url_parts.split('@')
    user, password = auth_parts.split(':', 1)
    password = unquote(password)
    host_db = host_parts.split('/')
    host, port = host_db[0].split(':')
    database = host_db[1]

    conn = psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password
    )
    cursor = conn.cursor()

    # Check specific tables that had index errors
    problem_tables = ['events', 'used_items', 'reviews']

    for table in problem_tables:
        print(f"\n{'='*60}")
        print(f"Table: {table}")
        print(f"{'='*60}")

        # Check if table exists
        cursor.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables
                WHERE table_name = %s
            )
        """, (table,))

        exists = cursor.fetchone()[0]

        if exists:
            print("✅ Table exists")

            # Get columns
            cursor.execute("""
                SELECT column_name, data_type
                FROM information_schema.columns
                WHERE table_name = %s
                ORDER BY ordinal_position
            """, (table,))

            columns = cursor.fetchall()
            print(f"\nColumns ({len(columns)}):")
            for col_name, col_type in columns:
                print(f"  - {col_name}: {col_type}")
        else:
            print("❌ Table does not exist")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    check_tables()
