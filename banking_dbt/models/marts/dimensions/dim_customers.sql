{{ config(materialized='table') }}

WITH lastest AS (
    SELECT
        CUSTOMER_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        CREATED_AT,
        DBT_VALID_FROM AS EFFECTIVE_FROM,
        DBT_VALID_TO   AS EFFECTIVE_TO,
        CASE 
            WHEN DBT_VALID_TO IS NULL THEN TRUE
        ELSE FALSE 
        END AS IS_CURRENT
    FROM {{ ref('customers_snapshot') }}
)
SELECT * FROM lastest