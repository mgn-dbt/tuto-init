{{ config(materialized='table', alias='payments') }}

with
source as (
    select * from {{ ref('raw_payments') }}
),

transformed as (
    select
        {{ dbt.cast('id', dbt.type_int()) }} as id,
        {{ dbt.cast('orderid', dbt.type_int()) }} as orderid,
        paymentmethod,
        status,
        {{ dbt.cast('amount', dbt.type_int()) }} as amount,
        {{ dbt.cast('created', 'date') }} as created,
        {{ dbt.dateadd(
            datepart='hour',
            interval=-4,
            from_date_or_timestamp=dbt.current_timestamp())
        }} as _batched_at
    from source
)

select * from transformed
