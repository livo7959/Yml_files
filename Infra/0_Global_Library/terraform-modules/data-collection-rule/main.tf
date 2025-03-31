resource "azurerm_monitor_data_collection_rule" "this" {
  name                        = "dcr-${local.base_name}"
  resource_group_name         = var.resource_group
  location                    = module.common_constants.region_short_name_to_long_name[var.location]
  data_collection_endpoint_id = try(var.data_collection_endpoint_id, null)
  kind                        = try(var.kind, null)
  tags                        = local.merged_tags

  dynamic "data_sources" {
    for_each = { for idx, rule in var.collection_rules : idx => rule.data_sources }

    content {
      # Using for_each to test if a value is provided. If not, set to an empty list. This is repeated for additional dynamic blocks.
      dynamic "windows_event_log" {
        for_each = data_sources.value.windows_event_log != null ? [data_sources.value.windows_event_log] : []

        content {
          # Coalesce: if a `name` value is provided, use that else use the default string."
          name           = coalesce(windows_event_log.value.name, "eventlogdatasource")
          streams        = windows_event_log.value.streams
          x_path_queries = windows_event_log.value.x_path_queries
        }
      }

      dynamic "iis_log" {
        for_each = data_sources.value.iis_log != null ? [data_sources.value.iis_log] : []

        content {
          name            = coalesce(iis_log.value.name, "iislogdatasource")
          streams         = iis_log.value.streams
          log_directories = iis_log.value.log_directories
        }
      }

      dynamic "syslog" {
        for_each = data_sources.value.syslog != null ? [data_sources.value.syslog] : []

        content {
          name           = coalesce(syslog.value.name, "syslogdatasource")
          facility_names = syslog.value.facility_names
          log_levels     = syslog.value.log_levels
          streams        = syslog.value.streams
        }
      }

      dynamic "log_file" {
        for_each = data_sources.value.log_file != null ? [data_sources.value.log_file] : []


        content {
          name          = coalesce(log_file.value.name, "logfiledatasource")
          format        = log_file.value.format
          file_patterns = log_file.value.file_patterns
          streams       = log_file.value.streams

          settings {

            text {
              record_start_timestamp_format = try(log_file.value.record_start_timestamp_format, null)
            }
          }
        }
      }

      dynamic "performance_counter" {
        for_each = data_sources.value.performance_counter != null ? [data_sources.value.performance_counter] : []

        content {
          name                          = coalesce(performance_counter.value.name, "perflogdatasource")
          counter_specifiers            = performance_counter.value.counter_specifiers
          sampling_frequency_in_seconds = performance_counter.value.sampling_frequency_in_seconds
          streams                       = performance_counter.value.streams
        }
      }

      dynamic "extension" {
        for_each = data_sources.value.extension != null ? [data_sources.value.extension] : []

        content {
          name           = coalesce(extension.value.name, "extensiondatasource")
          extension_name = extension.value.extension_name
          extension_json = extension.value.extension_json
          streams        = extension.value.streams
        }
      }
    }
  }
  # Note there are additional possible `destinations`. Refactoring may be needed if the use cases arise.
  dynamic "destinations" {
    for_each = { for idx, rule in var.collection_rules : idx => rule.destinations }

    content {

      dynamic "log_analytics" {
        for_each = destinations.value.log_analytics != null ? [destinations.value.log_analytics] : []

        content {
          name                  = log_analytics.value.name
          workspace_resource_id = log_analytics.value.workspace_resource_id
        }
      }

      dynamic "azure_monitor_metrics" {
        for_each = destinations.value.azure_monitor_metrics != null ? [destinations.value.azure_monitor_metrics] : []

        content {
          name = azure_monitor_metrics.value.name
        }
      }
    }
  }

  dynamic "data_flow" {
    for_each = { for idx, rule in var.collection_rules : idx => rule.data_flow }

    content {
      streams            = data_flow.value.streams
      destinations       = data_flow.value.destinations
      built_in_transform = try(data_flow.value.built_in_transform, null)
      output_stream      = try(data_flow.value.output_stream, null)
      transform_kql      = try(data_flow.value.transform_kql, null)
    }
  }

  dynamic "stream_declaration" {
    for_each = { for idx, stream in var.stream_declaration : idx => stream }

    content {
      stream_name = stream_declaration.value.stream_name

      dynamic "column" {
        for_each = { for idx, column in stream_declaration.value.columns : idx => column }

        content {
          name = column.value.name
          type = column.value.type
        }
      }
    }
  }

  dynamic "identity" {
    for_each = { for idx, id in var.identity : idx => id }

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

# Data Collection Rule Associations. Associations to other DCRs are supported, by default the DCR created in the module is used.

resource "azurerm_monitor_data_collection_rule_association" "this" {
  for_each = var.associations != null ? { for idx, dca in var.associations : idx => dca } : {}

  name                    = each.value.name
  target_resource_id      = each.value.target_resource_id
  data_collection_rule_id = coalesce(each.value.data_collection_rule_id, azurerm_monitor_data_collection_rule.this.id)
}



