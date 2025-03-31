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
        }
      ]
    }
    bronze_raw = {
      description = "This schema is to load the source files data"
      managed_tables = [
        {
          name = "icd_10_cm_codes"
          columns = [
            {
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "icd_10_cm_code"
              type     = "string"
              nullable = false
            },
            {
              name     = "long_desc"
              type     = "string"
              nullable = false
            },
            {
              name     = "fiscal_year"
              type     = "int"
              nullable = false
            },
            {
              name     = "_file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "_written_at"
              type     = "timestamp"
              nullable = false
            }
          ]
        },
        {
          name = "icd_10_cm_orders"
          columns = [
            {
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "order_number"
              type     = "int"
              nullable = false
            },
            {
              name     = "icd_10_cm_code"
              type     = "string"
              nullable = false
            },
            {
              name     = "is_leaf_code"
              type     = "boolean"
              nullable = false
            },
            {
              name     = "short_desc"
              type     = "string"
              nullable = false
            },
            {
              name     = "long_desc"
              type     = "string"
              nullable = false
            },
            {
              name     = "fiscal_year"
              type     = "int"
              nullable = false
            },
            {
              name     = "_file_name"
              type     = "string"
              nullable = false
            },
            {
              name     = "_written_at"
              type     = "timestamp"
              nullable = false
            }
          ]
        }
      ]
    }
    raw = {
      managed_tables = [
        {
          name = "icd10_additional_code_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_code_also_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_code_first_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_excludes_1_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_excludes_2_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_include_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_metadata_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_note_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_seventh_char_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd10_tabular_code_raw_json"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "raw_json_text"
              type     = "string"
              nullable = false
            }
          ]
        }
      ]
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
      managed_tables = [
        {
          name = "icd10_additional_code_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_code_also_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_code_first_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_excludes_1_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_excludes_2_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_include_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_note_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_seventh_char_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
              nullable = true
            }
          ]
        },
        {
          name = "icd10_tabular_code_parsed_deduped"
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
              name     = "_record_id"
              type     = "string"
              nullable = false
            },
            {
              name     = "instruction"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "instruction_items"
              type     = "array<string>"
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
    silver_enriched = {
      managed_tables = [
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
        },
        {
          name = "icd_10_cm_codes"
          columns = [
            {
              name     = "icd_10_cm_code"
              type     = "string"
              nullable = false
            },
            {
              name     = "long_desc"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "icd_10_cm_orders"
          columns = [
            {
              name     = "order_num"
              type     = "string"
              nullable = false
            },
            {
              name     = "icd_10_cm_code"
              type     = "string"
              nullable = false
            },
            {
              name     = "is_leaf_code"
              type     = "boolean"
              nullable = false
            },
            {
              name     = "short_desc"
              type     = "string"
              nullable = false
            },
            {
              name     = "long_desc"
              type     = "string"
              nullable = false
            }
          ]
        },
        {
          name = "medicare_revalidation_silver"
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
              name     = "enrollment_id"
              type     = "string"
              nullable = true
            },
            {
              name     = "national_provider_identifier"
              type     = "string"
              nullable = true
            },
            {
              name     = "first_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "last_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "organization_name"
              type     = "string"
              nullable = true
            },
            {
              name     = "enrollment_state_code"
              type     = "string"
              nullable = true
            },
            {
              name     = "enrollment_type"
              type     = "string"
              nullable = true
            },
            {
              name     = "provider_type_text"
              type     = "string"
              nullable = true
            },
            {
              name     = "enrollment_specialty"
              type     = "string"
              nullable = true
            },
            {
              name     = "revalidation_due_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "adjusted_due_date"
              type     = "string"
              nullable = true
            },
            {
              name     = "individual_total_reassign_to"
              type     = "string"
              nullable = true
            },
            {
              name     = "receiving_benefits_reassignment"
              type     = "string"
              nullable = true
            }
          ]
        }
      ]
    }
    gold_curated = {
      description = "This schema is for highly refined and aggregated data source for reports and analytics"
      managed_tables = [
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
    }
    validated = {
      description    = "Initial Data Quality filtering, Schema Applied and Deduplicated Data"
      managed_tables = []
    }
  }
  catalog_grants = [
    {
      principal = "a7b73f9d-7703-425c-b8fb-e325eac24b5e" # sp-databricks-fivetran-sbox
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
  cluster_id = "0320-154914-ojva2ent" // Shared Fixed Cluster
  external_storage_locations = [
    {
      external_location_name = "adls2-cdc-on-prem"
      storage_account_name   = "lhdatalakestorage"
      container_name         = "cdc-on-prem"
    },
    {
      external_location_name = "adls2-globalscape-eft"
      storage_account_name   = "lhdatalakestorage"
      container_name         = "globalscape-eft"
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
    "a7b73f9d-7703-425c-b8fb-e325eac24b5e" # sp-databricks-fivetran-sbox
  ]
  unity_catalog_storage_account_name = "lhunitycatmanaged"
  workspace_id                       = 6677558479261806
}
