import psycopg2
conn = psycopg2.connect(host='localhost', port=5432, dbname='banking', user='postgres', password='postgres')
cur = conn.cursor()
cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public'")
print([r[0] for r in cur.fetchall()])
