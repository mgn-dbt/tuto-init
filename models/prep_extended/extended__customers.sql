{{ config(materialized='table', alias='customers') }}

with
source as (
    select * from {{ ref('customers') }}
)

select * from source
