virtual_machine_windows_nutanix03 = {
  "BEDITEST001" = {
    vm_name               = "BEDITEST001"
    folder                = "Z_NO_BACKUP/TERRAVM"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 4096
    scsi_controller_count = 1
    annotation            = "deployed via Terraform"
    network_id            = "dvportgroup-2997402"
    disks = [
      {
        label            = "disk0"
        size             = 60
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 0
      },
      {
        label            = "disk1"
        size             = 5
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 1
      }
    ]
    computer_name = "BEDITEST001"
    domain_ou     = "OU=IT,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.29"
    ipv4_gateway  = "10.10.33.1"
  }
}

virtual_machine_windows_nutanix04 = {
  "BEDITEST002" = {
    vm_name               = "BEDITEST002"
    folder                = "Z_NO_BACKUP/TERRAVM"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 4096
    scsi_controller_count = 4
    annotation            = "deployed via Terraform"
    network_id            = "dvportgroup-2997402"
    disks = [
      {
        label            = "disk0"
        size             = 60
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 0
      },
      {
        label            = "disk1"
        size             = 10
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 15
      },
      {
        label            = "disk2"
        size             = 10
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 30
      },
      {
        label            = "disk3"
        size             = 10
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 45
      }
    ]
    computer_name = "BEDITEST002"
    domain_ou     = "OU=IT,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.31"
    ipv4_gateway  = "10.10.33.1"
  }

  "TESTASFE" = {
    vm_name               = "TESTASFE"
    folder                = "Z_NO_BACKUP/Test"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 4096
    scsi_controller_count = 1
    annotation            = "deployed via Terraform, work item 208220"
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
    computer_name = "TESTASFE"
    domain_ou     = "OU=Test,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.38"
    ipv4_gateway  = "10.10.33.1"
  }

  "TESTASDB" = {
    vm_name               = "TESTASDB"
    folder                = "Z_NO_BACKUP/Test"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 4096
    scsi_controller_count = 4
    annotation            = "deployed via Terraform,  work item 208220"
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
        unit_number      = 15
      }
    ]
    computer_name = "TESTASDB"
    domain_ou     = "OU=Test,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.10.33.39"
    ipv4_gateway  = "10.10.33.1"
  }
}
