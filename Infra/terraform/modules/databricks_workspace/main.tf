data "databricks_group" "databricks_bronze_data_writer" {
  display_name = "databricks_bronze_data_writer_${var.env}"
}

resource "databricks_secret_scope" "keyvault_secret_scope" {
  name = "keyvault-managed"

  keyvault_metadata {
    resource_id = var.key_vault_id
    dns_name    = var.key_vault_uri
  }
}
