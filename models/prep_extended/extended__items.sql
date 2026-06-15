{{ config(materialized='table', alias='items') }}

with
source as (
    select * from {{ ref('items') }}
)

select * from source
