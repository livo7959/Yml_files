output "virtual_network_id" {
  description = "Virtual network ID"
  value       = azurerm_virtual_network.this.id
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.this.name
}

output "nsg_output" {
  description = "Network security group"
  value = {
    for subnet_key, subnet_value in var.subnets : subnet_key => {
      name           = lower("nsg-${subnet_key}")
      id             = azurerm_network_security_group.this[subnet_key].id
      security_rules = subnet_value.nsg_rules
    }
  }
}

output "route_table_id" {
  description = "ID of the route table"
  value       = local.deploy_route_table ? azurerm_route_table.this[0].id : null
  depends_on  = [azurerm_route_table.this]
}

output "route_table_name" {
  description = "Name of the route table"
  value       = local.deploy_route_table ? azurerm_route_table.this[0].name : null
  depends_on  = [azurerm_route_table.this]
}

output "peering_ids" {
  description = "The IDs of the virtual network peerings"
  value = {
    for key, peering in azurerm_virtual_network_peering.this : key => peering.id
  }
}

output "subnet_id" {
  description = "Map of subnet names to their IDs"
  value       = { for key, subnet in azurerm_subnet.this : key => subnet.id }
}
