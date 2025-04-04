module "vm-windows-nutanix03" {
  source                 = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/vsphere-virtual-machine?depth=1&ref=vsphere-virtual-machine-1.0.0"
  for_each               = var.virtual_machine_windows_nutanix03
  is_windows_image       = true
  vm_name                = each.value.vm_name
  resource_pool_id       = data.vsphere_compute_cluster.cluster_nutanix_03.resource_pool_id
  datastore_id           = data.vsphere_datastore.datastore_mssql.id
  folder                 = each.value.folder
  num_cpus               = each.value.num_cpus
  num_cores_per_socket   = each.value.num_cores_per_socket
  cpu_hot_add_enabled    = true
  memory                 = each.value.memory
  memory_hot_add_enabled = true
  guest_id               = data.vsphere_virtual_machine.vm_template_nutanix03.guest_id
  scsi_type              = data.vsphere_virtual_machine.vm_template_nutanix03.scsi_type
  scsi_controller_count  = each.value.scsi_controller_count
  firmware               = "efi"
  annotation             = each.value.annotation
  network_id             = each.value.network_id
  disks                  = each.value.disks
  template_uuid          = data.vsphere_virtual_machine.vm_template_nutanix03.id
  timeout                = 30
  computer_name          = each.value.computer_name
  admin_password         = var.local_admin_password
  join_domain            = "corp.logixhealth.local"
  domain_admin_user      = "svc_jdvmware"
  domain_admin_password  = var.domain_join_password
  domain_ou              = each.value.domain_ou
  ipv4_address           = each.value.ipv4_address
  ipv4_netmask           = 24
  ipv4_gateway           = each.value.ipv4_gateway
  dns_server_list        = ["10.10.32.202", "10.10.32.205"]
}

module "vm-windows-nutanix04" {
  source                 = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/vsphere-virtual-machine?depth=1&ref=vsphere-virtual-machine-1.0.0"
  for_each               = var.virtual_machine_windows_nutanix04
  is_windows_image       = true
  vm_name                = each.value.vm_name
  resource_pool_id       = data.vsphere_compute_cluster.cluster_nutanix_04.resource_pool_id
  datastore_id           = data.vsphere_datastore.datastore_production.id
  folder                 = each.value.folder
  num_cpus               = each.value.num_cpus
  num_cores_per_socket   = each.value.num_cores_per_socket
  cpu_hot_add_enabled    = true
  memory                 = each.value.memory
  memory_hot_add_enabled = true
  guest_id               = data.vsphere_virtual_machine.vm_template_nutanix04.guest_id
  scsi_type              = data.vsphere_virtual_machine.vm_template_nutanix04.scsi_type
  scsi_controller_count  = each.value.scsi_controller_count
  firmware               = "efi"
  annotation             = each.value.annotation
  network_id             = each.value.network_id
  disks                  = each.value.disks
  template_uuid          = data.vsphere_virtual_machine.vm_template_nutanix04.id
  timeout                = 30
  computer_name          = each.value.computer_name
  admin_password         = var.local_admin_password
  join_domain            = "corp.logixhealth.local"
  domain_admin_user      = "svc_jdvmware"
  domain_admin_password  = var.domain_join_password
  domain_ou              = each.value.domain_ou
  ipv4_address           = each.value.ipv4_address
  ipv4_netmask           = 24
  ipv4_gateway           = each.value.ipv4_gateway
  dns_server_list        = ["10.10.32.202", "10.10.32.205"]
}

module "vm-linux-nutanix03" {
  source                 = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/vsphere-virtual-machine?depth=1&ref=vsphere-virtual-machine-1.0.0"
  for_each               = var.virtual_machine_linux_nutanix03
  is_windows_image       = false
  vm_name                = each.value.vm_name
  resource_pool_id       = data.vsphere_compute_cluster.cluster_nutanix_03.resource_pool_id
  datastore_id           = data.vsphere_datastore.datastore_mssql.id
  folder                 = each.value.folder
  num_cpus               = each.value.num_cpus
  num_cores_per_socket   = each.value.num_cores_per_socket
  cpu_hot_add_enabled    = true
  memory                 = each.value.memory
  memory_hot_add_enabled = true
  guest_id               = data.vsphere_virtual_machine.vm_template_linux.guest_id
  scsi_type              = data.vsphere_virtual_machine.vm_template_linux.scsi_type
  scsi_controller_count  = each.value.scsi_controller_count
  firmware               = "efi"
  annotation             = each.value.annotation
  network_id             = data.vsphere_network.network_vlan_1033.id
  disks                  = each.value.disks
  template_uuid          = data.vsphere_virtual_machine.vm_template_linux.id
  timeout                = 30
  host_name              = each.value.host_name
  domain                 = "corp.logixhealth.local"
  ipv4_address           = each.value.ipv4_address
  ipv4_netmask           = 24
  ipv4_gateway           = each.value.ipv4_gateway
  dns_server_list        = ["10.10.32.202", "10.10.32.205"]
}

module "vm-linux-nutanix04" {
  source                 = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/vsphere-virtual-machine?depth=1&ref=vsphere-virtual-machine-1.0.0"
  for_each               = var.virtual_machine_linux_nutanix04
  is_windows_image       = false
  vm_name                = each.value.vm_name
  resource_pool_id       = data.vsphere_compute_cluster.cluster_nutanix_04.resource_pool_id
  datastore_id           = data.vsphere_datastore.datastore_mssql.id
  folder                 = each.value.folder
  num_cpus               = each.value.num_cpus
  num_cores_per_socket   = each.value.num_cores_per_socket
  cpu_hot_add_enabled    = true
  memory                 = each.value.memory
  memory_hot_add_enabled = true
  guest_id               = data.vsphere_virtual_machine.vm_template_linux.guest_id
  scsi_type              = data.vsphere_virtual_machine.vm_template_linux.scsi_type
  scsi_controller_count  = each.value.scsi_controller_count
  firmware               = "efi"
  annotation             = each.value.annotation
  network_id             = data.vsphere_network.network_vlan_1033.id
  disks                  = each.value.disks
  template_uuid          = data.vsphere_virtual_machine.vm_template_linux.id
  timeout                = 30
  host_name              = each.value.host_name
  domain                 = "corp.logixhealth.local"
  ipv4_address           = each.value.ipv4_address
  ipv4_netmask           = 24
  ipv4_gateway           = each.value.ipv4_gateway
  dns_server_list        = ["10.10.32.202", "10.10.32.205"]
}
