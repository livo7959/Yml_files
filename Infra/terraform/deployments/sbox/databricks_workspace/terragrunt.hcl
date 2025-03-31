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
      autotermination_minutes = 20
      max_workers             = 1
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
  dlt_pipelines = [
    {
      name        = "dlt-claim-edi-raw-mocked"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_claims_edi_raw_mocked"
        abfss_raw_data_load_target_path = "abfss://globalscape-eft@lhdatalakestoragesbox.dfs.core.windows.net/edi_claims_mocked"
      }
    },
    {
      name        = "dlt-medicare-revalidation-raw"
      target      = "bronze_raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_medicare_revalidation"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/cms/medicare_revalidation"
      }
    },
    {
      name        = "dlt-icd10-additional_code"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_additional_code"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/additional_code"
      }
    },
    {
      name        = "dlt-icd10-code_also"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_code_also"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/code_also"
      }
    },
    {
      name        = "dlt-icd10-code_first"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_code_first"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/code_first"
      }
    },
    {
      name        = "dlt-icd10-excludes_1"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_excludes_1"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/excludes_1"
      }
    },
    {
      name        = "dlt-icd10-excludes_2"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_excludes_2"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/excludes_2"
      }
    },
    {
      name        = "dlt-icd10-include"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_include"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/include"
      }
    },
    {
      name        = "dlt-icd10-metadata"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_metadata"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/metadata"
      }
    },
    {
      name        = "dlt-icd10-note"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_note"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/note"
      }
    },
    {
      name        = "dlt-icd10-seventh_char"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_seventh_char"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/seventh_char"
      }
    },
    {
      name        = "dlt-icd10-tabular_code"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_icd10_tabular_code"
        abfss_raw_data_load_target_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/tabular_code"
      }
    },
    {
      name        = "dlt-symplr-practitioner-license-raw"
      target      = "raw"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/bronze/dlt_raw_data_auto_load_bronze"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
      configuration = {
        bronze_table_name               = "dlt_symplr_practitioner_license"
        abfss_raw_data_load_target_path = "abfss://symplr@lhdatalakestoragesbox.dfs.core.windows.net/practitioner_licenses"
      }
    },
    {
      name        = "raw-icd10-tabular-code"
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
        table_name   = "icd10_tabular_code"
        storage_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/tabular_code"
      }
    },
    {
      name        = "raw-icd10-excludes-1"
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
        table_name   = "icd10_excludes_1"
        storage_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/icd_10/excludes_1"
      }
    },
    {
      name        = "raw-icd10-tabular-code-variant"
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
        table_name = "icd10_tabular_code"
      }
    },
    {
      name        = "raw-icd10-excludes-1-variant"
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
        table_name = "icd10_excludes_1"
      }
    },
    {
      name        = "raw-cms-ioce-dx10"
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
        table_name   = "cms_ioce_dx10"
        storage_path = "abfss://public-data@lhdatalakestoragesbox.dfs.core.windows.net/cms/ioce_quarterly_release_files"
      }
    },
    {
      name        = "validated-icd10-excludes-1"
      target      = "validated"
      continuous  = false
      development = true
      photon      = false
      channel     = "PREVIEW"
      edition     = "PRO"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/validated/icd10/excludes_1"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    },
    {
      name        = "presentation-codify-md-icd-invalid-combinations"
      target      = "presentation"
      continuous  = false
      development = true
      photon      = false
      channel     = "CURRENT"
      edition     = "CORE"
      notebooks = [
        "/Shared/databricks-data/workspace/dlt/presentation/md_icd_invalid_combinations"
      ]
      cluster = {
        policy = "Delta Live Tables"
      }
    }
  ]
  job_configurations = [
    {
      name        = "claims-edi-underlying-data"
      description = "Job to run raw autoload DLT pipeline plus the next level underlying data curations"
      tasks = {
        dlt-claim-edi-raw = {
          pipeline_task = {
            pipeline_name = "dlt-claim-edi-raw-mocked"
          }
        },
        claim-edi-parsing = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/claim_edi_parse_segment"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "dlt-claim-edi-raw"
          ]
        },
        edi-837-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_837_seg_grouping_by_hl"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-837-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_837_submission_silver"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-837-segment-grouping"
          ]
        },
        edi-837-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_837_gold_curation"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-837-silver"
          ]
        },
        edi-277-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_277_seg_grouping_by_hl"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-277-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_277_ack_response_silver"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-277-segment-grouping"
          ]
        },
        edi-277-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_277_gold_curation"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-277-silver"
          ]
        },
        edi-999-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_999_seg_grouping"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-999-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_999_ack_response_silver"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-999-segment-grouping"
          ]
        },
        edi-999-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_999_gold_curation"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-999-silver"
          ]
        },
        edi-ta1-segment-grouping = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_ta1_seg_grouping"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "claim-edi-parsing"
          ]
        },
        edi-ta1-silver = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_ta1_ack_response_silver"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-ta1-segment-grouping"
          ]
        },
        edi-ta1-gold = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/claim-edi/edi_ta1_gold_curation"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "edi-ta1-silver"
          ]
        }
      }
    },
    {
      name        = "icd10-underlying-data"
      description = "Job to run raw autoload DLT pipeline, plus the next level underlying data curations"
      tasks = {
        dlt_icd10_additional_code = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-additional_code"
          }
        },
        dlt_icd10_code_also = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-code_also"
          }
          dependencies = [
            "dlt_icd10_additional_code"
          ]
        },
        dlt_icd10_code_first = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-code_first"
          }
          dependencies = [
            "dlt_icd10_code_also"
          ]
        },
        dlt_icd10_excludes_1 = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-excludes_1"
          }
          dependencies = [
            "dlt_icd10_code_first"
          ]
        },
        dlt_icd10_excludes_2 = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-excludes_2"
          }
          dependencies = [
            "dlt_icd10_excludes_1"
          ]
        },
        dlt_icd10_include = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-include"
          }
          dependencies = [
            "dlt_icd10_excludes_2"
          ]
        },
        dlt_icd10_metadata = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-metadata"
          }
          dependencies = [
            "dlt_icd10_include"
          ]
        },
        dlt_icd10_note = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-note"
          }
          dependencies = [
            "dlt_icd10_metadata"
          ]
        },
        dlt_icd10_seventh_char = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-seventh_char"
          }
          dependencies = [
            "dlt_icd10_note"
          ]
        },
        dlt_icd10_tabular_code = {
          pipeline_task = {
            pipeline_name = "dlt-icd10-tabular_code"
          }
          dependencies = [
            "dlt_icd10_seventh_char"
          ]
        },
        icd10_raw_json = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/icd-10/icd10_raw_json"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "dlt_icd10_additional_code",
            "dlt_icd10_code_also",
            "dlt_icd10_code_first",
            "dlt_icd10_excludes_1",
            "dlt_icd10_excludes_2",
            "dlt_icd10_include",
            "dlt_icd10_metadata",
            "dlt_icd10_note",
            "dlt_icd10_seventh_char",
            "dlt_icd10_tabular_code"
          ]
        },
        icd10_parsed_deduped = {
          notebook_task = {
            notebook_name = "/Workspace/Shared/databricks-data/workspace/icd-10/icd10_parsed_deduped"
          }
          existing_cluster_name = "Shared Fixed Cluster"
          dependencies = [
            "icd10_raw_json"
          ]
        }
      }
    }
  ]
  key_vault_id  = "/subscriptions/8192a5d8-1a56-4caf-b961-0eae16cbd1d3/resourceGroups/rg-databricks-sbox/providers/Microsoft.KeyVault/vaults/dbk-logix-data-sbox"
  key_vault_uri = "https://dbk-logix-data-sbox.vault.azure.net/"
  sql_endpoints = [
    # This endpoint does not exist in the staging or production enviornments because it is meant just for testing.
    {
      name             = "sql_endpoint_test"
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
          service_principal_name = "a7b73f9d-7703-425c-b8fb-e325eac24b5e" # sp-databricks-fivetran-sbox
          permission_level       = "CAN_USE"
        }
      ]
    },
  ]
  tenant_id    = "${get_env("ARM_TENANT_ID")}"
  workspace_id = 6677558479261806
}
