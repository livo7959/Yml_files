# Application Insights - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
variable "name" {
  description = "Name of the application insights"
  type        = string
}

variable "location" {
  description = "Location of the resource"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "workspace_id" {
  description = "ID of log analytics workspace"
  type        = string
}

variable "application_type" {
  description = "Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this forces a new resource to be created"
  type        = string
}

variable "daily_data_cap_in_gb" {
  description = "Specifies the Application Insights component daily data volume cap in GB"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Tags of the Application Insights resource"
  type        = map(string)
  default     = {}
}
# Standard Web Tests - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_standard_web_test
variable "web_tests" {
  description = "A list of web test configurations"
  type = list(object({
    name          = string
    description   = string
    geo_locations = list(string) #https://learn.microsoft.com/en-us/previous-versions/azure/azure-monitor/app/monitor-web-app-availability#location-population-tags
    enabled       = bool
    frequency     = number
    retry_enabled = bool
    web_test_tags = map(string)
    timeout       = number
    request = object({
      url                              = string
      body                             = optional(string)
      follow_redirects_enabled         = optional(bool, true)
      http_verb                        = optional(string, "GET")
      parse_dependent_requests_enabled = optional(bool, true)
      headers = optional(list(object({
        name  = string
        value = string
      })), [])
    })
    validation_rules = optional(object({
      expected_status_code        = optional(number)
      ssl_cert_remaining_lifetime = optional(number)
      ssl_check_enabled           = optional(bool)
      content_match               = optional(string)
      ignore_case                 = optional(bool)
      pass_if_text_found          = optional(bool)
    }), null)
  }))
  default = []
}

# Smart detection rules - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_smart_detection_rule
variable "smart_detection_rules" {
  description = "A list of smart detection rules"
  type = list(object({
    name                               = string
    enabled                            = optional(bool, true)
    send_emails_to_subscription_owners = optional(bool, false)
    additional_email_recipients        = optional(set(string))
  }))
  default = []
}

# Metric alert - Application Insights availability test - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert

variable "severity" {
  description = "The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4"
  type        = number
  default     = 3
}

variable "enabled" {
  description = "Should this Metric Alert be enabled?"
  type        = bool
  default     = true
}

variable "auto_mitigate" {
  description = "Should the alerts in this Metric Alert be auto resolved?"
  type        = bool
  default     = true
}

variable "failed_location_count" {
  description = "The number of failed locations"
  type        = number
  default     = 1
}

variable "action_group_id" {
  description = "List of action group IDs for alerts"
  type        = list(string)
  default     = []
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

