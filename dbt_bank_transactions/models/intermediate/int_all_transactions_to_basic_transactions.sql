{{ config(materialized='view') }}

with 

all_transactions as (

   select * from {{ ref('stg_bank__all_transactions') }}

),

value_date_to_consider as (

    select 
        value_date,
        max(report_date) as report_date
    from all_transactions
    group by 1

),

transactions_to_consider as (
    select 
        t.*,
    from all_transactions t
    inner join value_date_to_consider v
    on t.value_date = v.value_date
    and t.report_date = v.report_date

)

select * from transactions_to_consider 