{% snapshot accounts_snapshot %}
{{
    config(
        target_schema = 'ANALYTICS',
        unique_key='ACCOUNT_ID',
        strategy='check',
        check_cols = ['customer_id','account_type','balance']
    )
}}
SELECT * FROM {{ ref('stg_accounts')}}
{% endsnapshot %}