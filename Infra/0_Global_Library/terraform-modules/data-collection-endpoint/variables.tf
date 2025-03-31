# ------------------
# Required variables
# ------------------

variable "resource_group" {
  type        = string
  description = "Name of the resource group that the data collection endpoint should be in. Should be in the format of: `rg-foo`"
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
  description = "A name describing what the data collection endpoint is for. Note that the real name of the resource will have the location and the environment appended to it. The provided name should be all lowercase and one word. e.g. `avd` (for Azure Virtual Desktop)"
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "dce-")
    error_message = "The name must not start with \"dce-\". (A prefix of \"dce-\" will automatically be added by this module when creating the resource.)"
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


# ------------------
# Optional variables
# ------------------

variable "kind" {
  type        = string
  description = "Default is null - which allows Windows and Linux, possible values are `Windows` and ` Linux`."
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public access is enabled for the DCE. Default is true. False will require AMPLS (Private Link) and/or other Network Isolation configurations."
  default     = true
}

variable "associations" {
  description = "Data Collection Endpoint resource associations. These are the target resource IDs where the rules will be applied."
  type = list(object({
    target_resource_id          = string
    data_collection_endpoint_id = optional(string)
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
