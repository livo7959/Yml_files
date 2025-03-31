# `vsphere-virtual-machine`

This is an internal [Terraform](https://www.terraform.io/) module to create a [virtual machine](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-a-virtual-machine) in a [vSphere environment](https://docs.vmware.com/en/VMware-vSphere/index.html).

# Links

- [vSphere - Virtual Machine Administration](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-vm-administration/GUID-55238059-912E-411F-A0E9-A7A536972A91.html)
- [Terraform - Vsphere Virtual Machine](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine)
- [Terraform - Selecting a revision](https://developer.hashicorp.com/terraform/language/modules/sources#selecting-a-revision)
- [GIT - Tagging Basics](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

# Terraform Module Usage

```terraform
# Terraform and Azurerm Provider configuration

terraform {
  required_version = ">=1.6.0"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.105.0"
    }
  }
}
provider "vsphere" {
  user                 = ""
  password             = ""
  vsphere_server       = "bedvcenter02.corp.logixhealth.local"
  allow_unverified_ssl = true
}

provider "azurerm" {
  features {}
}

module "vm-windows" {
  source                 = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/vsphere-virtual-machine?depth=1&ref=vsphere-virtual-machine-1.0.0"
  is_windows_image       = true
  vm_name                = "BEDITEST001"
  resource_pool_id       = data.vsphere_compute_cluster.cluster_nutanix_04.resource_pool_id
  datastore_id           = data.vsphere_datastore.datastore_production.id
  folder                 = "Z_NO_BACKUP/TERRAVM"
  num_cpus               = 2
  num_cores_per_socket   = 1
  cpu_hot_add_enabled    = true
  memory                 = 4096
  memory_hot_add_enabled = true
  guest_id               = data.vsphere_virtual_machine.vm_template_nutanix04.guest_id
  scsi_type              = data.vsphere_virtual_machine.vm_template_nutanix04.scsi_type
  scsi_controller_count  = 1
  firmware               = "efi"
  annotation             = "Deployed via Terraform"
  network_id             = data.vsphere_network.network_vlan_1033.id
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
        size             = 20
        eagerly_scrub    = false
        thin_provisioned = true
        unit_number      = 1
      }
  ]
  template_uuid          = data.vsphere_virtual_machine.vm_template_nutanix04.id
  timeout                = 30
  computer_name          = "BEDITEST001"
  admin_password         = ""
  join_domain            = "corp.logixhealth.local"
  domain_admin_user      = "svc_jdvmware"
  domain_admin_password  = ""
  domain_ou              = "OU=IT,OU=Prod,OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
  ipv4_address           = ""
  ipv4_netmask           = 24
  ipv4_gateway           = ""
  dns_server_list        = ["10.10.32.202", "10.10.32.205"]
}
```

# Module Versioning

We are utilizing [git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) to version this module via [semantic versioning](https://semver.org/).

Example calling the module referencing version 1.0.0:

```teraform
source = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/vsphere-virtual-machine?depth=1&ref=vsphere-virtual-machine-1.0.0"
```

# Virtual Machine Templates

We are currently maintaining image templates manually through VCenter and updating notes on the template. Typically, windows patching is the only modification done on a monthly basis.

## Windows Server 2019

Currently have two Windows Server 2019 templates on each cluster for faster deployment.

- W2019srv-2 (Nutanix04)
- W2019srv-3 (Nutanix03)

## Linux Ubuntu

- Ubuntu-22.04 (Nutanix04)
- nixos-template (Nutanix04)

# Data Disks

## SQL Server Data Disks

Increment unit number in disk by 15 to separate SCSI controllers

Example:

```terraform
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
```
