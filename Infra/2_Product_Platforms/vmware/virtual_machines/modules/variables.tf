variable "vcenter_password" {
  description = "vCenter password"
  type        = string
}
variable "local_admin_password" {
  description = "Temp local admin password, LAPS will take over once GPO applies"
  type        = string
}

variable "domain_join_password" {
  description = "Password for account used to join domain"
  type        = string
}

variable "virtual_machine_windows_nutanix03" {
  description = "List of vms"
  type = map(object({
    vm_name               = string
    folder                = string
    num_cpus              = string
    num_cores_per_socket  = number
    memory                = number
    scsi_controller_count = number
    annotation            = string
    network_id            = string
    disks = list(object({
      label            = string
      size             = number
      eagerly_scrub    = optional(bool, false) # both eagerly scrub and thin provisioned cannot be true
      thin_provisioned = optional(bool, true)
      unit_number      = number
    }))
    computer_name = string
    domain_ou     = string
    ipv4_address  = string
    ipv4_gateway  = string
  }))

  default = {}
}

variable "virtual_machine_windows_nutanix04" {
  description = "List of vms"
  type = map(object({
    vm_name               = string
    folder                = string
    num_cpus              = string
    num_cores_per_socket  = number
    memory                = number
    scsi_controller_count = number
    annotation            = string
    network_id            = string
    disks = list(object({
      label            = string
      size             = number
      eagerly_scrub    = optional(bool, false) # both eagerly scrub and thin provisioned cannot be true
      thin_provisioned = optional(bool, true)
      unit_number      = number
    }))
    computer_name = string
    domain_ou     = string
    ipv4_address  = string
    ipv4_gateway  = string
  }))

  default = {}
}

variable "virtual_machine_linux_nutanix03" {
  description = "List of vms"
  type = map(object({
    vm_name               = string
    folder                = string
    num_cpus              = string
    num_cores_per_socket  = number
    memory                = number
    scsi_controller_count = number
    annotation            = string
    network_id            = string
    disks = list(object({
      label            = string
      size             = number
      eagerly_scrub    = optional(bool, false) # both eagerly scrub and thin provisioned cannot be true
      thin_provisioned = optional(bool, true)
      unit_number      = number
    }))
    host_name    = string
    ipv4_address = string
    ipv4_gateway = string
  }))

  default = {}
}

variable "virtual_machine_linux_nutanix04" {
  description = "List of vms"
  type = map(object({
    vm_name               = string
    folder                = string
    num_cpus              = string
    num_cores_per_socket  = number
    memory                = number
    scsi_controller_count = number
    annotation            = string
    disks = list(object({
      label            = string
      size             = number
      eagerly_scrub    = optional(bool, false) # both eagerly scrub and thin provisioned cannot be true
      thin_provisioned = optional(bool, true)
      unit_number      = number
    }))
    host_name    = string
    ipv4_address = string
    ipv4_gateway = string
  }))

  default = {}
}
