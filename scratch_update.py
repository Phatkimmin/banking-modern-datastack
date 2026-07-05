import psycopg2
import time

conn = psycopg2.connect(host='localhost', port=5432, dbname='banking', user='postgres', password='postgres')
cur = conn.cursor()

# Update the email for ID = 3
new_email = f"michelle_{int(time.time())}@example.com"
cur.execute('UPDATE "CUSTOMERS" SET "EMAIL" = %s WHERE "ID" = 3', (new_email,))
conn.commit()

print(f"✅ Updated Customer ID 3 with new email: {new_email}")
cur.close()
conn.close()
