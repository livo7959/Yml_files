# -----------
# Datacenters
# -----------

data "vsphere_datacenter" "bedford" {
  name = "Bedford"
}

# ----------
# Datastores
# ----------

data "vsphere_datastore" "datastore_mssql" {
  name          = "MSSQL"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

data "vsphere_datastore" "datastore_production" {
  name          = "PRODUCTION"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

# --------
# Clusters
# --------

data "vsphere_compute_cluster" "cluster_nutanix_03" {
  name          = "Nutanix03"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

data "vsphere_compute_cluster" "cluster_nutanix_04" {
  name          = "Nutanix04"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

# -------------
# Network VLANS
# -------------

data "vsphere_network" "network_vlan_1032" {
  name          = "1032.server.prod-ntnx"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

data "vsphere_network" "network_vlan_1033" {
  name          = "1033.server.prod-ntnx"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

# ------------
# VM Templates
# ------------

data "vsphere_virtual_machine" "vm_template_nutanix03" {
  name          = "W2019Srv-3"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

data "vsphere_virtual_machine" "vm_template_nutanix04" {
  name          = "W2019Srv-2"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

data "vsphere_virtual_machine" "vm_template_linux" {
  name          = "nixos-template"
  datacenter_id = data.vsphere_datacenter.bedford.id
}

# ----------
# VM Folders
# ----------

data "vsphere_folder" "parent" {
  path = "/Bedford/vm"
}
