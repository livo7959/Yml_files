# ServiceBus Namespace variables
variable "environment" {
  type        = string
  description = "Environment shortname"
  nullable    = false
  validation {
    condition     = contains(module.common_constants.valid_environments, var.environment)
    error_message = "The environment must be one of: ${join(", ", module.common_constants.valid_environments)}"
  }
}

variable "namespace_name" {
  description = " Specifies the name of the ServiceBus Namespace resource . Changing this forces a new resource to be created"
  type        = string
  validation {
    condition     = var.namespace_name != null && can(regex(module.common_constants.lowercase_regex, var.namespace_name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.namespace_name != null && !startswith(var.namespace_name, "sbns-")
    error_message = "The name must not start with \"sbns-\". (A prefix of \"sbns-\" will automatically be added by this module when creating the resource.)"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the namespace"
  type        = string
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
  description = "Defines which tier to use. Options are Basic, Standard or Premium. Please note that setting this field to Premium will force the creation of a new resource. Topics can only be created in Namespaces with a SKU of standard or higher"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "Specifies the capacity. When sku is Premium, capacity can be 1, 2, 4, 8 or 16. When sku is Basic or Standard, capacity can be 0 only"
  type        = number
  default     = null
}

variable "premium_messaging_partitions" {
  description = "Specifies the number messaging partitions. Only valid when sku is Premium and the minimum number is 1. Possible values include 0, 1, 2, and 4. Defaults to 0 for Standard, Basic namespace. Changing this forces a new resource to be created"
  type        = number
  default     = null
}

variable "local_auth_enabled" {
  description = "Whether or not SAS authentication is enabled for the Service Bus namespace. Microsoft recommends RBAC with EntraID"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Is public network access enabled for the Service Bus Namespace?"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "The minimum supported TLS version for this Service Bus Namespace. Valid values are: 1.0, 1.1 and 1.2"
  type        = string
  default     = "1.2"
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

variable "network_rule_set" {
  description = "Network rule set for the Service Bus Namespace. Only available for Premium namespaces/SKU"
  type = map(object({
    default_action                = string
    public_network_access_enabled = bool
    trusted_services_allowed      = bool
    ip_rules                      = list(string)
    network_rules = object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = bool
    })
  }))
  default = {}
}

variable "identity" {
  description = "The managed identity assigned to the Service Bus Namespace"
  type = map(object({
    type         = string
    identity_ids = optional(list(string), [])
  }))
  default = {}
}
# ServiceBus Queue variables - Using terraform defaults
variable "queues" {
  description = "Map of ServiceBus queues configurations"
  type = map(object({
    lock_duration                           = optional(string, "PT1M") #1min
    max_message_size_in_kilobytes           = optional(number, null)
    max_size_in_megabytes                   = optional(number, null) #must be either 1024,2048,3072,4096,or 5120
    requires_duplicate_detection            = optional(bool, false)
    requires_session                        = optional(bool, false)
    default_message_ttl                     = optional(string, null)
    dead_lettering_on_message_expiration    = optional(bool, false)
    duplicate_detection_history_time_window = optional(string, "PT10M") #10mins
    max_delivery_count                      = optional(number, 10)
    status                                  = optional(string, "Active")
    batched_operations_enabled              = optional(bool, true)
    auto_delete_on_idle                     = optional(string, null)
    partitioning_enabled                    = optional(bool, false)
    express_enabled                         = optional(bool, false)
    forward_to                              = optional(string, null)
    forward_dead_lettered_messages_to       = optional(string, null)
  }))
  default = {}
}

# ServiceBus Topic and Subscription variables - Using terraform defaults
variable "topics" {
  description = "Map of topics with their configurations and subscriptions"
  type = map(object({
    status                                  = optional(string, "Active")
    auto_delete_on_idle                     = optional(string, "P10675199DT2H48M5.4775807S") #10,675,199 days and so on - basically will never automatically be deleted
    default_message_ttl                     = optional(string, "P10675199DT2H48M5.4775807S")
    duplicate_detection_history_time_window = optional(string, "PT10M")
    batched_operations_enabled              = optional(bool, null)
    express_enabled                         = optional(bool, null)
    partitioning_enabled                    = optional(bool, null)
    max_message_size_in_kilobytes           = optional(number, null)
    max_size_in_megabytes                   = optional(number, 5120)
    requires_duplicate_detection            = optional(bool, false)
    support_ordering                        = optional(bool, null)
    subscriptions = map(object({
      max_delivery_count                        = optional(number, 10)
      auto_delete_on_idle                       = optional(string, null)
      default_message_ttl                       = optional(string, null)
      lock_duration                             = optional(string, "PT1M")
      dead_lettering_on_message_expiration      = optional(bool, false)
      dead_lettering_on_filter_evaluation_error = optional(bool, false)
      batched_operations_enabled                = optional(bool, false)
      requires_session                          = optional(bool, false)
      forward_to                                = optional(string, null)
      forward_dead_lettered_messages_to         = optional(string, null)
      status                                    = optional(string, "Active")
      client_scoped_subscription_enabled        = optional(bool, false)
      client_scoped_subscription = optional(object({
        client_id                               = string
        is_client_scoped_subscription_shareable = optional(bool, false)
      }), null)
    }))
  }))
  default = {}
}
