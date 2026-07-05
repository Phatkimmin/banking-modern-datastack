{{ config(materialized='view') }}

SELECT
    v:ID::string                 AS TRANSACTION_ID,
    v:ACCOUNT_ID::string         AS ACCOUNT_ID,
    v:AMOUNT::float              AS AMOUNT,
    v:TXN_TYPE::string           AS TRANSACTION_TYPE,
    v:RELATED_ACCOUNT_ID::string AS RELATED_ACCOUNT_ID,
    v:STATUS::string             AS STATUS,
    v:CREATED_AT::timestamp      AS TRANSACTION_TIME,
    CURRENT_TIMESTAMP            AS LOAD_TIMESTAMP
FROM {{ source('raw', 'transactions') }}