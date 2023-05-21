{{ config(materialized='table') }}

with 

basic_transactions as (

   select b.*, row_number() over () as id from {{ ref('int_all_transactions_to_basic_transactions') }} b

),

categories as (

  select pattern, category from {{ ref('transaction_categories') }}
)

select
  accounting_date,
  value_date,
  value,
  description,
  if (value > 0, 'I', 'O') as direction,
  abs(value) as amount,
  case 
    when category is null then 'Senza categoria'
    else category
  end as category,
  case
    when abs(value) < 2 then '1-xxs'
    when abs(value) < 5 then '2-xs'
    when abs(value) < 20 then '3-s'
    when abs(value) < 80 then '4-m'
    when abs(value) < 250 then '5-l'
    when abs(value) < 2500 then '6-xl'
    when abs(value) < 10000 then '7-xxl'
    else '8-outlier'
  end as size,
  extract(year from accounting_date) as accounting_year,
  extract(month from accounting_date) as accounting_month,
  extract(day from accounting_date) as accounting_monthday,
  case extract(DAYOFWEEK from accounting_date)
    when 1 then 'domenica'
    when 2 then 'lunedi'
    when 3 then 'martedi'
    when 4 then 'mercoledi'
    when 5 then 'giovedi'
    when 6 then 'venerdi'
    when 7 then 'sabato' 
  end as accounting_dayofweek,
  concat(
    cast(extract(year from accounting_date) as string),
    '-',
    lpad(cast(extract(month from accounting_date) as string), 2, '0')
  ) as accounting_month_id,
  extract(year from value_date) as value_year,
  extract(month from value_date) as value_month,
  extract(day from value_date) as value_monthday,
  case extract(DAYOFWEEK from value_date)
    when 1 then 'domenica'
    when 2 then 'lunedi'
    when 3 then 'martedi'
    when 4 then 'mercoledi'
    when 5 then 'giovedi'
    when 6 then 'venerdi'
    when 7 then 'sabato' 
  end as value_dayofweek,
  concat(
    cast(extract(year from value_date) as string),
    '-',
    lpad(cast(extract(month from value_date) as string), 2, '0')
  ) as value_month_id,
from basic_transactions t left join categories c on REGEXP_CONTAINS(lower(t.description), c.pattern)
qualify row_number() over (partition by id) = 1