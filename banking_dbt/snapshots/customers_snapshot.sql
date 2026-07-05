{% snapshot customers_snapshot %}
{{
    config(
        target_schema = 'ANALYTICS',
        unique_key='CUSTOMER_ID',
        strategy='check',
        check_cols = ['FIRST_NAME','LAST_NAME','EMAIL']
    )
}}
SELECT * FROM {{ ref('stg_customers')}}
{% endsnapshot %}