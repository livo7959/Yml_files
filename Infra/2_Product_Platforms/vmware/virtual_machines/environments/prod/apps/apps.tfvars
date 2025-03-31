virtual_machine_windows_nutanix04 = {
  "BEDDBICDN001" = {
    vm_name               = "BEDPBICDN001"
    folder                = "Business/BI"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 8192
    scsi_controller_count = 1
    annotation            = "deployed via the Terraform"
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
    computer_name = "BEDPBICDN001"
    domain_ou     = "OU=Apps,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.45"
    ipv4_gateway  = "10.10.33.1"
  },

  "BEDPAUTO019" = {
    vm_name               = "BEDPAUTO019"
    folder                = "Business/Automation"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 8192
    scsi_controller_count = 1
    annotation            = "deployed via the Terraform"
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
    computer_name = "BEDPAUTO019"
    domain_ou     = "OU=Automation,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.82"
    ipv4_gateway  = "10.10.33.1"
  },

  "BEDPAUTO020" = {
    vm_name               = "BEDPAUTO020"
    folder                = "Business/Automation"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 8192
    scsi_controller_count = 1
    annotation            = "deployed via the Terraform"
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
    computer_name = "BEDPAUTO020"
    domain_ou     = "OU=Automation,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.83"
    ipv4_gateway  = "10.10.33.1"
  },

  # Recreated 2/7/25
  "BEDPAUTO021" = {
    vm_name               = "BEDPAUTO021"
    folder                = "Business/Automation"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 8192
    scsi_controller_count = 1
    annotation            = "deployed via the Terraform"
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
    computer_name = "BEDPAUTO021"
    domain_ou     = "OU=Automation,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.84"
    ipv4_gateway  = "10.10.33.1"
  }
}
