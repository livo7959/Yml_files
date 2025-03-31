include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//databricks_account"
}

generate "provider_databricks" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
    required_providers {
      databricks = {
        source  = "databricks/databricks"
        version = "=1.66.0"
      }
    }
  }
  provider "databricks" {
    alias      = "accounts"
    host       = "${get_env("DATABRICKS_HOST")}"
    account_id = "${get_env("DATABRICKS_ACCOUNT_ID")}"
  }
EOF
}

inputs = {
  location = "eastus"
}
