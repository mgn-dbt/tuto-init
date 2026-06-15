with
source as (
    select * from {{ ref('items') }}
)

select * from source
