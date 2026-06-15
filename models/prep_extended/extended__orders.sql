{{ config(materialized='table', alias='orders') }}

with
source as (
    select * from {{ ref('orders') }}
)

select * from source
