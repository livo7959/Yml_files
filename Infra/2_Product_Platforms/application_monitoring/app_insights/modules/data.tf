data "azuread_client_config" "current" {}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  provider            = azurerm.LH-Management-Sub-001
  name                = "lh-log-analytics"
  resource_group_name = "rg-lh-logging-001"
}
