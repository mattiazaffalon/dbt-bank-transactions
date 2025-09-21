{{ config(materialized='view') }}

select *
from {{ ref('transactions') }}
where value_monthday <= extract(day from current_date())  -- Only up to current day of month
