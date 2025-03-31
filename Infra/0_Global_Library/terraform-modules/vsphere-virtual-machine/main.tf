resource "vsphere_virtual_machine" "this" {
  name                    = var.vm_name
  resource_pool_id        = var.resource_pool_id
  datastore_id            = var.datastore_id
  folder                  = var.folder
  num_cpus                = var.num_cpus
  num_cores_per_socket    = var.num_cores_per_socket
  cpu_hot_add_enabled     = var.cpu_hot_add_enabled
  memory                  = var.memory
  memory_hot_add_enabled  = var.memory_hot_add_enabled
  guest_id                = var.guest_id
  scsi_type               = var.scsi_type
  scsi_controller_count   = var.scsi_controller_count
  firmware                = var.firmware
  custom_attributes       = var.custom_attributes
  annotation              = var.annotation
  efi_secure_boot_enabled = var.efi_secure_boot_enabled
  tools_upgrade_policy    = var.tools_upgrade_policy
  network_interface {
    network_id = var.network_id
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      label            = disk.value.label
      size             = disk.value.size
      eagerly_scrub    = disk.value.eagerly_scrub
      thin_provisioned = disk.value.thin_provisioned
      unit_number      = disk.value.unit_number
    }
  }

  clone {
    template_uuid = var.template_uuid
    customize {
      timeout = var.timeout
      dynamic "linux_options" {
        for_each = var.is_windows_image ? [] : [1]
        content {
          host_name    = var.host_name
          domain       = var.domain
          hw_clock_utc = var.hw_clock_utc
          time_zone    = var.time_zone_linux
        }
      }
      dynamic "windows_options" {
        for_each = var.is_windows_image ? [1] : []
        content {
          computer_name         = var.computer_name
          admin_password        = var.admin_password
          join_domain           = var.join_domain
          domain_admin_user     = var.domain_admin_user
          domain_admin_password = var.domain_admin_password
          domain_ou             = var.domain_ou
          time_zone             = var.time_zone_windows
        }
      }
      network_interface {
        ipv4_address = var.ipv4_address
        ipv4_netmask = var.ipv4_netmask

      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.dns_server_list
    }
  }

  # Advanced options
  hv_mode           = var.hv_mode      # TF defaults to hvAuto
  ept_rvi_mode      = var.ept_rvi_mode # TF defaults to automatic
  vbs_enabled       = var.vbs_enabled
  vvtd_enabled      = var.vvtd_enabled
  nested_hv_enabled = var.nested_hv_enabled



  # Workaround: https://github.com/hashicorp/terraform-provider-vsphere/issues/1902
  lifecycle {
    ignore_changes = [hv_mode, ept_rvi_mode, custom_attributes]
  }
}
