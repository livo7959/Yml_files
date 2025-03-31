variable "vm_name" {
  description = "VM name in Vcenter"
  type        = string
}

variable "resource_pool_id" {
  type        = string
  description = "Resource pool id"
}

variable "datastore_id" {
  type        = string
  description = "Datastore id"
}

variable "folder" {
  type        = string
  description = "VMware folder"
}

variable "num_cpus" {
  type        = string
  description = "Numbers of CPU to provision"
}

variable "num_cores_per_socket" {
  description = "The number of cores to distribute among the CPUs in this virtual machine. If specified, the value supplied to num_cpus must be evenly divisible by this value."
  type        = number
  default     = 1
}
variable "cpu_hot_add_enabled" {
  description = "Allow CPUs to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "memory" {
  type        = string
  description = "Numbers of Memory to provision"
}

variable "memory_hot_add_enabled" {
  description = "Allow memory to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "guest_id" {
  type        = string
  description = "Guest ID"
}

variable "scsi_type" {
  type        = string
  description = "SCSI type"
}

variable "scsi_controller_count" {
  type        = string
  description = "SCSI controller count"
}

variable "firmware" {
  type        = string
  description = "Firmware type"
  default     = "efi" #TF defaults to BIOS 
}

variable "custom_attributes" {
  description = "Map of custom attribute ids to attribute value strings to set for virtual machine."
  type        = map(any)
  default     = null
}

variable "annotation" {
  description = "Notes field."
  default     = "Deployed via Terraform"
}

variable "efi_secure_boot_enabled" {
  type        = bool
  description = "Use this option to enable EFI secure boot when the firmware type is set to is efi"
  default     = true
}

variable "tools_upgrade_policy" {
  type        = string
  description = "VMware tools upgrade policy"
  default     = "upgradeAtPowerCycle"
}

# NIC 
variable "network_id" {
  type        = string
  description = "Network ID"
}

# Disk MAP
variable "disks" {
  type = list(object({
    label            = string
    size             = number
    eagerly_scrub    = optional(bool, false) # both eagerly scrub and thin provisioned cannot be true
    thin_provisioned = optional(bool, true)
    unit_number      = number
  }))
  description = "Map list of disks for the virtual machine"
}

# Clone Specs
variable "template_uuid" {
  type        = string
  description = "Template UUID"
}

variable "timeout" {
  type        = number
  description = "timeout in minutes for vm clone to complete"
  default     = 15
}
# Linux Customization
variable "host_name" {
  description = "Linux host name"
  type        = string
  default     = null
}
variable "hw_clock_utc" {
  description = "Tells the operating system that the hardware clock is set to UTC - TF default is true"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Domain name for the machine"
  type        = string
  default     = null
}

variable "time_zone_linux" {
  description = "Time zone of Linux VM"
  type        = string
  default     = "America/New_York"
}

# Windows Customization 
variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based"
  type        = bool
  default     = false
}

variable "computer_name" {
  type        = string
  description = "Computer name in Windows"
  default     = null
}

variable "admin_password" {
  type        = string
  description = "Local administrator password, LAPS will take over"
  default     = null
}

variable "join_domain" {
  type        = string
  description = "Domain to join"
  default     = "corp.logixhealth.local"
}

variable "domain_admin_user" {
  type        = string
  description = "Domain account used to join domain"
  default     = null
}

variable "domain_admin_password" {
  type        = string
  description = "Password for account to join domain"
  default     = null
}

variable "domain_ou" {
  type        = string
  description = "Target OU"
  default     = null
}

variable "ipv4_address" {
  type        = string
  description = "IP address of VM"
}

variable "ipv4_netmask" {
  type        = string
  description = "Netmask size"
  default     = "24"
}

variable "ipv4_gateway" {
  type        = string
  description = " Gateway IP address"
}

variable "dns_server_list" {
  type        = list(string)
  description = " List of DNS servers "
  default     = ["10.10.32.202", "10.10.32.205"]
}

variable "time_zone_windows" {
  description = "The new time zone for the windows virtual machine."
  default     = 35
}

# Advanced Options
variable "hv_mode" {
  description = "The (non-nested) hardware virtualization setting for this virtual machine. Can be one of hvAuto, hvOn, or hvOff. - TF default: hvAuto"
  type        = string
  default     = null
}

variable "ept_rvi_mode" {
  description = "The EPT/RVI (hardware memory virtualization) setting for this virtual machine. Can be one of automatic, on, or , off - TF default: automatic"
  type        = string
  default     = null
}

variable "vbs_enabled" {
  description = "Enable Virtualization Based Security. Requires firmware to be efi. In addition, vvtd_enabled, nested_hv_enabled, and efi_secure_boot_enabled must all have a value of true"
  type        = bool
  default     = true
}

variable "vvtd_enabled" {
  description = "Enable Intel Virtualization Technology for Directed I/O for the virtual machine."
  type        = bool
  default     = true
}

variable "nested_hv_enabled" {
  description = "Enable nested hardware virtualization on the virtual machine, facilitating nested virtualization in the guest operating system."
  type        = bool
  default     = true
}
