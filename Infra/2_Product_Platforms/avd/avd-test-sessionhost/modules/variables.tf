#Variable place holders . Actual values are declared in tfvars file

variable "hp-rgname-location" {
  description = "Location of the Resource Group."
}

variable "hp-rgname" {
  type        = string
  description = "Name of Resource Group"
}


variable "prefix" {
  type        = string
  description = "Prefix of the name of the AVD machine(s)"
}
/*
variable "existhostpoolname" {
  type        = string
  description = "AVDesktop Test HostPool"
}
*/

variable "rfc3339" {
  type        = string
  description = "Registration token expiration for session host addition"
}


variable "avdsub" {
  description = "Network subnet for session hosts"
}

variable "vnetname" {
  description = "Virtual network name"
}
variable "rg-vnet" {
  type        = string
  description = "Resource Group Name for existing Vnet"
}
variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
}

variable "vm_size" {
  description = "SKU of the machine to deploy"

}
variable "local_admin_username" {
  type        = string
  description = "local admin username"
}
variable "source_image_id" {
  type        = string
  description = "Custom image id located in the rg-images resource group"
}
variable "domain_name" {
  type        = string
  description = "Name of the AD domain to join"
}
variable "ou_path" {
  type        = string
  description = "Distinguished path of the OU for session host deployment"
}
variable "domain_user_upn" {
  type        = string
  description = "Domain join service account (do not include domain name as this is appended)"
}

variable "datacollectionrule" {
  description = "Data collection rule that currently exists"
}

variable "rgalerts" {
  description = "Resource group where DCR exists"
}

variable "hostpool" {

}
