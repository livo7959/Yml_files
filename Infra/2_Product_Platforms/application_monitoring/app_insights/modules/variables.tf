variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Region of the resource group"
  type        = string
}

variable "resource_group_tags" {
  description = "Resource group tags"
  type        = map(string)
}

variable "instances" {
  description = "List of application insights instances"
  type = list(object({
    name                 = string
    workspace_id         = optional(string)
    application_type     = string
    daily_data_cap_in_gb = optional(number, null)
    tags                 = map(string)
  }))
  default = []
}
