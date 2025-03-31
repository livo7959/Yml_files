resource "azurerm_role_assignment" "rbac_rg_monitoring_reader" {
  scope                = module.rg.resource_group_id
  role_definition_name = "Monitoring Reader"
  principal_id         = azuread_group.rg_monitoring_read_group.id
}

resource "azurerm_role_assignment" "rbac_rg_log_analytics_contributor" {
  scope                = module.rg_query_pack.resource_group_id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azuread_group.rg_log_analytics_contributor.id
}
