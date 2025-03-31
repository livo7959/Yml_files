virtual_machine_windows_nutanix03 = {
  "BEDDBICDN001" = {
    vm_name               = "BEDDBICDN001"
    folder                = "Business/BI"
    num_cpus              = 2
    num_cores_per_socket  = 1
    memory                = 8192
    scsi_controller_count = 1
    annotation            = "deployed via Terraform"
    network_id            = "dvportgroup-2878444"
    disks = [
      {
        label            = "disk0"
        size             = 90
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 0
      }
    ]
    computer_name = "BEDDBICDN001"
    domain_ou     = "OU=Apps,OU=Dev,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    ipv4_address  = "10.0.25.21"
    ipv4_gateway  = "10.0.25.254"
  }
}