provider "google" {
  credentials = file("${var.credentials_file}")
  project     = "dbt-bank-transactions-dev"
  region      = "europe-west6"
}

data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
}

resource "google_project" "dbt-bank-transactions-dev" {
  name            = "dbt-bank-transactions-dev"
  project_id      = "dbt-bank-transactions-dev"
  billing_account = data.google_billing_account.acct.id
}

resource "google_project_service" "project" {
  service = "bigquery.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "dbt_bank_transactions"
  friendly_name               = "dbt_bank_transactions"
  description                 = "Dev dataset"
  location                    = "europe-west6"
  default_table_expiration_ms = 3600000
  default_partition_expiration_ms = 5184000000

  labels = {
    env = "dev"
  }
}

resource "google_storage_bucket" "bank-exports" {
  name          = "bank-exports-dev"
  location      = "europe-west6"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_service_account" "dev-local" {
  account_id   = "dev-local"
  display_name = "SA to be used to launch pipeline from the local environment"
}

resource "google_project_iam_member" "bigquery_editor" {
  project = "${google_project.dbt-bank-transactions-dev.id}"
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.dev-local.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = "${google_project.dbt-bank-transactions-dev.id}"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.dev-local.email}"
}

