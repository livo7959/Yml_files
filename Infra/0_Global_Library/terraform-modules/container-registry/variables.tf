# Required Variables

variable "name" {
  description = "Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created"
  type        = string
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "lhcr")
    error_message = "The name must not start with \"lhcr\". (A prefix of \"lhcr\" will automatically be added by this module when creating the resource.)"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created"
  type        = string
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
variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
  type        = string
  validation {
    condition     = contains(keys(module.common_constants.region_short_name_to_long_name), var.location)
    error_message = "The location must be one of: ${join(", ", keys(module.common_constants.region_short_name_to_long_name))}"
  }
}

variable "sku" {
  description = " The SKU name of the container registry"
  type        = string
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The SKU must be one of the following: Basic, Standard, or Premium"
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

# Optional Variables

variable "admin_enabled" {
  type        = bool
  description = "Specifies whether the admin user is enabled"
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for the container registry"
  default     = true
}

variable "zone_redundancy_enabled" {
  type        = bool
  description = "Whether zone redundancy is enabled for this container registry"
  default     = false
}

variable "network_rule_bypass_option" {
  type        = string
  description = "Whether to allow trusted Azure services to access a network restricted Container Registry"
  default     = "AzureServices"
  validation {
    condition     = contains(["None", "AzureServices"], var.network_rule_bypass_option)
    error_message = "The network_rule_bypass_option must be either 'None' or 'AzureServices'"
  }
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

variable "georeplications" {
  description = "List of geo-replication locations for the container registry. Only supported on new resources with the Premium SKU. Also cannot contain the location where the Container Registry exists "
  type = list(object({
    location                  = string
    regional_endpoint_enabled = optional(bool, false)
    zone_redundancy_enabled   = optional(bool, false)
    tags                      = optional(map(string))
  }))
  default = null
}

variable "network_rule_set" {
  description = "Network rules"
  type = list(object({
    default_action = optional(string)
    ip_rule = optional(list(object({
      action   = string
      ip_range = string
    })), [])
  }))
  default = null
}

variable "identity" {
  description = "Identity"
  type = list(object({
    type         = string
    identity_ids = optional(set(string), null)
  }))
  default = null
}
