variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Region of the resource group"
  type        = string
}

variable "tags" {
  description = "Resource group tags"
  type        = map(string)
}
