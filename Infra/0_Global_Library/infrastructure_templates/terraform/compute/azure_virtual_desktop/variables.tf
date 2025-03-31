# Resource Group variables 
variable "rg" {
  type        = string
  description = "Name of the Resource group in which to deploy session host"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
  default     = "eastus"
}

# HostPool variables 
variable "hostpool" {
  type        = string
  description = "Name of the Azure Virtual Desktop host pool"
}

variable "loadbalancer_type" {
  type        = string
  description = "Load balancer type"
  default     = "BreadthFirst"
}

variable "hostpool_type" {
  type        = string
  description = "Hostpool type"
  default     = "Pooled"
}

variable "maximum_sessions_allowed" {
  description = "Max session limit on session hosts"
  default     = "10"
}

# DAG Variables 
variable "dag" {
  type        = string
  description = "Name of the Azure Virtual Desktop workspace"
}

# Workspace Variables 
variable "workspace" {
  type        = string
  description = "Name of the Azure Virtual Desktop workspace"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

# Session Host Variables
variable "rfc3339" {
  type        = string
  description = "Registration token expiration"
  default     = "2024-03-28T12:43:13Z"
}

variable "sh_count" {
  description = "Number of AVD machines to deploy"
  default     = "1"
}

variable "prefix" {
  type        = string
  description = "Prefix of the name of the AVD machine(s)"
  default     = "AVD"
}

variable "vm_size" {
  type        = string
  description = "Size of the machine to deploy"
  default     = "Standard_D16ads_v5" #old sku Standard_D8s_v5"
}

variable "source_image_id" {
  type        = string
  description = "Custom image id"
}
variable "os_storage_account_type" {
  type        = string
  description = "os storage account type"
  default     = "Premium_LRS"
}

variable "custom_rdp_properties" {
  type        = string
  description = "RDP properties"
  default     = "drivestoredirect:s:;audiomode:i:2;videoplaybackmode:i:0;redirectclipboard:i:0;redirectprinters:i:0;devicestoredirect:s:;redirectcomports:i:0;redirectsmartcards:i:0;autoreconnection enabled:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:0;use multimon:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;audiocapturemode:i:0;usbdevicestoredirect:s:*"
}

variable "identity_type" {
  type        = string
  description = "identity type"
  default     = "SystemAssigned"

}

# VM Local Account
variable "local_admin_username" {
  type        = string
  description = "local admin username"
  default     = "lhavdlocaladmin"
}

variable "local_admin_password" {
  type        = string
  description = "local admin password"
  sensitive   = true

}

## Domain Join Ext Variables
variable "domain_name" {
  type        = string
  description = "Name of the domain to join"
  default     = "corp.logixhealth.local"
}

variable "domain_user_upn" {
  type        = string
  description = "Username for domain join (do not include domain name as this is appended)"
  default     = "svc_joindomain" # do not include domain name as this is appended
}

variable "domain_password" {
  type        = string
  description = "Password of the user to authenticate with the domain"
  sensitive   = true
}

variable "ou_path" {
  type        = string
  description = "On Premise AD Organizational Unit path - FS Logix GPOs are scoped via OU"
  default     = "OU=test,OU=VDI,OU=Azure-EastUS,OU=Cloud-Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
}

variable "entra_group" {
  type        = string
  description = "Name of EntraID group to be created in EntraID for users to be added to for Hostpool access"
}

# Data Collection Rules 

variable "dcr_insights_rg" {
  type        = string
  description = "Resource group for data collection rule for Insights"
  default     = "rg-alerts"
}
variable "dcr_insights_name" {
  type        = string
  description = "Name of data collection rule for Insights"
  default     = "microsoft-avdi-eastus"
}
