{{ config(materialized='view') }}

with ranked as (
    select
        v:ID::string            as CUSTOMER_ID,
        v:FIRST_NAME::string    as FIRST_NAME,
        v:LAST_NAME::string     as LAST_NAME,
        v:EMAIL::string         as EMAIL,
        v:CREATED_AT::timestamp as CREATED_AT,
        current_timestamp       as LOAD_TIMESTAMP,
        row_number() over (
            partition by v:ID::string
            order by coalesce(v:_INGESTED_AT::number, 0) desc, v:CREATED_AT desc
        ) as rn
    from {{ source('raw', 'customers') }}
)

select
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    CREATED_AT,
    LOAD_TIMESTAMP
from ranked
where rn = 1