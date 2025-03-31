# Required variables
variable "name" {
  description = "The name of the metric alert"
  type        = string
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && can(regex(module.common_constants.kebab_case_regex, var.name))
    error_message = "The name must be kebab-case."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  validation {
    condition     = var.resource_group_name != null && can(regex(module.common_constants.kebab_case_regex, var.resource_group_name))
    error_message = "The resource group name must be kebab-case."
  }
  validation {
    condition     = var.resource_group_name != null && startswith(var.resource_group_name, "rg-")
    error_message = "The resource group name must start with \"rg-\"."
  }
}

variable "scopes" {
  description = "A set of strings of resource IDs at which the metric criteria should be applied"
  type        = list(string)
  default     = []
}

variable "action_group_id" {
  description = "Action group ID"
  type        = string
}

# Optional variables

variable "description" {
  description = "The description of the metric alert"
  type        = string
  default     = null
}

variable "severity" {
  description = "The severity of the alert (0, 1, 2, 3, 4)"
  type        = number
  default     = 3
}

variable "enabled" {
  description = "Whether the alert is enabled"
  type        = bool
  default     = true
}

variable "auto_mitigate" {
  description = "Should the alerts in this Metric Alert be auto resolved?"
  type        = bool
  default     = true
}

variable "frequency" {
  description = "The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format. Possible values are PT1M, PT5M, PT15M, PT30M and PT1H. Defaults to PT1M"
  type        = string
  default     = "PT1M"
  # ISO8601 - PT1M = 1min , PT5M =5mins , PT1H = 1hr, etc.
  # https://www.digi.com/resources/documentation/digidocs/90001488-13/reference/r_iso_8601_duration_format.htm
}

variable "window_size" {
  description = "The size of the time window to evaluate over"
  type        = string
  default     = "PT5M"
}

variable "tags" {
  description = "Tags of the Application Insights resource"
  type        = map(string)
  default     = {}
}

variable "target_resource_type" {
  description = "The resource type (e.g. Microsoft.Compute/virtualMachines) of the target resource"
  type        = string
  default     = null
}

variable "target_resource_location" {
  description = "The location of the target resource"
  type        = string
  default     = null
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert
# https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric-near-real-time
# https://learn.microsoft.com/en-us/azure/azure-monitor/app/standard-metrics

variable "criteria" {
  type = list(object({
    metric_namespace = string
    metric_name      = string
    aggregation      = string
    operator         = string
    threshold        = number
    dimension = optional(object({
      name     = string
      operator = string
      values   = list(string)
    }))
  }))
  default     = []
  description = "Optional but one of either criteria, dynamic_criteria or application_insights_web_test_location_availability_criteria must be specified"
}

variable "dynamic_criteria" {
  type = list(object({
    metric_namespace         = string
    metric_name              = string
    aggregation              = string
    operator                 = string
    alert_sensitivity        = string
    evaluation_total_count   = number
    evaluation_failure_count = number
    ignore_data_before       = string
    skip_metric_validation   = bool
    dimension = optional(object({
      name     = string
      operator = string
      values   = list(string)
    }))
  }))
  default     = []
  description = "Optional but one of either criteria, dynamic_criteria or application_insights_web_test_location_availability_criteria must be specified"
}
variable "application_insights_web_test_location_availability_criteria" {
  type = list(object({
    web_test_id           = string
    component_id          = string
    failed_location_count = number
  }))
  default     = []
  description = "Optional but one of either criteria, dynamic_criteria or application_insights_web_test_location_availability_criteria must be specified"
}
