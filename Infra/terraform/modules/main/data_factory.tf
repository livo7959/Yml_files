module "data_factory_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.data_factory_configs :
    each.data_factory_config.name => each
  }

  resource_type = "data_factory"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.value.data_factory_config.name
}

resource "azurerm_data_factory" "data_factory" {
  for_each = {
    for idx, each in local.data_factory_configs :
    each.data_factory_config.name => each
  }

  name                   = module.data_factory_name[each.key].name
  location               = each.value.resource_group.location
  resource_group_name    = each.value.resource_group.name
  public_network_enabled = false
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

locals {
  integration_runtimes = flatten([
    for data_factory_config in local.data_factory_configs : [
      for integration_runtime in data_factory_config.data_factory_config.integration_runtimes : {
        data_factory_id     = azurerm_data_factory.data_factory[data_factory_config.data_factory_config.name].id
        integration_runtime = integration_runtime
      }
    ]
  ])
  linked_services = {
    adls2 = flatten([
      for data_factory_config in local.data_factory_configs : [
        for adls2_linked_service in lookup(data_factory_config.data_factory_config.linked_services, "adls2", []) : {
          data_factory_config  = data_factory_config
          adls2_linked_service = adls2_linked_service
        }
      ]
    ])
    az_databricks = flatten([
      for data_factory_config in local.data_factory_configs : [
        for az_databricks_linked_service in lookup(data_factory_config.data_factory_config.linked_services, "az_databricks", []) : {
          data_factory_config          = data_factory_config
          az_databricks_linked_service = az_databricks_linked_service
        }
      ]
    ])
    az_datalake = flatten([
      for data_factory_config in local.data_factory_configs : [
        for az_datalake_linked_service in lookup(lookup(data_factory_config.data_factory_config.linked_services, "az_datalake", tomap({})), var.env, []) : {
          data_factory_config        = data_factory_config
          az_datalake_linked_service = az_datalake_linked_service
        }
      ]
    ])
    key_vault = flatten([
      for data_factory_config in local.data_factory_configs : [
        for kv_linked_service in lookup(data_factory_config.data_factory_config.linked_services, "key_vault", []) : {
          data_factory_config = data_factory_config
          kv_linked_service   = kv_linked_service
        }
      ]
    ])
    sql_server = flatten([
      for data_factory_config in local.data_factory_configs : [
        for sql_linked_service in lookup(lookup(data_factory_config.data_factory_config.linked_services, "sql_server", tomap({})), var.env, []) : {
          data_factory_config = data_factory_config
          sql_linked_service  = sql_linked_service
        }
      ]
    ])
  }
  datasets = {
    delimited_text = flatten([
      for data_factory_config in local.data_factory_configs : [
        for delimited_text_dataset_config in lookup(lookup(data_factory_config.data_factory_config.datasets, "delimited_text", tomap({})), var.env, []) : {
          data_factory_config           = data_factory_config
          delimited_text_dataset_config = delimited_text_dataset_config
        }
      ]
    ])
    parquet = flatten([
      for data_factory_config in local.data_factory_configs : [
        for parquet_dataset_config in lookup(lookup(data_factory_config.data_factory_config.datasets, "parquet", tomap({})), var.env, []) : {
          data_factory_config    = data_factory_config
          parquet_dataset_config = parquet_dataset_config
        }
      ]
    ])
    sql_server_table = flatten([
      for data_factory_config in local.data_factory_configs : [
        for sql_server_table_dataset_config in lookup(lookup(data_factory_config.data_factory_config.datasets, "sql_server_table", tomap({})), var.env, []) : {
          data_factory_config             = data_factory_config
          sql_server_table_dataset_config = sql_server_table_dataset_config
        }
      ]
    ])
  }
  pipelines = flatten([
    for data_factory_config in local.data_factory_configs : [
      for pipeline_config in lookup(data_factory_config.data_factory_config.pipelines, var.env, []) : {
        data_factory_config = data_factory_config
        pipeline_config     = pipeline_config
      }
    ]
  ])
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "integration_runtimes" {
  for_each = {
    for idx, each in local.integration_runtimes :
    each.integration_runtime => each
  }

  name            = each.value.integration_runtime
  data_factory_id = each.value.data_factory_id
}

resource "azurerm_data_factory_linked_service_azure_databricks" "linked_service_az_databricks" {
  for_each = {
    for each in local.linked_services.az_databricks :
    each.az_databricks_linked_service.name => each
  }

  name            = each.value.az_databricks_linked_service.name
  data_factory_id = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  adb_domain      = each.value.az_databricks_linked_service.adb_domain

  msi_work_space_resource_id = each.value.az_databricks_linked_service.msi_work_space_resource_id

  new_cluster_config {
    node_type             = "Standard_DS3_v2"
    cluster_version       = "14.3.x-scala2.12"
    min_number_of_workers = 1
    max_number_of_workers = 1
    driver_node_type      = "Standard_DS3_v2"

    custom_tags = local.common_tags
  }
}

resource "azurerm_role_assignment" "adf_databricks_contributor" {
  for_each = {
    for each in local.linked_services.az_datalake :
    each.az_datalake_linked_service.name => each
  }

  scope                = each.value.az_datalake_linked_service.databricks_workspace_resource_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].identity[0].principal_id
}

resource "azurerm_data_factory_linked_service_key_vault" "linked_service_key_vault" {
  for_each = {
    for idx, each in local.linked_services.key_vault :
    each.kv_linked_service.name => each
  }

  name            = each.value.kv_linked_service.name
  data_factory_id = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  key_vault_id    = azurerm_key_vault.key_vault[each.value.kv_linked_service.key_vault_name].id
}

resource "azurerm_data_factory_linked_service_sql_server" "linked_service_sql_server" {
  for_each = {
    for idx, each in local.linked_services.sql_server :
    each.sql_linked_service.name => each
  }

  name                     = each.value.sql_linked_service.name
  data_factory_id          = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  integration_runtime_name = each.value.sql_linked_service.integration_runtime_name
  user_name                = each.value.sql_linked_service.username
  key_vault_connection_string {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.linked_service_key_vault[each.value.sql_linked_service.connection_string_key_vault_ref_name].name
    secret_name         = each.value.sql_linked_service.connection_string_key_vault_secret_name
  }

  key_vault_password {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.linked_service_key_vault[each.value.sql_linked_service.password_key_vault_ref_name].name
    secret_name         = each.value.sql_linked_service.password_key_vault_secret_name
  }
}

resource "azurerm_role_assignment" "data_factory_kv_secret_user" {
  for_each = {
    for idx, each in local.linked_services.key_vault :
    each.kv_linked_service.name => each
  }

  scope                = azurerm_key_vault.key_vault[each.value.kv_linked_service.key_vault_name].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].identity[0].principal_id
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "linked_service_adls2" {
  for_each = {
    for idx, each in local.linked_services.adls2 :
    each.adls2_linked_service.name => each
  }

  name                 = each.value.adls2_linked_service.name
  data_factory_id      = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  url                  = azurerm_storage_account.storage_account[each.value.adls2_linked_service.storage_account_name].primary_dfs_endpoint
  use_managed_identity = true
}

resource "azurerm_role_assignment" "datafactory_storage_account_user" {
  for_each = {
    for idx, each in local.linked_services.adls2 :
    each.adls2_linked_service.name => each
  }

  scope                = azurerm_storage_account.storage_account[each.value.adls2_linked_service.storage_account_name].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].identity[0].principal_id
}

resource "azapi_resource" "adf_azure_databricks_delta_lake_linked_service" {
  for_each = {
    for each in local.linked_services.az_datalake :
    each.az_datalake_linked_service.name => each
  }

  type      = "Microsoft.DataFactory/factories/linkedservices@2018-06-01"
  name      = each.value.az_datalake_linked_service.name
  parent_id = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  body = jsonencode({
    properties = {
      annotations = []
      connectVia = {
        parameters    = {}
        referenceName = "DataIntegrationRuntime"
        type          = "IntegrationRuntimeReference"
      }
      description = "string"
      parameters  = {}
      type        = "AzureDatabricksDeltaLake"
      typeProperties = {
        "domain" : each.value.az_datalake_linked_service.adb_domain,
        "clusterId" : each.value.az_datalake_linked_service.cluster_id,
        "workspaceResourceId" : each.value.az_datalake_linked_service.databricks_workspace_resource_id
      }
    }
  })
}

resource "azurerm_data_factory_dataset_delimited_text" "dataset_delimited_text" {
  for_each = {
    for each in local.datasets.delimited_text :
    each.delimited_text_dataset_config.name => each
  }

  name                = each.value.delimited_text_dataset_config.name
  data_factory_id     = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.linked_service_adls2[each.value.delimited_text_dataset_config.linked_service_name].name
  parameters          = each.value.delimited_text_dataset_config.parameters

  first_row_as_header = true
  row_delimiter       = "\n"

  azure_blob_fs_location {
    file_system                 = each.value.delimited_text_dataset_config.storage_container
    path                        = each.value.delimited_text_dataset_config.storage_path
    filename                    = each.value.delimited_text_dataset_config.storage_filename
    dynamic_file_system_enabled = true
    dynamic_path_enabled        = true
    dynamic_filename_enabled    = true
  }
}

resource "azurerm_data_factory_dataset_parquet" "dataset_parquet" {
  for_each = {
    for each in local.datasets.parquet :
    each.parquet_dataset_config.name => each
  }

  name                = each.value.parquet_dataset_config.name
  data_factory_id     = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.linked_service_adls2[each.value.parquet_dataset_config.linked_service_name].name
  parameters          = each.value.parquet_dataset_config.parameters
  compression_codec   = "snappy"

  azure_blob_fs_location {
    file_system                 = each.value.parquet_dataset_config.storage_container
    path                        = each.value.parquet_dataset_config.storage_path
    filename                    = each.value.parquet_dataset_config.storage_filename
    dynamic_file_system_enabled = true
    dynamic_path_enabled        = true
    dynamic_filename_enabled    = true
  }
}

resource "azurerm_data_factory_dataset_sql_server_table" "sql_server_table" {
  for_each = {
    for each in local.datasets.sql_server_table :
    each.sql_server_table_dataset_config.name => each
  }

  name                = each.value.sql_server_table_dataset_config.name
  data_factory_id     = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.linked_service_sql_server[each.value.sql_server_table_dataset_config.linked_service_name].name
  table_name          = each.value.sql_server_table_dataset_config.table_name
  parameters          = each.value.sql_server_table_dataset_config.parameters
}

resource "azurerm_data_factory_pipeline" "data_factory_pipeline" {
  for_each = {
    for each in local.pipelines :
    each.pipeline_config.name => each
  }

  name            = each.value.pipeline_config.name
  data_factory_id = azurerm_data_factory.data_factory[each.value.data_factory_config.data_factory_config.name].id
  parameters      = each.value.pipeline_config.parameters
  variables       = each.value.pipeline_config.variables
  activities_json = jsonencode(each.value.pipeline_config.activities)
}
