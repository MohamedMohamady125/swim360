"""
List all tables in the database
"""
import psycopg2
from urllib.parse import unquote
from app.core.config import settings

def list_tables():
    """List all tables"""
    db_url = str(settings.database_url)
    url_parts = db_url.replace('postgresql://', '').replace('postgres://', '')
    auth_parts, host_parts = url_parts.split('@')
    user, password = auth_parts.split(':', 1)
    password = unquote(password)
    host_db = host_parts.split('/')
    host, port = host_db[0].split(':')
    database = host_db[1]

    conn = psycopg2.connect(host=host, port=port, database=database, user=user, password=password)
    cursor = conn.cursor()

    # Get all tables in the public schema
    cursor.execute("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
        ORDER BY table_name
    """)

    tables = cursor.fetchall()
    print(f"\n{'='*60}")
    print(f"All tables in database ({len(tables)}):")
    print(f"{'='*60}\n")

    for (table_name,) in tables:
        print(f"  - {table_name}")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    list_tables()
