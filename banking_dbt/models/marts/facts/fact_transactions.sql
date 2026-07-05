{{ config(materialized='incremental', unique_key = 'transaction_id') }}

WITH latest_transactions AS (
    SELECT *
    FROM {{ ref('stg_transactions') }}
    {% if is_incremental() %}
    WHERE TRANSACTION_TIME >= (SELECT COALESCE(MAX(TRANSACTION_TIME), '1900-01-01'::timestamp) FROM {{ this }})
    {% endif %}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY TRANSACTION_ID ORDER BY TRANSACTION_TIME DESC) = 1
)

SELECT 
    t.TRANSACTION_ID,
    t.ACCOUNT_ID,
    a.CUSTOMER_ID,
    t.AMOUNT,
    t.RELATED_ACCOUNT_ID,
    t.STATUS,
    t.TRANSACTION_TYPE,
    t.TRANSACTION_TIME,
    CURRENT_TIMESTAMP AS LOAD_TIMESTAMP
FROM latest_transactions t
LEFT JOIN {{ ref('stg_accounts') }} a
ON t.ACCOUNT_ID = a.ACCOUNT_ID