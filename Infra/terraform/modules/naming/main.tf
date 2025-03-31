locals {
  internals = {
    nat_gateway_prefix            = "ngw"
    network_interface_prefix      = "nic"
    network_security_group_prefix = "nsg"
    private_endpoint_prefix       = "pep"
    public_ip_prefix              = "pip"
    rg_prefix                     = "rg"
    role_definition_prefix        = "lh"
    subnet_prefix                 = "snet"
    suffix = {
      container_registry = var.env
      storage_account    = var.env
    }
    virtual_network_prefix = "vnet"
  }
  resources = {
    cdn_profile                       = "${var.name}"
    container_app                     = "${var.name}"
    container_app_managed_environment = "${var.name}"
    container_registry                = "${var.name}"
    databricks                        = "${var.name}"
    data_factory                      = "${var.name}"
    key_vault                         = "${var.name}"
    nat_gateway                       = "${local.internals.nat_gateway_prefix}-${var.name}"
    network_interface                 = "${local.internals.network_interface_prefix}-${var.name}"
    network_security_group            = "${local.internals.network_security_group_prefix}-${var.name}-${module.location_map.location_shortname}"
    private_endpoint                  = "${local.internals.private_endpoint_prefix}-${var.name}"
    public_ip                         = "${local.internals.public_ip_prefix}-${var.name}"
    resource_group                    = "${local.internals.rg_prefix}-${var.name}"
    role_definition                   = "${local.internals.role_definition_prefix}-${var.name}"
    service_bus                       = "${var.name}"
    storage_account                   = "${var.name}"
    subnet                            = "${local.internals.subnet_prefix}-${var.name}-${module.location_map.location_shortname}"
    virtual_network                   = "${local.internals.virtual_network_prefix}-${var.name}-${module.location_map.location_shortname}"
  }
}

module "location_map" {
  source   = "../location_mapping"
  location = var.location
}
