resource "databricks_storage_credential" "external_storage_credential" {
  name           = "external-storage-credential-${var.env}"
  metastore_id   = var.metastore_id
  isolation_mode = "ISOLATION_MODE_ISOLATED"

  azure_managed_identity {
    access_connector_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-databricks-${var.env}/providers/Microsoft.Databricks/accessConnectors/logix-data-${var.env}"
  }
}

resource "databricks_workspace_binding" "env_storage_cred_workspace_bindings" {
  securable_name = databricks_storage_credential.external_storage_credential.name
  securable_type = "storage_credential"
  workspace_id   = var.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}
