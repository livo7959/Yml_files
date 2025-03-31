# Required Variables
variable "name" {
  description = "Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol. Changing this forces a new resource to be created."
  type        = string
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "log-")
    error_message = "The name must not start with \"log-\". (A prefix of \"log-\" will automatically be added by this module when creating the resource.)"
  }
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
  type        = string
  validation {
    condition     = contains(keys(module.common_constants.region_short_name_to_long_name), var.location)
    error_message = "The location must be one of: ${join(", ", keys(module.common_constants.region_short_name_to_long_name))}"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created"
  type        = string
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
# Optional Variables
variable "allow_resource_only_permissions" {
  description = "Specifies if the Log Analytics Workspace allow users accessing to data associated with resources they have permission to view, without permission to workspace"
  type        = bool
  default     = false
}

variable "local_authentication_disabled" {
  description = "Specifies if the Log Analytics Workspace should enforce authentication using Entra ID"
  type        = bool
  default     = false
}

variable "sku" {
  description = "Specifies the SKU of the Log Analytics Workspace. Possible values are PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03)"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730"
  type        = number
  default     = null
}

variable "daily_quota_gb" {
  description = "The daily quota in GB for the Log Analytics Workspace"
  type        = number
  default     = -1
}

variable "cmk_for_query_forced" {
  description = " Is Customer Managed Storage mandatory for query management?"
  type        = bool
  default     = false
}

variable "identity" {
  description = "Identity block"
  type = list(object({
    type         = string
    identity_ids = string
  }))
  default = []
}

variable "internet_ingestion_enabled" {
  description = "Should the Log Analytics Workspace support ingestion over the Public Internet?"
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "Should the Log Analytics Workspace support querying over the Public Internet?"
  type        = bool
  default     = true
}

variable "reservation_capacity_in_gb_per_day" {
  description = "The capacity reservation level in GB for this workspace. Possible values are 100, 200, 300, 400, 500, 1000, 2000 and 5000."
  type        = number
  default     = null
}

variable "data_collection_rule_id" {
  description = " The ID of the Data Collection Rule to use for this workspace"
  type        = string
  default     = null
}

variable "immediate_data_purge_on_30_days_enabled" {
  description = "Whether to remove the data in the Log Analytics Workspace immediately after 30 days"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
  validation {
    condition = alltrue([
      for tag in var.tags :
      lower(tag) == tag
    ])
    error_message = "All tag names must be in lowercase."
  }
}

