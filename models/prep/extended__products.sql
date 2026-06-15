with
source as (
    select * from {{ ref('products') }}
)

select * from source
