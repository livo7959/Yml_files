resource "databricks_credential" "azure_access_connector" {
  name           = "azure-access-connector-${var.env}"
  purpose        = "SERVICE"
  isolation_mode = "ISOLATION_MODE_ISOLATED"

  azure_managed_identity {
    access_connector_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-databricks-${var.env}/providers/Microsoft.Databricks/accessConnectors/logix-data-${var.env}"
  }
}

resource "databricks_grants" "credential_azure_access_connector" {
  credential = databricks_credential.azure_access_connector.id

  grant {
    principal  = "data_engineering_data_developer"
    privileges = ["ACCESS"]
  }
}

resource "databricks_workspace_binding" "credential__azure_access_connector" {
  securable_name = databricks_credential.azure_access_connector.name
  securable_type = "credential"
  workspace_id   = var.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}
