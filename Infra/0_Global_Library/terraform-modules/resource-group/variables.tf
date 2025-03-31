# ------------------
# Required variables
# ------------------

variable "name" {
  type        = string
  description = "A name describing what the resource group is for. Note that the real name of the resource will have the location and the environment appended to it. The provided name should be all lowercase and one word. e.g. `avd` (for Azure Virtual Desktop)"
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "rg-")
    error_message = "The name must not start with \"rg-\". (A prefix of \"rg-\" will automatically be added by this module when creating the resource.)"
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

variable "lock_level" {
  description = "Lock level of the resource group. Possible values are `CanNotDelete` and `ReadOnly`. `CanNotDelete` means authorized users are able to read and modify the resources, but not delete. `ReadOnly` means authorized users can only read from a resource, but they can't modify or delete it."
  type        = string
  default     = ""
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly", ""], var.lock_level)
    error_message = "The lock_level value must be either \"CanNotDelete\", \"ReadOnly\" or null. Default is null."
  }
}
