module "unity_catalog_storage_account_name" {
  source        = "../naming"
  resource_type = "storage_account"
  env           = var.env
  location      = var.location
  name          = var.unity_catalog_storage_account_name
}

module "external_storage_account_name" {
  for_each = {
    for idx, each in var.external_storage_locations :
    each.external_location_name => each
  }

  source        = "../naming"
  resource_type = "storage_account"
  env           = var.env
  location      = var.location
  name          = each.value.storage_account_name
}

resource "databricks_external_location" "catalog_external_location" {
  name            = "catalog-${var.env}"
  url             = "abfss://datalake@${module.unity_catalog_storage_account_name.name}.dfs.core.windows.net"
  credential_name = databricks_storage_credential.external_storage_credential.id
  isolation_mode  = "ISOLATION_MODE_ISOLATED"
}

resource "databricks_external_location" "external_locations" {
  for_each = {
    for idx, each in var.external_storage_locations :
    each.external_location_name => each
  }

  name            = "${each.value.external_location_name}-${var.env}"
  url             = "abfss://${each.value.container_name}@${module.external_storage_account_name[each.value.external_location_name].name}.dfs.core.windows.net/${each.value.path}"
  credential_name = databricks_storage_credential.external_storage_credential.id
  isolation_mode  = "ISOLATION_MODE_ISOLATED"
}

resource "databricks_grants" "catalog_external_location_grants" {
  external_location = databricks_external_location.catalog_external_location.id
  grant {
    principal  = "databricks_${var.env}_admin"
    privileges = ["READ_FILES", "WRITE_FILES"]
  }
  grant {
    principal  = "databricks_bronze_data_writer_${var.env}"
    privileges = ["READ_FILES", "WRITE_FILES"]
  }
}

resource "databricks_grants" "external_location_grants" {
  for_each = {
    for idx, each in var.external_storage_locations :
    each.external_location_name => each
  }

  external_location = databricks_external_location.external_locations[each.value.external_location_name].id
  grant {
    principal  = "databricks_${var.env}_admin"
    privileges = ["READ_FILES"]
  }
  grant {
    principal  = "databricks_bronze_data_writer_${var.env}"
    privileges = ["READ_FILES"]
  }

  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

resource "databricks_workspace_binding" "catalog_external_location_workspace_binding" {
  securable_name = databricks_external_location.catalog_external_location.name
  securable_type = "external_location"
  workspace_id   = var.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}

resource "databricks_workspace_binding" "external_location_workspace_bindings" {
  for_each = {
    for idx, each in var.external_storage_locations :
    each.external_location_name => each
  }

  securable_name = databricks_external_location.external_locations[each.key].name
  securable_type = "external_location"
  workspace_id   = var.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}
