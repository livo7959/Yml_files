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
    bronze_test = {
      managed_tables = [
        {
          name = "department"
          columns = [
            {
              name     = "deptcode"
              type     = "int"
              nullable = true
            },
            {
              name     = "deptname"
              type     = "string"
              nullable = true
            },
            {
              name     = "location"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "ekg_xray_orders_counter"
          columns = [
            {
              name     = "filename"
              type     = "string"
              nullable = true
            },
            {
              name     = "ecg_results"
              type     = "int"
              nullable = true
            },
            {
              name     = "ecg_interpretation"
              type     = "int"
              nullable = true
            },
            {
              name     = "imaging_orders"
              type     = "int"
              nullable = true
            }
          ]
        },
        {
          name = "ekg_xray_sub_text_parsed"
          columns = [
            {
              name     = "filename"
              type     = "string"
              nullable = true
            },
            {
              name     = "ecg_results"
              type     = "string"
              nullable = true
            },
            {
              name     = "ecg_interpretation"
              type     = "string"
              nullable = true
            },
            {
              name     = "imaging_orders"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "epcf_pdf_text"
          columns = [
            {
              name     = "filename"
              type     = "string"
              nullable = true
            },
            {
              name     = "pdf_text"
              type     = "string"
              nullable = true
            }
          ]
        }
      ]
    }
    bronze_raw = {
      description    = "This schema is to load the source files data"
      managed_tables = []
    }
    bronze_deduped = {
      description    = "This schema is to have cleaner data from bronze_raw schema and this will be the source for silver data"
      managed_tables = []
    }
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
    silver_enriched = {
      description = "This schema will have tables with enterprise view data like cleaned, validated and enriched version"
      managed_tables = [
        {
          name = "cdg_edlog_stats"
          columns = [
            {
              name     = "dos"
              type     = "date"
              nullable = false
            },
            {
              name     = "client_group_rank"
              type     = "int"
              nullable = true
            },
            {
              name     = "account_number"
              type     = "string"
              nullable = false
            },
            {
              name     = "is_cnr"
              type     = "int"
              nullable = false
            },
            {
              name     = "reportgroup_id"
              type     = "int"
              nullable = true
            },
            {
              name     = "client_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "record_create_dttm"
              type     = "timestamp"
              nullable = false
            }
          ]
        },
        {
          name = "claim_edi_segment_data"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "transaction_set_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "row_data"
              type     = "string"
              nullable = true
            },
            {
              name     = "row_number"
              type     = "int"
              nullable = true
            },
            {
              name     = "segment_element_delim_char"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_length"
              type     = "int"
              nullable = true
            },
            {
              name     = "segment_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_subelement_delim_char"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "claim_837_grouped"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "group_header_row_data"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_rows"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "segment_element_delim_char"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_subelement_delim_char"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_837_grouped_by_hl"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "header_seg_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "group_header_elements"
              type     = "array<string>"
              nullable = false
            },
            {
              name     = "clm_ids"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "segment_rows"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "segment_element_delim_char"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_subelement_delim_char"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_277_grouped_by_hl"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "header_seg_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "group_header_elements"
              type     = "array<string>"
              nullable = false
            },
            {
              name     = "trn_elements"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "segment_rows"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "segment_element_delim_char"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_subelement_delim_char"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_837_header"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "header_info_json"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "edi_837_billing"
          columns = [
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "hl_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "billing_info_json"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "edi_837_clm"
          columns = [
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "clm_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "clm_data_json"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "edi_277_doc_level"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "header_info_json"
              type     = "string"
              nullable = false
            },
            {
              name     = "doc_level_json"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "edi_277_ack_voucher_level"
          columns = [
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "voucher_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "action_code"
              type     = "string"
              nullable = false
            },
            {
              name     = "ack_resp_data"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "edi_999_seg_grouped"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "header_seg_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "group_header_elements"
              type     = "array<string>"
              nullable = false
            },
            {
              name     = "segment_rows"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "segment_element_delim_char"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_subelement_delim_char"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_999_resp"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "resp_json"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "edi_ta1_seg_grouped"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "header_seg_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "group_header_elements"
              type     = "array<string>"
              nullable = false
            },
            {
              name     = "segment_rows"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "segment_element_delim_char"
              type     = "string"
              nullable = true
            },
            {
              name     = "segment_subelement_delim_char"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_ta1_resp"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "resp_json"
              type     = "string"
              nullable = false
            }
          ]
        }
      ]
    }
    gold_curated = {
      description = "This schema is for highly refined and aggregated data source for reports and analytics"
      managed_tables = [
        {
          name = "cdg_edlog_stats"
          columns = [
            {
              name     = "dos"
              type     = "date"
              nullable = false
            },
            {
              name     = "is_cnr"
              type     = "int"
              nullable = false
            },
            {
              name     = "reportgroup_id"
              type     = "int"
              nullable = true
            },
            {
              name     = "client_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "count"
              type     = "int"
              nullable = false
            }
          ]
        },
        {
          name = "edi_837_header_curated"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "transaction_set_control_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_creation_time"
              type     = "string"
              nullable = true
            },
            {
              name     = "receiver_last_or_organization_name"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_837_billing_curated"
          columns = [
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "hl_id"
              type     = "string"
              nullable = true
            },
            {
              name     = "billing_taxonomy"
              type     = "string"
              nullable = true
            },
            {
              name     = "billing_provider_last_or_organizational_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "provider_npi"
              type     = "string"
              nullable = true
            },
            {
              name     = "billing_provider_address_line"
              type     = "string"
              nullable = true
            },
            {
              name     = "billing_provider_city_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "billing_provider_state_or_province_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "billing_provider_postal_zone_or_zip_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "reference_id"
              type     = "string"
              nullable = true
            },
            {
              name     = "pay_to_provider_address_line"
              type     = "string"
              nullable = true
            },
            {
              name     = "pay_to_provider_city_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "pay_to_provider_state_or_province_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "pay_to_provider_postal_zone_or_zip_code"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_837_clm_curated"
          columns = [
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "clm_id"
              type     = "string"
              nullable = true
            },
            {
              name     = "individual_relationship_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "insured_group_or_policy_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "insurance_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "claim_filing_indicator_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "name_last_or_organization_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_first_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_middle_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_primary_identifier"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_address_line"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_city_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_state_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_zip_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "subscriber_birth_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "payer_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "payer_identifier"
              type     = "string"
              nullable = true
            },
            {
              name     = "payer_address_line"
              type     = "string"
              nullable = true
            },
            {
              name     = "payer_city_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "payer_state_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "payer_zip_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "claim_id"
              type     = "string"
              nullable = true
            },
            {
              name     = "patient_account_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "total_claim_charge_amount"
              type     = "string"
              nullable = true
            },
            {
              name     = "claim_frequency_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "provider_or_supplier_signature_indicator"
              type     = "string"
              nullable = true
            },
            {
              name     = "medicare_assignment_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "benefits_assignment_certification_indicator"
              type     = "string"
              nullable = true
            },
            {
              name     = "release_of_information_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "medical_record_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "diagnosis_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "rendering_provider_last_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "rendering_provider_first_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "rendering_provider_middle_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "rendering_provider_name_suffix"
              type     = "string"
              nullable = true
            },
            {
              name     = "provider_ren_npi"
              type     = "string"
              nullable = true
            },
            {
              name     = "laboratory_or_facility_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "facility_npi"
              type     = "string"
              nullable = true
            },
            {
              name     = "laboratory_or_facility_address_line"
              type     = "string"
              nullable = true
            },
            {
              name     = "laboratory_or_facility_city_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "laboratory_or_facility_state_or_province_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "laboratory_or_facility_postal_zone_or_zip_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "emergency_indicator"
              type     = "string"
              nullable = true
            },
            {
              name     = "date_time_qualifier"
              type     = "string"
              nullable = true
            },
            {
              name     = "service_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "line_item_control_number"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_277_doc_level_curated"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "file_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "file_creation_time"
              type     = "string"
              nullable = true
            },
            {
              name     = "source_sender"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_control_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "ack_qty"
              type     = "string"
              nullable = true
            },
            {
              name     = "un_ack_qty"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_277_voucher_level_curated"
          columns = [
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "action_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "voucher_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "claim_status_category"
              type     = "string"
              nullable = true
            },
            {
              name     = "claim_status_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "internal_control_number"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_277_consolidated"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "file_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "file_creation_time"
              type     = "string"
              nullable = true
            },
            {
              name     = "source_sender"
              type     = "string"
              nullable = true
            },
            {
              name     = "sender_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_control_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "ch_accepted"
              type     = "int"
              nullable = true
            },
            {
              name     = "ch_rejected"
              type     = "int"
              nullable = true
            },
            {
              name     = "pr_accepted"
              type     = "int"
              nullable = true
            },
            {
              name     = "pr_rejected"
              type     = "int"
              nullable = true
            }
          ]
        },
        {
          name = "edi_277_voucher_consolidated"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "file_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "file_creation_time"
              type     = "string"
              nullable = true
            },
            {
              name     = "sender_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "source_sender"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_control_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "voucher_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "claim_status"
              type     = "array<string>"
              nullable = true
            },
            {
              name     = "action_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "icn"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_999_resp_curated"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "file_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "file_creation_time"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_control_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "functional_ack"
              type     = "string"
              nullable = true
            },
            {
              name     = "error_reason"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "edi_ta1_resp_curated"
          columns = [
            {
              name     = "file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "ingested_time"
              type     = "timestamp"
              nullable = false
            },
            {
              name     = "edi_control_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "transaction_set_control_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_creation_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "transaction_set_creation_time"
              type     = "string"
              nullable = true
            },
            {
              name     = "interchange_ack"
              type     = "string"
              nullable = true
            },
            {
              name     = "interchange_ack_code"
              type     = "string"
              nullable = true
            }
          ]
        },
        {
          name = "practitioner_license_expirations_hepa"
          columns = [
            {
              name     = "practitioner_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "practitioner_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "practitioner_type_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_type_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "license_number"
              type     = "string"
              nullable = true
            },
            {
              name     = "expiration_date"
              type     = "date"
              nullable = true
            },
            {
              name     = "days_to_expire"
              type     = "int"
              nullable = true
            }
          ]
        }
      ]
      grants = [
        {
          principal = "EDI_Department"
          privileges = [
            "USE_SCHEMA",
            "SELECT"
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
      principal = "23319b0a-1ad1-4f74-821e-0e3ca05dc54a" # sp-databricks-fivetran-stg
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
      grants = [
        {
          principal = "EDI_Department"
          privileges = [
            "READ_FILES"
          ]
        }
      ]
    }
  ]
  location     = "eastus"
  metastore_id = "be21108f-d0c6-4186-9831-42c4ccf4c592"
  token_usage_permissions = [
    "23319b0a-1ad1-4f74-821e-0e3ca05dc54a" # sp-databricks-fivetran-stg
  ]
  unity_catalog_storage_account_name = "lhunitycatmanaged"
  workspace_id                       = 2713822203036682
}
