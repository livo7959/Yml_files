variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "stracctname" {
  type = string
}

variable "accttier" {
  type = string

}

variable "acctreptype" {
  type = string
}

variable "sharename" {
  type = string
}

variable "avdsub" {
  description = "Network subnet for session hosts"
}

variable "avdsub1" {
  description = "Network subnet for session hosts"
}

variable "avdsub2" {
  description = "Network subnet for session hosts"
}

variable "vnetname" {
  description = "Virtual network name"
}
variable "rg-vnet" {
  type        = string
  description = "Resource Group Name for existing Vnet"
}

variable "sharesize" {
  description = "Size of the share in GB"
}
