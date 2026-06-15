with
source as (
    select * from {{ ref('supplies') }}
)

select * from source
