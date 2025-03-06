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

# Disable foreign key checks temporarily for the session
mysql_conn.execute(text("SET FOREIGN_KEY_CHECKS = 0;"))

# Get the list of tables from SQLite
sqlite_cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
tables = sqlite_cursor.fetchall()

# Process each table
for table in tables:
    table_name = table[0]
    
    # Skip the 'user' table and other predefined tables
    if table_name in ['user', 'car','zone', '','alembic_version','saved_routes','Belgium_registrations','Bulgaria_registrations','Denmark_registrations','France_registrations','Germany_registrations','Greece_registrations','Netherlands_registrations','Poland_registrations','Portugal_registrations','Spain_registrations','UnitedKingdom_registrations', 'Italy_access','Blocked_Users', 'Requests_Log']:

        print(f"Skipping table '{table_name}' as it has already been imported.")
        continue

    # Get columns from the SQLite table
    sqlite_cursor.execute(f"PRAGMA table_info({table_name});")
    columns = sqlite_cursor.fetchall()
    column_names = [col[1] for col in columns]

    # Fetch data from the SQLite table
    sqlite_cursor.execute(f"SELECT * FROM {table_name}")
    rows = sqlite_cursor.fetchall()

    # Convert data to DataFrame
    df = pd.DataFrame(rows, columns=column_names)

    # If the table is 'zone_temporary_data', we need to check for valid 'zone_id'
    # if table_name == 'zone_temporary_data':
    #     # Get the list of valid 'zone_id' values from the 'zone' table in MySQL
    #     valid_zone_ids = pd.read_sql("SELECT id FROM zone", mysql_conn)
    #     valid_zone_ids_set = set(valid_zone_ids['id'])

    #     # Filter out rows with invalid 'zone_id' values
    #     df = df[df['zone_id'].isin(valid_zone_ids_set) | df['zone_id'].isnull()]

    # Remove the 'id' column from the DataFrame (if present)
    if 'id' in df.columns:
        df = df.drop(columns=['id'])

    # Insert the data into MySQL
    df.to_sql(table_name, mysql_conn, if_exists='append', index=False)

    print(f"Data from table {table_name} has been migrated to MySQL.")

# Re-enable foreign key checks after the migration is done
mysql_conn.execute(text("SET FOREIGN_KEY_CHECKS = 1;"))

# Close SQLite and MySQL connections
sqlite_conn.close()
mysql_conn.close()
