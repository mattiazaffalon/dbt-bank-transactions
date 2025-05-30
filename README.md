# dbt-bank-transactions

## Gcp project

Gcp project:
`accounts-statements-prod`

Dataset:
`account_statements`

## Operativita
Export file from Internet Banking and call it "export-yyyyMMdd.tsv", dove la data indica il giorno dell'export.

Collocare il file in `gs://bank-exports-prod/`

Eseguire la sequenza di comandi descritti in [nella sezione running-dbt-models](./dbt_bank_transactions/README.md#running-the-models),