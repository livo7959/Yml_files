include "root" {
  path = find_in_parent_folders()
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
    host = "${get_env("DATABRICKS_HOST")}"
  }
EOF
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//databricks_workspace"
}

inputs = {
  cluster_configurations = [
    {
      name                    = "Shared Fixed Cluster"
      autotermination_minutes = 60
      max_workers             = 1
    },
    {
      name                    = "Data Processing"
      autotermination_minutes = 15
      max_workers             = 8
      node_type_id            = "Standard_DS4_v2"
    }
  ]
  cluster_policies = [
    {
      name        = "Delta Live Tables"
      description = "Policy to be used for Delta Live Tables pipeline compute"
      definition = {
        cluster_type = {
          type  = "fixed",
          value = "dlt"
        },
        num_workers = {
          type         = "range",
          defaultValue = 1,
          maxValue     = 1,
          isOptional   = true
        },
        node_type_id = {
          type       = "unlimited",
          isOptional = true
        },
        spark_version = {
          type   = "unlimited",
          hidden = true
        }
      }
    }
  ]
  dashboards = []
  dlt_pipelines = [
    {
      name        = "dlt-claim-edi-raw"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_claims_edi_bronze"
        auto_load_schema_location       = "/mnt/schema"
        abfss_raw_data_load_target_path = "abfss://uploaded-data@lhdatalakestoragestg.dfs.core.windows.net/claims"
      }
    },
    {
      name        = "dlt-claim-edi-raw-test"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_claims_edi_raw_test"
        auto_load_schema_location       = "/mnt/schema"
        abfss_raw_data_load_target_path = "abfss://uploaded-data@lhdatalakestoragestg.dfs.core.windows.net/claim_edi"
      }
    },
    {
      name        = "raw-symplr-practitioners"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/binary_data_autoload"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name   = "symplr_practitioners"
        storage_path = "abfss://symplr@lhdatalakestoragestg.dfs.core.windows.net/practitioners_search"
      }
    },
    {
      name        = "parsed-symplr-practitioners"
      target      = "parsed"
      continuous  = false
      development = true
      photon      = false
      channel     = "PREVIEW"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/parsed/json_parsing"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name = "symplr_practitioners"
      }
    },
    {
      name        = "raw-symplr-practitioner-plans"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/binary_data_autoload"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name   = "symplr_practitioner_plans"
        storage_path = "abfss://symplr@lhdatalakestoragestg.dfs.core.windows.net/practitioner_plans"
      }
    },
    {
      name        = "parsed-symplr-practitioner-plans"
      target      = "parsed"
      continuous  = false
      development = true
      photon      = false
      channel     = "PREVIEW"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/parsed/json_parsing"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name = "symplr_practitioner_plans"
      }
    },
    {
      name        = "dlt-symplr-practitioner-license-raw"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_symplr_practitioner_license"
        abfss_raw_data_load_target_path = "abfss://symplr@lhdatalakestoragestg.dfs.core.windows.net/practitioner_licenses"
      }
    },
    {
      name        = "raw-symplr-product-location"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/binary_data_autoload"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name   = "symplr_product_location"
        storage_path = "abfss://symplr@lhdatalakestoragestg.dfs.core.windows.net/product_location_search"
      }
    },
    {
      name        = "raw-symplr-product-location-variant"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "PREVIEW"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/json_to_variant"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name = "symplr_product_location"
      }
    },
    {
      name        = "validated-symplr-product-location"
      target      = "validated"
      continuous  = false
      development = true
      photon      = false
      channel     = "PREVIEW"
      edition     = "PRO"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/validated/symplr/product-location"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-symplr-practices-practitioner-locations-search"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/binary_data_autoload"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name   = "symplr_practices_practitioner_locations_search"
        storage_path = "abfss://symplr@lhdatalakestoragestg.dfs.core.windows.net/practices_practitioner_locations_search"
      }
    },
    {
      name        = "raw-symplr-practices-practitioner-locations-variant"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "PREVIEW"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/json_to_variant"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name = "symplr_practices_practitioner_locations_search"
      }
    }
  ]
  job_configurations = []
  key_vault_id       = "/subscriptions/f533a95b-ce94-4023-a472-ab4c3748b37c/resourceGroups/rg-databricks-prod/providers/Microsoft.KeyVault/vaults/dbk-logix-data-prod"
  key_vault_uri      = "https://dbk-logix-data-prod.vault.azure.net/"
  sql_endpoints = [
    # This endpoint does not exist in the sandbox environment but exists in the other ones.
    {
      name             = "dashboard_warehouse"
      cluster_size     = "2X-Small"
      min_num_clusters = 1
      max_num_clusters = 1
      auto_stop_mins   = 30
      warehouse_type   = "PRO"
      grants = [
        {
          group_name       = "data_engineering_data_developer"
          permission_level = "CAN_USE"
        }
      ]
    },
    {
      name             = "sql_endpoint_fivetran"
      cluster_size     = "2X-Small"
      min_num_clusters = 1
      max_num_clusters = 1
      auto_stop_mins   = 30
      warehouse_type   = "PRO"
      grants = [
        {
          service_principal_name = "24c78857-6da5-4861-874e-44b8a78c4682" # sp-databricks-fivetran-prod
          permission_level       = "CAN_USE"
        }
      ]
    },
  ]
  tenant_id    = "${get_env("ARM_TENANT_ID")}"
  workspace_id = 509690184712866
}
