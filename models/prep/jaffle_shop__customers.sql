with
source as (
    select * from {{ ref('raw_customers') }}
),

transformed as (
    select
        {{ dbt.cast('id', dbt.type_int()) }} as id,
        first_name,
        last_name
    from source
)

select * from transformed
