{{ config(materialized='table', alias='supplies') }}

with
source as (
    select * from {{ ref('supplies') }}
)

select * from source
