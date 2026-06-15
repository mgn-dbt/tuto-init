{{ config(materialized='table', alias='stores') }}

with
source as (
    select * from {{ ref('stores') }}
)

select * from source
