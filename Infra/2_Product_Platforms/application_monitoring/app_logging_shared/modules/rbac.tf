resource "azurerm_role_assignment" "rbac_log_analytics_reader" {
  scope                = module.rg_lh_app_logging.resource_group_id
  role_definition_name = "Log Analytics Reader"
  principal_id         = azuread_group.law_readers.object_id
}
