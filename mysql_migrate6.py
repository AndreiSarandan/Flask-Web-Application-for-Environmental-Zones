import sqlite3
from sqlalchemy import create_engine, text
import pandas as pd

# Path to your SQLite database
sqlite_db_path = r"D:\Licenta\instance\users_databse.db"

# MySQL connection details
mysql_engine = create_engine('mysql://root:andrei@localhost:3306/flaskdb')

# Connect to SQLite
sqlite_conn = sqlite3.connect(sqlite_db_path)
sqlite_cursor = sqlite_conn.cursor()

# Connect to MySQL
mysql_conn = mysql_engine.connect()


# Only process `zone_temporary_data` table
table_name = 'zone_temporary_data'
print(f"Processing table: {table_name}")

# Fetch column names
sqlite_cursor.execute(f"PRAGMA table_info({table_name});")
columns = sqlite_cursor.fetchall()
column_names = [col[1] for col in columns]

# Fetch all data
sqlite_cursor.execute(f"SELECT * FROM {table_name}")
rows = sqlite_cursor.fetchall()

# Ensure data is fetched
if not rows:
    print(f"ERROR: No data retrieved from {table_name}. Stopping execution.")
    exit(1)

# Convert to DataFrame
df = pd.DataFrame(rows, columns=column_names)

# Print DataFrame preview before inserting
print(f"Sample data from {table_name}:\n{df.head()}")

# Remove 'id' column if present (MySQL auto-increment workaround)
if 'id' in df.columns:
    df = df.drop(columns=['id'])

# Force insert into MySQL
try:
    # Use 'append' instead of 'replace' to avoid overwriting the table
    df.to_sql(table_name, mysql_conn, if_exists='append', index=False)

    # Explicit commit to ensure the changes are saved
    mysql_conn.execute("COMMIT;")
    
    print(f"SUCCESS: Data from {table_name} migrated to MySQL.")
except Exception as e:
    print(f"ERROR: Failed to insert data into MySQL: {e}")

# Re-enable foreign key checks

# Close connections
sqlite_conn.close()
mysql_conn.close()
