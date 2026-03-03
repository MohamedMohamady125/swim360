"""
Script to run the database schema initialization
"""
import psycopg2
from urllib.parse import unquote
from app.core.config import settings

def run_schema():
    """Run the init_database.sql file"""
    print("Connecting to database...")

    # Get database URL and convert to psycopg2 format
    db_url = str(settings.database_url)

    # Parse the URL to extract connection details
    # Format: postgresql://user:password@host:port/database
    url_parts = db_url.replace('postgresql://', '').replace('postgres://', '')
    auth_parts, host_parts = url_parts.split('@')
    user, password = auth_parts.split(':', 1)  # Split only on first colon
    password = unquote(password)  # Decode URL-encoded password
    host_db = host_parts.split('/')
    host, port = host_db[0].split(':')
    database = host_db[1]

    print(f"Connecting to {host}:{port} as user {user}...")

    conn = psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password
    )
    conn.autocommit = True
    cursor = conn.cursor()

    print("Reading SQL file...")
    with open('init_database.sql', 'r') as f:
        sql_content = f.read()

    print("Executing SQL file...")

    # Try to execute the entire file at once
    try:
        cursor.execute(sql_content)
        print("✅ All statements executed successfully!")
        success_count = 1
        skip_count = 0
        error_count = 0
    except Exception as e:
        print(f"Batch execution failed, trying statement by statement: {e}\n")

        # Split by statements more carefully
        statements = []
        buffer = ""
        in_dollar_quote = False

        for line in sql_content.split('\n'):
            stripped = line.strip()

            # Skip comment lines
            if stripped.startswith('--'):
                continue

            # Track $$ dollar quotes (used in functions)
            if '$$' in line:
                in_dollar_quote = not in_dollar_quote

            buffer += line + '\n'

            # End of statement (semicolon outside dollar quotes)
            if ';' in stripped and not in_dollar_quote:
                statements.append(buffer.strip())
                buffer = ""

        # Execute each statement
        success_count = 0
        skip_count = 0
        error_count = 0

        for i, stmt in enumerate(statements, 1):
            if stmt and not stmt.startswith('--'):
                try:
                    cursor.execute(stmt)
                    success_count += 1
                    # Only print every 5th success to reduce noise
                    if i % 5 == 0 or i == len(statements):
                        print(f"✅ Executed {i}/{len(statements)} statements...")
                except Exception as stmt_error:
                    error_msg = str(stmt_error)
                    # Ignore "already exists" errors
                    if 'already exists' in error_msg.lower():
                        skip_count += 1
                        print(f"⚠️  Statement {i}: Already exists, skipping")
                    else:
                        error_count += 1
                        # Show first 200 chars of failed statement
                        stmt_preview = stmt[:200].replace('\n', ' ')
                        print(f"❌ Statement {i} failed: {error_msg}")
                        print(f"   Statement: {stmt_preview}...")

    cursor.close()
    conn.close()
    print("\n" + "="*60)
    print(f"✅ Success: {success_count} statements executed")
    print(f"⚠️  Skipped: {skip_count} statements (already exist)")
    print(f"❌ Errors: {error_count} statements failed")
    print("="*60)
    print("Disconnected from database")

if __name__ == "__main__":
    run_schema()
