variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
variable "name" {
  description = "Name of the action group"
  type        = string
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "ag-")
    error_message = "The name must not start with \"ag-\". (A prefix of \"ag-\" will automatically be added by this module when creating the resource.)"
  }
}

variable "short_name" {
  description = "Short name for the action group, used for SMS messages"
  type        = string
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

variable "tags" {
  description = "Tags of the action group resource"
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

variable "email_receivers" {
  description = "The name of the email receivers"
  type = list(object({
    email_address = string
    name          = string
  }))
  default = []
}
