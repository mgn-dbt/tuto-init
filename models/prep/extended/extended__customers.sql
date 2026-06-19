with
source as (
    select * from {{ ref('customers') }}
)

select * from source
