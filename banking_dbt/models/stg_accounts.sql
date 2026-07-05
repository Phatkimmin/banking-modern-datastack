{{ config(materialized='view') }}

with ranked as (
    select
        v:ID::string            as ACCOUNT_ID,
        v:CUSTOMER_ID::string   as CUSTOMER_ID,
        v:ACCOUNT_TYPE::string  as ACCOUNT_TYPE,
        v:BALANCE::float        as BALANCE,
        v:CURRENCY::string      as CURRENCY,
        v:CREATED_AT::timestamp as CREATED_AT,
        current_timestamp       as LOAD_TIMESTAMP,
        row_number() over (
            partition by v:ID::string
            order by v:CREATED_AT desc
        ) as rn
    from {{ source('raw', 'accounts') }}
)

select
    ACCOUNT_ID,
    CUSTOMER_ID,
    ACCOUNT_TYPE,
    BALANCE,
    CURRENCY,
    CREATED_AT,
    LOAD_TIMESTAMP
from ranked
where rn = 1