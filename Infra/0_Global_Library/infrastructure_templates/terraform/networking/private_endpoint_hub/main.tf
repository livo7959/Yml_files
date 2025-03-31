data "azurerm_resource_group" "rg_pep" {
  name = "rg-private-endpoint-eus-001"
}

data "azurerm_resource_group" "rg_dns_zone" {
  name = "rg-net-hub-001"
}

data "azurerm_subnet" "subnet" {
  for_each = { for i, endpoint in var.endpoints : i => endpoint }

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg_pep.name
}

data "azurerm_private_dns_zone" "existing_dns_zone" {
  for_each = { for i, endpoint in var.endpoints : i => endpoint }

  name                = each.value.dns_zone
  resource_group_name = data.azurerm_resource_group.rg_dns_zone.name
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = { for i, endpoint in var.endpoints : i => endpoint }

  name                          = each.value.name
  resource_group_name           = data.azurerm_resource_group.rg_pep.name
  location                      = data.azurerm_resource_group.rg_pep.location
  subnet_id                     = data.azurerm_subnet.subnet[each.key].id
  custom_network_interface_name = "nic-${each.value.name}"

  private_service_connection {
    name                           = "${each.value.name}-connection"
    is_manual_connection           = each.value.is_manual_connection
    request_message                = each.value.is_manual_connection ? each.value.request_message : null
    private_connection_resource_id = each.value.target_resource
    subresource_names              = each.value.subresource_names
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.existing_dns_zone[each.key].id]
  }
}
