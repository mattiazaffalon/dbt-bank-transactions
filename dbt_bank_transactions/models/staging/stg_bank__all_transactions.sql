{{ config(materialized='view') }}

with 

raw as (
    SELECT e.*, _file_name as report_file_name FROM dbt_bank_transactions.exports e
),

parsed as (
    select 
        parse_date('%d/%m/%Y', data_contabile) as accounting_date,
        
        parse_date('%d/%m/%Y', data_valuta) as value_date,
    
        CAST(REPLACE(REPLACE(importo, '.', ''), ',', '.') AS NUMERIC) AS value,
    
        descrizione as description,
        
        parse_date('%Y%m%d', regexp_extract(report_file_name, r'\d{8}')) as report_date
    from raw
)

select * from parsed
