# This is where we handle the catalog-level permissions. Specifically, the "account-mode" with a
# workspace scope.

resource "databricks_catalog" "env_catalog" {
  name           = var.env
  storage_root   = databricks_external_location.catalog_external_location.url
  isolation_mode = "ISOLATED"
}

resource "databricks_workspace_binding" "env_catalog_workspace_bindings" {
  securable_name = databricks_catalog.env_catalog.name
  workspace_id   = var.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}

resource "databricks_grants" "env_catalog_grants" {
  catalog = databricks_catalog.env_catalog.name
  grant {
    principal  = "databricks_${var.env}_admin"
    privileges = ["MODIFY", "SELECT", "USE_CATALOG", "USE_SCHEMA"]
  }
  grant {
    principal  = "databricks_bronze_data_writer_${var.env}"
    privileges = ["MODIFY", "SELECT", "USE_CATALOG", "USE_SCHEMA"]
  }

  # Dynamic block for granting a permission to only a specific environment.
  dynamic "grant" {
    for_each = flatten([for obj in var.catalog_assets : obj.grants])

    content {
      principal  = grant.value.principal
      privileges = ["USE_CATALOG"]
    }
  }

  dynamic "grant" {
    for_each = var.catalog_grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

resource "databricks_schema" "schemas" {
  for_each = var.catalog_assets

  catalog_name = databricks_catalog.env_catalog.name
  name         = each.key
  comment      = each.value.description
}

resource "databricks_grants" "per_schema_grants" {
  for_each = {
    for schema, config in var.catalog_assets :
    schema => config
  }

  schema = databricks_schema.schemas[each.key].id

  grant {
    principal  = "databricks_${var.env}_admin"
    privileges = ["CREATE_TABLE", "READ_VOLUME"]
  }

  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
