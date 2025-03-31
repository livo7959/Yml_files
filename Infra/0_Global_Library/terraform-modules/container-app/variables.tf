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
    condition     = var.name != null && !startswith(var.name, "ca-")
    error_message = "The name must not start with \"ca-\". (A prefix of \"ca-\" will automatically be added by this module when creating the resource.)"
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

variable "container_app_environment_id" {
  type        = string
  description = "The ID of the Container App Environment within which this Container App should exist. Changing this forces a new resource to be created"
}

variable "revision_mode" {
  type        = string
  description = "The revisions operational mode for the Container App. Possible values include Single and Multiple. In Single mode, a single revision is in operation at any given time. In Multiple mode, more than one revision can be active at a time and can be configured with load distribution via the traffic_weight block in the ingress configuration"
}


variable "template" {
  type = object({
    min_replicas    = optional(number, 0)
    max_replicas    = optional(number, 10)
    revision_suffix = optional(string)
    container = list(object({
      name    = string
      image   = string
      cpu     = optional(number, 0.25)
      memory  = optional(string, "0.5Gi")
      args    = optional(list(string), [])
      command = optional(list(string), [])
      env = optional(list(object({
        name        = string
        secret_name = optional(string)
        value       = optional(string)
      })), [])
      liveness_probe = optional(object({
        port                             = number
        transport                        = string
        failure_count_threshold          = optional(number, 3)
        host                             = optional(string)
        initial_delay                    = optional(number, 1)
        interval_seconds                 = optional(number, 10)
        path                             = optional(string)
        termination_grace_period_seconds = optional(number)
        timeout                          = optional(number, 1)
        header                           = optional(map(string))
      }))
      startup_probe = optional(object({
        port                             = number
        transport                        = string
        failure_count_threshold          = optional(number, 3)
        host                             = optional(string)
        initial_delay                    = optional(number, 0)
        interval_seconds                 = optional(number, 10)
        path                             = optional(string)
        termination_grace_period_seconds = optional(number)
        timeout                          = optional(number, 1)
        header                           = optional(map(string))
      }))
      readiness_probe = optional(object({
        port                    = number
        transport               = string
        failure_count_threshold = optional(number, 3)
        host                    = optional(string)
        initial_delay           = optional(number, 0)
        interval_seconds        = optional(number, 10)
        path                    = optional(string)
        sucess_count_threshold  = optional(number, 3)
        timeout                 = optional(number, 1)
        header                  = optional(map(string))
      }))
    }))
    http_scale_rule = optional(list(object({
      name                = string
      concurrent_requests = number
      authentication = optional(list(object({
        secret_name       = string
        trigger_parameter = string
      })), [])
    })), [])
    tcp_scale_rule = optional(list(object({
      name                = string
      concurrent_requests = number
      authentication = optional(list(object({
        secret_name       = string
        trigger_parameter = string
      })), [])
    })), [])
    custom_scale_rule = optional(list(object({
      name             = string
      custom_rule_type = string
      metadata         = map(string)
      authentication = optional(list(object({
        secret_name       = string
        trigger_parameter = string
      })), [])
    })), [])
  })
  description = "Template configuration for the Container App"

}

# Optional Variables

variable "dapr" {
  description = "Dapr configuration for the Container App"
  type = object({
    app_id       = string
    app_port     = optional(number)
    app_protocol = optional(string)
  })
  default = null
}


variable "identity" {
  description = "Identity configuration for the Container App"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "ingress" {
  description = "Ingress configuration for the Container App"
  type = object({
    allow_insecure_connections = optional(bool)
    external_enabled           = optional(bool)
    fqdn                       = optional(string)
    exposed_port               = optional(number)
    target_port                = number
    transport                  = string
    traffic_weight = list(object({
      label           = optional(string)
      latest_revision = optional(bool, false)
      revision_suffix = optional(string)
      percentage      = number
    }))
    ip_security_restriction = optional(list(object({
      action           = string
      description      = optional(string)
      ip_address_range = string
      name             = string
    })), [])
  })
  default = null
}

variable "registry" {
  description = "Container registry connection and authentication configuration for the Container App"
  type = object({
    server               = string
    identity             = optional(string)
    password_secret_name = optional(string)
    username             = optional(string)
  })
  default = null
}

variable "secret" {
  description = "Secrets configuration for the Container App"
  type = object({
    name                = string
    identity            = optional(string)
    key_vault_secret_id = optional(string)
    value               = optional(string)
  })
  default = null
}

variable "workload_profile_name" {
  type        = string
  description = "The name of the Workload Profile in the Container App Environment to place this Container App"
  default     = null
}

variable "max_inactive_revisions" {
  type        = string
  description = "The maximum of inactive revisions allowed for this Container App"
  default     = null
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
    error_message = "All tag names must be in lowercase"
  }
}

