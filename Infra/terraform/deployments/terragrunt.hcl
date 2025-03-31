locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  subscription_id = local.env_vars.locals.subscription_id
  client_id       = get_env("ARM_CLIENT_ID")
  client_secret   = get_env("ARM_CLIENT_SECRET")
  tenant_id       = get_env("ARM_TENANT_ID")
  common_tags = {
    "environment" = local.env_vars.locals.env
    "created_by"  = "terraform"
  }
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "=4.0.1"
      }
      azapi = {
        source  = "azure/azapi"
        version = "=1.15.0"
      }
    }
  }

  provider "azurerm" {
    subscription_id = "${local.subscription_id}"
    features {}
    resource_provider_registrations = "none"
  }
  provider "azapi" {
    subscription_id = "${local.subscription_id}"
  }
EOF
}

# Configure Terragrunt to automatically store tfstate files in an Blob Storage container
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    subscription_id      = "1148a73b-9055-4020-a3ad-00518ff5ed56"
    resource_group_name  = "rg-terraform-state-shared"
    storage_account_name = "lhtfstateshared"
    container_name       = "${local.subscription_id}-tfstate"
    key                  = "${path_relative_to_include("group")}/terraform.tfstate"
  }
}

terraform {
  # Force Terraform to keep trying to acquire a lock if someone else already has the lock
  extra_arguments "retry_lock" {
    commands = get_terraform_commands_that_need_locking()

    arguments = [
      "-lock-timeout=2m"
    ]
  }
}

terraform_version_constraint  = ">= 1.9.5, < 2"
terragrunt_version_constraint = ">= 0.53.2, < 0.54"

inputs = merge(
  local.env_vars.locals
)
