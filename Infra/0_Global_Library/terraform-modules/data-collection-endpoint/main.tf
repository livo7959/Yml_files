resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                = "dce-${local.base_name}"
  resource_group_name = var.resource_group
  location            = module.common_constants.region_short_name_to_long_name[var.location]

  kind                          = try(var.kind, null)
  public_network_access_enabled = try(var.public_network_access_enabled, true)
  tags                          = local.merged_tags
}

resource "azurerm_monitor_data_collection_rule_association" "this" {
  for_each = var.associations != null ? { for idx, dce in var.associations : idx => dce } : {}

  name                        = "configurationAccessEndpoint" # Hard coded as DCE associations must be named `configurationAccessEndpoint`
  target_resource_id          = each.value.target_resource_id
  data_collection_endpoint_id = coalesce(each.value.data_collection_endpoint_id, azurerm_monitor_data_collection_endpoint.this.id)
}
