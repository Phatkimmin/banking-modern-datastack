import json
import requests
import os
# pyrefly: ignore [missing-import]
from dotenv import load_dotenv

load_dotenv()

#------------
# Build connector JSON in memory
#------------
connector_config = {
    "name": "postgres-connector",
    "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.hostname": os.getenv('POSTGRES_HOST'),
        "database.port": os.getenv('POSTGRES_PORT'),
        "database.user": os.getenv('POSTGRES_USER'),
        "database.password": os.getenv('POSTGRES_PASSWORD'),
        "database.dbname": os.getenv('POSTGRES_DB'),
        "topic.prefix": "banking_server",
        "table.include.list": "public.CUSTOMERS, public.ACCOUNTS, public.TRANSACTIONS",
        "plugin.name": "pgoutput",
        "slot.name": "banking_slot",
        "publication.autocreate.mode":"filtered",
        "tombstones.on.delete": "false",
        "decimal.handling.mode": "double", 
    },
}

#-------------------
# Send request to Debezium Connect
#-------------------

url = "http://localhost:8083/connectors"
headers = {"Content-Type": "application/json"}

respone = requests.post(url, headers=headers, data = json.dumps(connector_config))

#---------------
# Debug/Output
#---------------

if respone.status_code == 201:
    print("Connector created successfully!")
elif respone.status_code == 409:
    print("Connector already exists")
else:
    print(f"Failed to create connector ({respone.status_code}): {respone.text}")
