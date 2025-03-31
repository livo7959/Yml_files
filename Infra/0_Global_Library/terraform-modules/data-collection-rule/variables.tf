# ------------------
# Required variables
# ------------------

variable "resource_group" {
  type        = string
  description = "Name of the resource group that the data collection rule should be in. Should be in the format of: `rg-foo`"
  nullable    = false
  validation {
    condition     = var.resource_group != null && can(regex(module.common_constants.kebab_case_regex, var.resource_group))
    error_message = "The resource group must be kebab-case."
  }
  validation {
    condition     = var.resource_group != null && startswith(var.resource_group, "rg-")
    error_message = "The resource group must start with \"rg-\"."
  }
}

variable "name" {
  type        = string
  description = "A name describing what the data collection rule is for. Note that the real name of the resource will have the location and the environment appended to it. The provided name should be all lowercase and one word. e.g. `avd` (for Azure Virtual Desktop)"
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "dcr-")
    error_message = "The name must not start with \"dcr-\". (A prefix of \"dcr-\" will automatically be added by this module when creating the resource.)"
  }
}

variable "location" {
  type        = string
  description = "Azure region short name (CAF). e.g. `eus` for East US. See: https://www.jlaundry.nz/2022/azure_region_abbreviations/"
  nullable    = false
  validation {
    condition     = contains(keys(module.common_constants.region_short_name_to_long_name), var.location)
    error_message = "The location must be one of: ${join(", ", keys(module.common_constants.region_short_name_to_long_name))}"
  }
}

variable "environment" {
  type        = string
  description = "Environment shortname"
  nullable    = false
  validation {
    condition     = contains(module.common_constants.valid_environments, var.environment)
    error_message = "The environment must be one of: ${join(", ", module.common_constants.valid_environments)}"
  }
}

variable "collection_rules" {
  description = "Configuration of rules containing data_source, destination and data_flows to compose a complete data collection rule. Data_Sources can be omitted if the rule is meant to be used via direct calls to the provisioned endpoint."
  type = list(object({
    data_sources = optional(object({
      windows_event_log = optional(object({
        name           = optional(string)
        streams        = list(string)
        x_path_queries = list(string)
      }))
      iis_log = optional(object({
        name            = optional(string)
        streams         = list(string)
        log_directories = list(string)
      }))
      syslog = optional(object({
        name           = optional(string)
        facility_names = list(string) # can be one or many of: "alert" "*" "audit" "auth" "authpriv" "clock" "cron" "daemon" "ftp" "kern" "local5" "local4" "local1" "local7" "local6" "local3" "local2" "local0" "lpr" "mail" "mark" "news" "nopri" "ntp" "syslog" "user" "uucp"
        log_levels     = list(string)
        streams        = list(string)
      }))
      log_file = optional(object({
        name                          = optional(string)
        format                        = string
        file_patterns                 = list(string)
        streams                       = list(string)
        record_start_timestamp_format = string
      }))
      performance_counter = optional(object({
        name                          = optional(string)
        streams                       = list(string)
        scheduled_transfer_period     = string
        sampling_frequency_in_seconds = number
        counter_specifiers            = list(string)
      }))
      extension = optional(list(object({
        name           = optional(string)
        extension_name = string
        extension_json = string
      })))
    }))
    data_flow = object({
      streams            = list(string)
      destinations       = list(string)
      built_in_transform = optional(string)
      output_stream      = optional(string)
      transform_kql      = optional(string)
    })
    destinations = object({
      log_analytics = optional(object({
        workspace_resource_id = string
        name                  = string
      }))
      azure_monitor_metrics = optional(object({
        name = string
      }))
    })
  }))
}

# ------------------
# Optional variables
# ------------------

variable "data_collection_endpoint_id" {
  description = "The resource ID of the Data Collection Endpoint that this rule will be associated to. Required for IIS_Logs, Firewall Logs, Text Logs, Custom Logs, Prometheus Metrics."
  type        = string
  default     = null
}

variable "associations" {
  description = "Data Collection Rule Resource associations. These are the target resource IDs where the rules will be applied."
  type = list(object({
    name                    = optional(string, "configurationAccessEndpoint")
    target_resource_id      = string
    data_collection_rule_id = optional(string)
  }))
  default = []
}

variable "identity" {
  description = "Managed identity configuration."
  type = list(object({
    type         = string                #  Specifies the type of Managed Service Identity that should be configured on this Data Collection Rule. Possible values are `SystemAssigned` and `UserAssigned`.
    identity_ids = optional(set(string)) # Required when `Type` is set to `UserAssigned`. A list of User Assigned Managed Identity IDs to be assigned to this Data Collection Rule. Currently, up to 1 identity is supported.
  }))
  default = []
}

variable "kind" {
  description = "The kind of the Data Collection Rule. Possible values are Linux, Windows, AgentDirectToStore and WorkspaceTransforms. Kind Linux does not allow for windows_event_log data sources. Kind Windows does not allow for syslog data sources. If kind is not specified, all kinds of data sources are allowed."
  type        = string
  default     = null
}

variable "stream_declaration" {
  description = "Stream declaration of custom tables and columns"
  type = list(object({
    stream_name = string # The name of the custom stream. This name should be unique across all stream_declaration blocks and must begin with a prefix of `Custom-`
    columns = list(object({
      name = string
      type = string
    }))
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for the deployment. Tag names are case insensitive, but tag values are case sensitive. The `managedBy = \"terraform\"` tag will automatically be applied in addition to any other tags specified."
  default     = {}
  validation {
    condition = alltrue([
      for tag in var.tags :
      lower(tag) == tag
    ])
    error_message = "All tag names must be in lowercase."
  }
}
