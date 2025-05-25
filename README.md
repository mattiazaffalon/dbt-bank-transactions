# dbt-bank-transactions

## Gcp project

Gcp project:
`accounts-statements-prod`

Dataset:
`account_statements`

## Operativita
Export file from Internet Banking and call it "export-yyyyMMdd.tsv", dove la data indica il giorno dell'export.

Collocare il file in `gs://bank-exports-prod/`

Eseguire il comando:
```bash
dbt seed && dbt run
```
