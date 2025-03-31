resource "azurerm_log_analytics_query_pack" "pack_lhapps" {
  name                = "pack-lhapps"
  resource_group_name = module.rg_query_pack.resource_group_name
  location            = module.rg_query_pack.resource_group_location
}

