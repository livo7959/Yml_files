locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

include "root" {
  path = find_in_parent_folders()
}

include "data" {
  path           = "${get_terragrunt_dir()}/../../_env/online/data.hcl"
  merge_strategy = "deep"
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//main"
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    subscription_id      = "${local.env_vars.locals.subscription_id}"
    resource_group_name  = "rg-tfstate-online-stg-001"
    storage_account_name = "lhtfstateonlinestg001"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

inputs = {
  resource_groups = {
    online-data = {
      location = "eastus",
      resources = {
        cdn_profiles = [
          {
            name = "logixhealth",
            endpoint_configs = [
              {
                name          = "epic-fhir",
                origin_name   = "epic-fhir-jwkset",
                origin_path   = "/epic-fhir",
                host_name     = "lhpublicdataostg.blob.core.windows.net"
                custom_domain = "epicfhirauth.sandbox.logixhealth.com"
              }
            ]
          }
        ]
      }
    }
  }
}
