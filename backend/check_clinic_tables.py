"""
Check clinic tables structure
"""
import psycopg2
from urllib.parse import unquote
from app.core.config import settings

def check_clinic_tables():
    """Check clinic tables"""
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

    clinic_tables = ['clinic_branches', 'clinic_services', 'clinic_bookings', 'clinic_details']

    for table in clinic_tables:
        print(f"\n{'='*80}")
        print(f"Table: {table}")
        print(f"{'='*80}")

        cursor.execute("""
            SELECT column_name, data_type, is_nullable, column_default
            FROM information_schema.columns
            WHERE table_name = %s
            ORDER BY ordinal_position
        """, (table,))

        columns = cursor.fetchall()
        if columns:
            print(f"\nColumns ({len(columns)}):")
            for col_name, col_type, nullable, default in columns:
                null_str = "NULL" if nullable == "YES" else "NOT NULL"
                default_str = f" DEFAULT {default}" if default else ""
                print(f"  {col_name:<30} {col_type:<25} {null_str}{default_str}")
        else:
            print("❌ Table does not exist")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    check_clinic_tables()
