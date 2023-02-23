{% macro create_external_table(schema_name, table_name, source_uri) %}
  {{ config(materialized='table') }}

  CREATE OR REPLACE EXTERNAL TABLE {{schema_name}}.{{ table_name }} (
    data_contabile STRING,
    data_valuta STRING,
    importo STRING,
    descrizione STRING
  ) OPTIONS (
    format = 'CSV',
    field_delimiter = '\t',
    uris = ['{{source_uri}}'],
    skip_leading_rows = 1
  );
{% endmacro %}