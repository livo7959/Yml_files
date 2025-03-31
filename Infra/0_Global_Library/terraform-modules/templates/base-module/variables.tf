# ------------------
# Required variables
# ------------------

variable "name" {
  type        = string
  description = "The name of the resource. Please obtain the resource abbreviation from https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations"
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "resource-abbreviation") #Insert the resource abbreviation in the condition and error message
    error_message = "The name must not start with \"resource-abbreviation-\". (A prefix of \"resource-abbreviation-\" will automatically be added by this module when creating the resource.)"
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group. Should be in the format of: `rg-foo`"
  nullable    = false
  validation {
    condition     = var.resource_group_name != null && can(regex(module.common_constants.kebab_case_regex, var.resource_group_name))
    error_message = "The resource group must be kebab-case."
  }
  validation {
    condition     = var.resource_group_name != null && startswith(var.resource_group_name, "rg-")
    error_message = "The resource group must start with \"rg-\"."
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

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
  type        = string
  validation {
    condition     = contains(keys(module.common_constants.region_short_name_to_long_name), var.location)
    error_message = "The location must be one of: ${join(", ", keys(module.common_constants.region_short_name_to_long_name))}"
  }
}

# ------------------
# Optional variables
# ------------------

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
  validation {
    condition = alltrue([
      for tag in var.tags :
      lower(tag) == tag
    ])
    error_message = "All tag names must be in lowercase"
  }
}
