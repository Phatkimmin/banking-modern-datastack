{{ config(materialized='table') }}

WITH lastest AS (
    SELECT
        ACCOUNT_ID,
        CUSTOMER_ID,
        ACCOUNT_TYPE,
        BALANCE,
        CURRENCY,
        CREATED_AT,
        DBT_VALID_FROM AS EFFECTIVE_FROM,
        DBT_VALID_TO   AS EFFECTIVE_TO,
        CASE 
            WHEN DBT_VALID_TO IS NULL THEN TRUE
        ELSE FALSE 
        END AS IS_CURRENT
    FROM {{ ref('accounts_snapshot') }}
)
SELECT * FROM lastest