# ------------------
# Required variables
# ------------------

variable "resource_group_name" {
  type        = string
  description = " The name of the Resource Group in which the Windows Virtual Machine should be exist. Changing this forces a new resource to be created"
  nullable    = false
  validation {
    condition     = var.resource_group_name != null && can(regex(module.common_constants.kebab_case_regex, var.resource_group_name))
    error_message = "The resource group must be kebab-case."
  }
  validation {
    condition     = var.resource_group_name != null && startswith(var.resource_group_name, "rg-")
    error_message = "The resource group must start with \"rg-\"."
  }
}

variable "location" {
  type        = string
  description = "The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created"
  validation {
    condition     = contains(keys(module.common_constants.region_short_name_to_long_name), var.location)
    error_message = "The location must be one of: ${join(", ", keys(module.common_constants.region_short_name_to_long_name))}"
  }
}

variable "virtual_machine_name" {
  type        = string
  description = "The name of the Windows Virtual Machine. Changing this forces a new resource to be created"
  validation {
    condition     = var.virtual_machine_name != null && can(regex(module.common_constants.lowercase_and_numbers_regex, var.virtual_machine_name))
    error_message = "The name must contain only lowercase letters and numbers."
  }
}

variable "environment" {
  type        = string
  description = "Environment shortname"
  nullable    = false
  validation {
    condition     = contains(module.common_constants.valid_environments, var.environment)
    error_message = "The environment must be one of: ${join(", ", module.common_constants.valid_environments)}"
  }
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet where this Network Interface should be located in"
}

# ------------------
# Optional variables
# ------------------

# NIC variables
variable "private_ip_address_allocation" {
  type        = string
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static"
  default     = "Dynamic"
}

# Virtual Machine variables
variable "virtual_machine_size" {
  type        = string
  description = "The SKU which should be used for this Virtual Machine. https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview?tabs=breakdownseries%2Cgeneralsizelist%2Ccomputesizelist%2Cmemorysizelist%2Cstoragesizelist%2Cgpusizelist%2Cfpgasizelist%2Chpcsizelist"
  default     = "Standard_DS2_v2"
}

variable "os_disk_caching" {
  type        = string
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite"
  default     = "ReadWrite"
}

variable "source_image_publisher" {
  type        = string
  description = "Specifies the publisher of the image used to create the virtual machines. Changing this forces a new resource to be created"
  default     = "MicrosoftWindowsServer"
}

variable "source_image_offer" {
  type        = string
  description = "Specifies the offer of the image used to create the virtual machines. Changing this forces a new resource to be created"
  default     = "WindowsServer"
}

variable "source_image_sku" {
  type        = string
  description = "Specifies the SKU of the image used to create the virtual machines. Changing this forces a new resource to be created"
  default     = "2019-Datacenter"
}

variable "source_image_version" {
  type        = string
  description = "Specifies the version of the image used to create the virtual machines. Changing this forces a new resource to be created"
  default     = "latest"
}

variable "storage_account_uri" {
  type        = string
  description = "Storage account uri for boot diagnostics"
  default     = null #Passing a null value will utilize a Managed Storage Account to store Boot Diagnostics
}

variable "os_storage_account_type" {
  type        = string
  description = "Size of the machine to deploy"
  default     = "StandardSSD_LRS"
}

variable "zone" {
  type        = number
  description = "Specifies the Availability Zone in which this Windows Virtual Machine should be located. Changing this forces a new Windows Virtual Machine to be created"
  default     = 1
}

variable "encryption_at_host_enabled" {
  type        = bool
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? (not enabled for Sandbox subscription)"
  default     = true
}

variable "hotpatching_enabled" {
  type        = bool
  description = "Should the VM be patched without requiring a reboot? Only supported on 2022 Server OS"
  default     = false
}

variable "vtpm_enabled" {
  type        = bool
  description = "Virtual TPM enabled"
  default     = false
}
variable "admin_username" {
  type        = string
  description = "Local admin username"
  default     = "lhadmin"
}

variable "admin_password" {
  type        = string
  description = "Local admin password"
  sensitive   = true
}

variable "provision_vm_agent" {
  type        = bool
  description = "Should the Azure VM Agent be provisioned on this Virtual Machine?"
  default     = true
}

variable "vm_agent_platform_updates_enabled" {
  type        = bool
  description = "Specifies whether VMAgent Platform Updates is enabled"
  default     = false
}

variable "enable_automatic_updates" {
  type        = bool
  description = " Specifies if Automatic Updates are Enabled for the Windows Virtual Machine. Changing this forces a new resource to be created"
  default     = true
}

variable "patch_assessment_mode" {
  type        = string
  description = "Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS"
  default     = "ImageDefault"
}

variable "patch_mode" {
  type        = string
  description = "Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS"
  default     = "AutomaticByOS"
}

variable "reboot_setting" {
  type        = string
  description = "Specifies the reboot setting for platform scheduled patching. Possible values are Always, IfRequired and Never"
  default     = "Always"
}

variable "identity" {
  description = "Identity configuration for the Container App"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
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
# Managed Disk variables
variable "data_disk_config" {
  type = map(object({
    data_disk_storage_account_type = optional(string, "StandardSSD_LRS")
    create_option                  = optional(string, "Empty")
    disk_size_gb                   = optional(number, 32)
    caching                        = optional(string, "ReadWrite")

  }))
  default     = {}
  description = "MAP variable for data disk config"
}

# Virtual Machine Extension variables for joining a virtual machine to the domain
variable "enable_domain_join" {
  type        = bool
  description = "Does the Virtual Machine need to be domain joined"
  default     = true
}
variable "domain_name" {
  type        = string
  description = "Name of the domain to join"
  default     = "corp.logixhealth.local"
}

variable "domain_user_upn" {
  type        = string
  description = "Account being used to join virtual machines to the domain (do not include domain name as this is appended)"
  default     = null
}

variable "domain_password" {
  type        = string
  description = "Password of the account used to join the virtual machine to the domain"
  default     = null
  sensitive   = true
}

variable "ou_path" {
  type        = string
  description = " Organizational unit path for the virtual machine"
  default     = "OU=Tier1-Servers,OU=Azure-EastUS,OU=Cloud-Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
}

