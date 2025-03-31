virtual_machine_windows_nutanix03 = {
  "METABASE01" = {
    vm_name               = "METABASE01"
    folder                = "Z_NO_BACKUP/POC"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 4096
    scsi_controller_count = 1
    annotation            = "deployed via Terraform"
    network_id            = "dvportgroup-2997402"

    disks = [
      {
        label            = "disk0"
        size             = 50
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 0
      }
    ]
    computer_name = "METABASE01"
    domain_ou     = "OU=IT,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.69"
    ipv4_gateway  = "10.10.33.1"
  }
}

virtual_machine_windows_nutanix04 = {
  "BEDPAUTOSPRT001" = {
    vm_name               = "BEDPAUTOSPRT001"
    folder                = "Infrastructure/IT"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 4096
    scsi_controller_count = 1
    annotation            = "deployed via Terraform"
    network_id            = "dvportgroup-2997402"

    disks = [
      {
        label            = "disk0"
        size             = 80
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 0
      },
      {
        label            = "disk1"
        size             = 100
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 1
      }
    ]
    computer_name = "BEDPAUTOSPRT001"
    domain_ou     = "OU=IT,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.70"
    ipv4_gateway  = "10.10.33.1"
  }

  "BEDPM365DSC001" = {
    vm_name               = "BEDPM365DSC001"
    folder                = "Infrastructure/IT"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 4096
    scsi_controller_count = 1
    annotation            = "deployed via Terraform"
    network_id            = "dvportgroup-2997402"

    disks = [
      {
        label            = "disk0"
        size             = 80
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 0
      }
    ]
    computer_name = "BEDPM365DSC001"
    domain_ou     = "OU=IT,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.71"
    ipv4_gateway  = "10.10.33.1"
  }
}
