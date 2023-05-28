provider "google" {
  credentials = file("${var.credentials_file}")
  project     = "account-statements-prod"
  region      = "europe-west6"
}

# data "google_billing_account" "acct" {
#   billing_account = "My Billing Account"
#   open         = true
# }

# resource "google_project" "account-statements-prod" {
#   name            = "account-statements-prod"
#   project_id      = "account-statements-prod"
#   billing_account = data.google_billing_account.acct.id
# }

resource "google_project_service" "project" {
  service = "bigquery.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "account_statements"
  friendly_name               = "Account Statements"
  description                 = "bank transactions imported through dbt"
  location                    = "europe-west6"

  labels = {
    env = "prod"
  }
}

resource "google_storage_bucket" "bank-exports" {
  name          = "bank-exports-prod"
  location      = "europe-west6"
  force_destroy = true

  uniform_bucket_level_access = true
}