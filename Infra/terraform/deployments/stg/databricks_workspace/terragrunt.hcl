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
  dashboards = [
    {
      name = "Claim Unification Summary"
      grants = [
        {
          group_name       = "EDI_Department"
          permission_level = "CAN_READ"
        }
      ]
    }
  ]
  dlt_pipelines = [
    {
      name        = "autoloader-example"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/AutoLoader Example"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-client"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-client"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-edlog-stats"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-edlog-stats"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-chart"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-chart"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-cdcpts"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-cdcpts"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-serviceinfo-diags"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-serviceinfo-diags"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-voucher"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-voucher"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-service"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-service"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-tran-category"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-tran-category"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-voucher-note"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-voucher-note"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-voucher-note-type"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-voucher-note-type"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-transaction-code"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-transaction-code"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-operator"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-operator"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-location"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-location"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-diag-code"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-diag-code"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-department"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-department"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-carrier"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-carrier"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-batch"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-batch"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-provider"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-provider"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-patient"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-patient"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-patient-policies"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-patient-policies"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-rcm-patient-additional-info"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-rcm-patient-additional-info"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-client"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-client"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-report-group"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-report-group"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-client-rpt-map"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-client-rpt-map"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "dup-cdg-client-rpt-map"
      target      = "bronze_deduped"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-deduped/dup-cdg-client-rpt-map"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "dup-cdg-edlog-stats"
      target      = "bronze_deduped"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-deduped/dup-cdg-edlog-stats"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "dup-cdg-report-group"
      target      = "bronze_deduped"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-deduped/dup-cdg-report-group"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "dup-cdg-chart"
      target      = "bronze_deduped"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-deduped/dup-cdg-chart"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "dup-cdg-cdcpts"
      target      = "bronze_deduped"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-deduped/dup-cdg-cdcpts"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "enr-cdg-edlog-stats"
      target      = "silver_enriched"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/deduped-to-enriched/enr-cdg-edlog-stats"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "cur-cdg-edlog-stats"
      target      = "gold_curated"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/enriched-curated/cur-cdg-edlog-stats"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-pd-operational-metrics"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-pd-operational-metrics"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-chcpts"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-chcpts"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "dup-cdg-chcpts"
      target      = "bronze_deduped"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-deduped/dup-cdg-chcpts"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-chcpt-diagnosis"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-chcpt-diagnosis"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-chcpt-visittypeproviders"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-cpcpt-visittypeproviders"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-cdcarriers"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-cdcarriers"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-cddepartments"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-cddepartments"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-chaudit-trail"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-chaudit-trail"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-cddispositions"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-cddispositions"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-mddispositions"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-mddispositions"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-mdgenders"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-mdgenders"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-cdg-mdchart-statuses"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-bronze/raw-cdg-mdchart-statuses"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "dup-pd-operational-metrics"
      target      = "bronze_deduped"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/raw-to-deduped/dup-pd-operational-metrics"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "enr-pd-operational-metrics"
      target      = "silver_enriched"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "ADVANCED"
      notebooks = [
        "/Shared/deduped-to-enriched/enr-pd-operational-metrics"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
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
      channel     = "CURRENT"
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
      name        = "raw-symplr-practitioner-plans-variant"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/json_to_variant"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name = "symplr_practitioner_plans"
      }
    },
    {
      name        = "parsed-symplr-practitioner-plans"
      target      = "parsed"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
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
      name        = "validated-symplr-practitioner-plans"
      target      = "validated"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "PRO"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/validated/symplr/practitioner-plans"
      ]
      cluster = {
        policy = "Delta Live Tables"
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
      channel     = "CURRENT"
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
      channel     = "CURRENT"
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
      name        = "raw-symplr-practices-practitioner-locations-search-variant"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
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
    },
    {
      name        = "validated-symplr-practitioner-locations"
      target      = "validated"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "PRO"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/validated/symplr/practitioner-locations"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "raw-symplr-product-search"
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
        table_name   = "symplr_product_search"
        storage_path = "abfss://symplr@lhdatalakestoragestg.dfs.core.windows.net/product_search"
      }
    },
    {
      name        = "raw-symplr-product-search-variant"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/raw/json_to_variant"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        table_name = "symplr_product_search"
      }
    }
  ]
  job_configurations = [
    {
      name        = "raw-rcm-client"
      description = "Job to run raw-rcm-client DLT pipeline"
      tasks = {
        raw-rcm-client = {
          task_key = "raw-rcm-client"
          pipeline_task = {
            pipeline_name = "raw-rcm-client"
          }
        }
      }
    },
    {
      name        = "cdg-client-rpt-map"
      description = "Job to run client rpt map raw and deduped DLT pipeline"
      tasks = {
        raw-cdg-client-rpt-map = {
          pipeline_task = {
            pipeline_name = "raw-cdg-client-rpt-map"
          }
        },
        dup-cdg-client-rpt-map = {
          pipeline_task = {
            pipeline_name = "dup-cdg-client-rpt-map"
          }
          dependencies = [
            "raw-cdg-client-rpt-map"
          ]
        }
      }
    },
    {
      name        = "cdg-report-group"
      description = "Job to run report group raw and deduped DLT pipeline"
      tasks = {
        raw-cdg-report-group = {
          pipeline_task = {
            pipeline_name = "raw-cdg-report-group"
          }
        },
        dup-cdg-report-group = {
          pipeline_task = {
            pipeline_name = "dup-cdg-report-group"
          }
          dependencies = [
            "raw-cdg-report-group"
          ]
        }
      }
    },
    {
      name        = "cdg-edlog-stats"
      description = "Job to run edlog_stats raw and deduped DLT pipeline"
      tasks = {
        raw-cdg-edlog-stats = {
          pipeline_task = {
            pipeline_name = "raw-cdg-edlog-stats"
          }
        },
        dup-cdg-edlog-stats = {
          pipeline_task = {
            pipeline_name = "dup-cdg-edlog-stats"
          }
          dependencies = [
            "raw-cdg-edlog-stats"
          ]
        },
        enr-cdg-edlog-stats = {
          pipeline_task = {
            pipeline_name = "enr-cdg-edlog-stats"
          }
          dependencies = [
            "dup-cdg-edlog-stats"
          ]
        }
      }
    },
    {
      name        = "claims-edi-underlying-data"
      description = "Job to run raw autoload DLT pipeline plus the next level underlying data curations"
      tasks = {
        dlt-claim-edi-raw = {
          pipeline_task = {
            pipeline_name = "dlt-claim-edi-raw"
          }
        },
        claim-edi-parsing = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/claim_edi_parse_segment"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "dlt-claim-edi-raw"
          ]
        },
        edi-837-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_837_seg_grouping_by_hl"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-837-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_837_submission_silver"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-837-segment-grouping"
          ]
        },
        edi-837-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_837_gold_curation"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-837-silver"
          ]
        },
        edi-277-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_277_seg_grouping_by_hl"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-277-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_277_ack_response_silver"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-277-segment-grouping"
          ]
        },
        edi-277-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_277_gold_curation"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-277-silver"
          ]
        },
        edi-999-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_999_seg_grouping"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-999-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_999_ack_response_silver"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-999-segment-grouping"
          ]
        },
        edi-999-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_999_gold_curation"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-999-silver"
          ]
        },
        edi-ta1-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_ta1_seg_grouping"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-ta1-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_ta1_ack_response_silver"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-ta1-segment-grouping"
          ]
        },
        edi-ta1-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_ta1_gold_curation"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "edi-ta1-silver"
          ]
        }
      }
      schedule = {
        quartz_cron_expression = "0 0 0/8 * * ?"
        timezone_id            = "America/New_York"
      }
    },
    {
      name        = "symplr-practitioner-license-expiration-info"
      description = "Job to run Symplr DLT pipelines and notebooks for Practitioner License Expiration Info data curations"
      tasks = {
        dlt-symplr-practitioner-license-raw = {
          pipeline_task = {
            pipeline_name = "dlt-symplr-practitioner-license-raw"
          }
        },
        validated-symplr-practitioner-locations = {
          pipeline_task = {
            pipeline_name = "validated-symplr-practitioner-locations"
          }
        },
        symplr_practitioner_license_info = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/symplr/symplr_practitioner_license_info"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "dlt-symplr-practitioner-license-raw",
            "validated-symplr-practitioner-locations"
          ]
        },
        practitioner_license_exp_dataset = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/symplr/practitioner_license_exp_dataset"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "symplr_practitioner_license_info"
          ]
        },
        pratitioner_license_exp_emailer = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/symplr/pratitioner_license_exp_emailer"
          }
          existing_cluster_name = "Data Processing"
          dependencies = [
            "practitioner_license_exp_dataset"
          ]
        }
      }
    }
  ]
  key_vault_id  = "/subscriptions/bf6bb924-c903-43e9-9e06-2c2d2c605d1a/resourceGroups/rg-databricks-stg/providers/Microsoft.KeyVault/vaults/dbk-logix-data-stg"
  key_vault_uri = "https://dbk-logix-data-stg.vault.azure.net/"
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
          service_principal_name = "23319b0a-1ad1-4f74-821e-0e3ca05dc54a" # sp-databricks-fivetran-stg
          permission_level       = "CAN_USE"
        }
      ]
    },
  ]
  tenant_id    = "${get_env("ARM_TENANT_ID")}"
  workspace_id = 6677558479261806
}
