{{ config(materialized='view') }}

with 

all_transactions as (

   select * from {{ ref('stg_bank__all_transactions') }}

),

ranked_transactions as (
    select t.*,
        rank() over (partition by accounting_date, value_date, value, description order by report_date desc) as report
    from all_transactions t
)

select * from ranked_transactions where report = 1