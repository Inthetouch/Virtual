import time
import os
import psycopg2

db_host = os.environ.get('DB_HOST', 'database')
db_port = os.environ.get('DB_PORT', '5432')
db_user = os.environ.get('POSTGRES_USER', 'admin')
db_password = os.environ.get('POSTGRES_PASSWORD', 'admin')
db_name = os.environ.get('POSTGRES_DB', 'taskidb')

retries = 0
max_retries = 10
delay = 5

while retries < max_retries:
    try:
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            user=db_user,
            password=db_password,
            dbname=db_name
        )
        conn.close()
        print("Database is ready!")
        exit(0)
    except psycopg2.OperationalError as e:
        print(f"Database is not ready yet: {e}")
        retries += 1
        time.sleep(delay)

print(f"Failed to connect to database after {max_retries} retries.")
exit(1)