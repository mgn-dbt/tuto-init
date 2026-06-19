with
source as (
    select * from {{ ref('stores') }}
)

select * from source
