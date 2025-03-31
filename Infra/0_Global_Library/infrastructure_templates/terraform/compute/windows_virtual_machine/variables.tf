# Resource group variables 
variable "rg" {
  type        = string
  description = "Resource group name"
}
variable "rg_location" {
  type        = string
  description = "Resource group location"
  default     = "EastUS"
}

# Network interface card variables 
variable "private_ip_address_allocation" {
  type        = string
  description = "Private IP address allocation "
  default     = "Dynamic"
}

# Virtual machine variables 
variable "vm_name" {
  type        = string
  description = "VM name"
}

variable "vm_size" {
  type        = string
  description = "Size of the machine to deploy"
  default     = "Standard_DS2_v2"
}

variable "os_disk_caching" {
  type        = string
  description = "Prefix name of vm"
  default     = "ReadWrite"
}

variable "source_image_publisher" {
  type        = string
  description = "Source Image Publisher"
  default     = "MicrosoftWindowsServer"
}

variable "source_image_offer" {
  type        = string
  description = "Source image offer"
  default     = "WindowsServer"
}

variable "source_image_sku" {
  type        = string
  description = "Source image SKU"
  default     = "2019-Datacenter"
}

variable "source_image_version" {
  type        = string
  description = "Source image version"
  default     = "latest"
}

variable "storage_account_uri" {
  type        = string
  description = "Storage account uri for boot diagnostics"
  default     = null
}

variable "os_storage_account_type" {
  type        = string
  description = "Size of the machine to deploy"
  default     = "StandardSSD_LRS"
}

variable "availability_zone" {
  type        = number
  description = "Availabilty zone 1,2,3"
  default     = 1
}

# Not enabled for Sandbox subscription - Set to false for Sandbox sub
variable "encryption_at_host_enabled" {
  type        = bool
  description = "Encryption at host enabled"
  default     = true
}

# Default to false , only supported on 2022 Server OS 
variable "hotpatching_enabled" {
  type        = bool
  description = "Hot patching enabled"
  default     = false
}

# Trusted launch settings 
# Not supported for 2019 OS  check link for supported sizes for trusted launch https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch 
# run : az vm image show --urn "MicrosoftWindowsServer:WindowsServer:2019-datacenter:latest"   
# run : az vm image show --urn "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest"
# No trusted lauch in results - https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch-faq?tabs=cli#deployment  
variable "secure_boot_enabled" {
  type        = bool
  description = "Secure boot enabled"
  default     = false
}
variable "vtpm_enabled" {
  type        = bool
  description = "Virtual TPM enabled"
  default     = false
}

# VM Local Account
variable "local_admin_username" {
  type        = string
  description = "Local admin username"
}

variable "local_admin_password" {
  type        = string
  description = "Local admin password"
  sensitive   = true
}

# Network variables 
variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

# Data Disk Variables
variable "data_disk_config" {
  type = map(object({
    name                           = string
    data_disk_storage_account_type = optional(string, "StandardSSD_LRS")
    create_option                  = optional(string, "Empty")
    disk_size_gb                   = optional(number, 32)
    caching                        = optional(string, "ReadWrite")
    lun                            = number

  }))
  default     = {}
  description = "MAP variable for data disk config"
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
  description = "Default on premise AD computer organizational unit path "
  default     = "OU=Tier1-Servers,OU=Azure-EastUS,OU=Cloud-Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
}

