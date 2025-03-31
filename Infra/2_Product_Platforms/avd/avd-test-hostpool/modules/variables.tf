#Variable place holders . Actual values are declared in tfvars file

variable "resource_group_location" {
  description = "Location of the Resource Group."
}

variable "rg_name" {
  type        = string
  description = "Name of Resource Group"
}

variable "workspace" {
  type        = string
  description = "Workspace for Host pool"
}

variable "prefix" {
  type        = string
  description = "Prefix of the name of the AVD machine(s)"
}

variable "hostpool" {
  type        = string
  description = "AVDesktop Test HostPool"
}

variable "custom_rdp_properties" {
  type        = string
  description = "Settings for RDP properties for host pool"
}

variable "maxsessions" {
  description = "Number of sessions per host pool"
}

variable "load_balancer_type" {
  description = "LoadBalancer for Hostpool"
}

variable "published_desktop_name" {
  type        = string
  description = "Name for the published desktop"
}



