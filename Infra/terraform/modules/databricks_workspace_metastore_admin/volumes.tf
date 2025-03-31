resource "databricks_volume" "volumes" {
  for_each = {
    for idx, each in flatten([
      for schema, assets in var.catalog_assets : [
        for volume in assets.volumes : {
          schema_name = schema
          volume      = volume
        }
      ]
    ]) :
    "${each.schema_name}-${each.volume.name}" => each
  }

  name             = each.value.volume.name
  catalog_name     = databricks_catalog.env_catalog.name
  schema_name      = databricks_schema.schemas[each.value.schema_name].name
  volume_type      = "EXTERNAL"
  storage_location = databricks_external_location.external_locations[each.value.volume.external_location_name].url

  comment = each.value.volume.comment
}


resource "databricks_grants" "volume_grants_read" {
  for_each = {
    for idx, each in flatten([
      for schema, assets in var.catalog_assets : [
        for volume in assets.volumes : {
          schema_name = schema
          volume      = volume
        }
      ]
    ]) :
    "${each.schema_name}-${each.volume.name}" => each
    if length(each.volume.readers) > 0
  }
  volume = databricks_volume.volumes[each.key].id

  dynamic "grant" {
    for_each = each.value.volume.readers
    content {
      principal  = grant.value
      privileges = ["READ_VOLUME"]
    }
  }
}

resource "databricks_grants" "volume_grants_write" {
  for_each = {
    for idx, each in flatten([
      for schema, assets in var.catalog_assets : [
        for volume in assets.volumes : {
          schema_name = schema
          volume      = volume
        }
      ]
    ]) :
    "${each.schema_name}-${each.volume.name}" => each
    if length(each.volume.writers) > 0
  }
  volume = databricks_volume.volumes[each.key].id

  dynamic "grant" {
    for_each = each.value.volume.writers
    content {
      principal  = grant.value
      privileges = ["READ_VOLUME", "WRITE_VOLUME"]
    }
  }
}
