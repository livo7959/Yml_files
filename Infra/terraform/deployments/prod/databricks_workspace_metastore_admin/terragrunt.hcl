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
  source = "${get_terragrunt_dir()}/../../../modules//databricks_workspace_metastore_admin"
}

inputs = {
  catalog_assets = {
    raw = {
      managed_tables = []
      volumes = [
        {
          name                   = "raw-fhir"
          external_location_name = "adls2-raw-fhir"
          readers = [
            "raw_fhir_readers"
          ]
        }
      ]
      grants = [
        {
          principal = "raw_fhir_readers"
          privileges = [
            "USE_SCHEMA"
          ]
        },
      ]
    }
    parsed = {
      description = "This schema will have tables with parsed, flattened version of the raw data"
      managed_tables = [
        {
          name = "symplr_practitioner_license_info_flattened"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "file_created_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "practitioner_license_rec_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "practitioner_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "practitioner_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "practitioner_archived"
              type     = "string"
              nullable = true
            },
            {
              name     = "practitioner_type_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "practitioner_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "first_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "middle_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "last_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_type_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "license_type_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_sub_type_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "license_sub_type_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_sub_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "npdb_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "issue_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "expiration_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_status_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "issuing_state"
              type     = "string"
              nullable = true
            },
            {
              name     = "primary_license"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_status_type_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_status_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "active_state_practice"
              type     = "string"
              nullable = true
            },
            {
              name     = "disciplinary_action"
              type     = "string"
              nullable = true
            },
            {
              name     = "disciplinary_status"
              type     = "string"
              nullable = true
            },
            {
              name     = "compact"
              type     = "string"
              nullable = true
            },
            {
              name     = "notes"
              type     = "string"
              nullable = true
            },
            {
              name     = "verification_status"
              type     = "string"
              nullable = true
            },
            {
              name     = "targeted_verification_url"
              type     = "string"
              nullable = true
            },
            {
              name     = "location_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "alert"
              type     = "string"
              nullable = true
            },
            {
              name     = "gap_days"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "entity_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "workgroup_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "entity_ids"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "controlled_substance_schedule_ids"
              type     = "array<bigint>"
              nullable = true
            },
            {
              name     = "tv_license"
              type     = "string"
              nullable = true
            },
            {
              name     = "archived"
              type     = "string"
              nullable = true
            },
            {
              name     = "data_source"
              type     = "string"
              nullable = true
            },
            {
              name     = "created_by"
              type     = "string"
              nullable = true
            },
            {
              name     = "created_on"
              type     = "string"
              nullable = true
            },
            {
              name     = "changed_by"
              type     = "string"
              nullable = true
            },
            {
              name     = "changed_on"
              type     = "string"
              nullable = true
            },
            {
              name     = "credentialing_record"
              type     = "string"
              nullable = true
            }
          ]
        }
      ]
    }
    presentation = {
      description    = "Curated datasets for specific consumption"
      managed_tables = []
    }
    deduped = {
      description = "This schema will have tables with deduped version of the parsed data"
      managed_tables = [
        {
          name = "symplr_practitioner_license_info_dedup"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "file_created_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "_lic_uid"
              type     = "string"
              nullable = true
            },
            {
              name     = "practitioner_license_rec_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "practitioner_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "practitioner_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "practitioner_archived"
              type     = "string"
              nullable = true
            },
            {
              name     = "practitioner_type_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "practitioner_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "first_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "middle_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "last_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_type_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "license_type_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_sub_type_id"
              type     = "bigint"
              nullable = true
            },
            {
              name     = "license_sub_type_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_sub_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "npdb_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "issue_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "expiration_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_status_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "issuing_state"
              type     = "string"
              nullable = true
            },
            {
              name     = "primary_license"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_status_type_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_status_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "active_state_practice"
              type     = "string"
              nullable = true
            },
            {
              name     = "created_by"
              type     = "string"
              nullable = true
            },
            {
              name     = "created_on"
              type     = "string"
              nullable = true
            },
            {
              name     = "changed_by"
              type     = "string"
              nullable = true
            },
            {
              name     = "changed_on"
              type     = "string"
              nullable = true
            }
          ]
        }
      ]
    }
    validated = {
      description    = "Initial Data Quality filtering, Schema Applied and Deduplicated Data"
      managed_tables = []
    }
  }
  catalog_grants = [
    {
      principal = "24c78857-6da5-4861-874e-44b8a78c4682" # sp-databricks-fivetran-prod
      privileges = [
        "CREATE_SCHEMA",
        "CREATE_TABLE",
        "MODIFY",
        "SELECT",
        "USE_CATALOG",
        "USE_SCHEMA",
      ]
    },
  ]
  cluster_id = "0401-184114-hes6rn29" // Shared Fixed Cluster
  external_storage_locations = [
    {
      external_location_name = "adls2-cdc-on-prem"
      storage_account_name   = "lhdatalakestorage"
      container_name         = "cdc-on-prem"
    },
    {
      external_location_name = "adls2-public-data"
      storage_account_name   = "lhdatalakestorage"
      container_name         = "public-data"
    },
    {
      external_location_name = "adls2-raw-fhir"
      storage_account_name   = "lhdatalakestorage"
      container_name         = "raw-fhir"
    },
    {
      external_location_name = "adls2-symplr"
      storage_account_name   = "lhdatalakestorage"
      container_name         = "symplr"
    },
    {
      external_location_name = "adls2-uploaded-data"
      storage_account_name   = "lhdatalakestorage"
      container_name         = "uploaded-data"
    }
  ]
  location     = "eastus"
  metastore_id = "be21108f-d0c6-4186-9831-42c4ccf4c592"
  token_usage_permissions = [
    "24c78857-6da5-4861-874e-44b8a78c4682" # sp-databricks-fivetran-prod
  ]
  unity_catalog_storage_account_name = "lhunitycatmanaged"
  workspace_id                       = 509690184712866
}
