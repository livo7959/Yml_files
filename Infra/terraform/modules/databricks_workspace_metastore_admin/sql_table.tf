
resource "databricks_sql_table" "managed_tables" {
  for_each = {
    for idx, each in flatten([
      for schema, assets in var.catalog_assets : [
        for managed_table in assets.managed_tables : {
          schema_name   = schema
          managed_table = managed_table
        }
      ]
    ]) :
    "${each.schema_name}-${each.managed_table.name}" => each
  }

  name         = each.value.managed_table.name
  catalog_name = databricks_catalog.env_catalog.name
  schema_name  = databricks_schema.schemas[each.value.schema_name].name
  table_type   = "MANAGED"
  cluster_id   = var.cluster_id

  dynamic "column" {
    for_each = each.value.managed_table.columns
    content {
      name     = column.value.name
      type     = column.value.type
      nullable = column.value.nullable
      comment  = column.value.comment
    }
  }

  comment = each.value.managed_table.table_description
}
