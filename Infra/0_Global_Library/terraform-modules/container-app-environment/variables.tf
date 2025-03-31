# Required Variables
variable "name" {
  type        = string
  description = "The name of the Container Apps Managed Environment. Changing this forces a new resource to be created"
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "cae-")
    error_message = "The name must not start with \"cae-\". (A prefix of \"cae-\" will automatically be added by this module when creating the resource.)"
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group that the Container App Environment should be in. Should be in the format of: `rg-foo`"
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

# Optional Variables
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

variable "workload_profile" {
  description = "The profile of the workload to scope the container app execution. For Workload profile type for the workloads to run on, possible values include Consumption, D4, D8, D16, D32, E4, E8, E16 and E32"
  type = object({
    name                  = string
    workload_profile_type = string
    maximum_count         = number
    minimum_count         = number
  })
  default = null
}

variable "infrastructure_resouce_group_name" {
  description = "Name of the platform-managed resource group created for the Managed Environment to host infrastructure resources. Changing this forces a new resource to be created. Only valid if a workload_profile is specified. If infrastructure_subnet_id is specified, this resource group will be created in the same subscription as infrastructure_subnet_id."
  type        = string
  default     = null
}

variable "infrastructure_subnet_id" {
  description = "The existing Subnet to use for the Container Apps Control Plane. Changing this forces a new resource to be created. The Subnet must have a /21 or larger address space"
  type        = string
  default     = null
}

variable "internal_load_balancer_enabled" {
  description = " Should the Container Environment operate in Internal Load Balancing Mode? Defaults to false. Changing this forces a new resource to be created. Can only be set to true if infrastructure_subnet_id is specified"
  type        = bool
  default     = null
}

variable "zone_redundancy_enabled" {
  description = " Should the Container App Environment be created with Zone Redundancy enabled? Defaults to false. Changing this forces a new resource to be created. can only be set to true if infrastructure_subnet_id is specified"
  type        = bool
  default     = null
}
