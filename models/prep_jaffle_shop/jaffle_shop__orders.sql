{{ config(materialized='table', alias='orders') }}

with
source as (
    select * from {{ ref('raw_orders') }}
),

transformed as (
    select
        {{ dbt.cast('id', dbt.type_int()) }} as id,
        {{ dbt.cast('user_id', dbt.type_int()) }} as user_id,
        {{ dbt.cast('order_date', 'date') }} as order_date,
        status,
        {{ dbt.dateadd(
            datepart='hour',
            interval=-16,
            from_date_or_timestamp=dbt.current_timestamp())
        }} as _etl_loaded_at
    from source
)

select * from transformed
