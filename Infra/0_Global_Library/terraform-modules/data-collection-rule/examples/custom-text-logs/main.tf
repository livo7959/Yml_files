data "azurerm_log_analytics_workspace" "law" {
  name                = "log-tommy-eus-sbox"
  resource_group_name = "rg-tommy-eus-sbox"
}

data "azurerm_monitor_data_collection_endpoint" "dep" {
  name                = "dep-data-collection-sbox"
  resource_group_name = "rg-data-collection-sbox"
}

module "dcr_text" {
  source                      = "../../"
  resource_group              = data.azurerm_monitor_data_collection_endpoint.dep.resource_group_name
  name                        = "dcrtext"
  location                    = "eus"
  environment                 = "sbox"
  data_collection_endpoint_id = data.azurerm_monitor_data_collection_endpoint.dep.id
  collection_rules = [
    {
      data_sources = {
        log_file = {
          file_patterns                 = ["C:\\LogixLogs\\*.log"]
          format                        = "text"
          streams                       = ["Custom-logixlogs_CL"]
          record_start_timestamp_format = "ISO 8601"
        }
      }
      data_flow = {
        streams       = ["Custom-logixlogs_CL"]
        destinations  = ["log-tommy-eus-sbox"]
        transform_kql = "source"
        output_stream = "Custom-logixlogs_CL"
      }
      destinations = {
        log_analytics = {
          workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
          name                  = "log-tommy-eus-sbox"
        }
      }
    }
  ]
  stream_declaration = [
    {
      stream_name = "Custom-logixlogs_CL"
      columns = [
        {
          name = "TimeGenerated"
          type = "datetime"
        },
        {
          name = "RawData"
          type = "string"
        }
      ]
    }
  ]
  associations = [
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDDSAAS001"
    }
  ]
}

module "dcr_text2" {
  source                      = "../../"
  resource_group              = data.azurerm_monitor_data_collection_endpoint.dep.resource_group_name
  name                        = "dcrtextvtwo"
  location                    = "eus"
  environment                 = "sbox"
  data_collection_endpoint_id = data.azurerm_monitor_data_collection_endpoint.dep.id
  collection_rules = [
    {
      data_sources = {
        log_file = {
          file_patterns                 = ["C:\\LogixLogs\\*.log"]
          format                        = "text"
          streams                       = ["Custom-${azapi_resource.dcr_table.name}"]
          record_start_timestamp_format = "ISO 8601"
        }
      }
      data_flow = {
        streams       = ["Custom-${azapi_resource.dcr_table.name}"]
        destinations  = ["log-inf-eus-sbox"]
        transform_kql = "source"
        output_stream = "Custom-${azapi_resource.dcr_table.name}"
      }
      destinations = {
        log_analytics = {
          workspace_resource_id = azurerm_log_analytics_workspace.this.id
          name                  = "log-inf-eus-sbox"
        }
      }
    }
  ]
  stream_declaration = [
    {
      stream_name = "Custom-${azapi_resource.dcr_table.name}"
      columns = [
        {
          name = "TimeGenerated"
          type = "datetime"
        },
        {
          name = "LogLevel"
          type = "string"
        },
        {
          name = "Action"
          type = "dynamic"
        },
        {
          name = "ActionDateTime"
          type = "datetime"
        },
        {
          name = "AdditionalInfo"
          type = "dynamic"
        },
        {
          name = "ApplicationName"
          type = "string"
        },
        {
          name = "ErrorMessage"
          type = "string"
        },
        {
          name = "HttpStatus"
          type = "string"
        },
        {
          name = "LogDateTime"
          type = "datetime"
        },
        {
          name = "StackTrace"
          type = "string"
        },
        {
          name = "SyncID"
          type = "string"
        },
        {
          name = "UserIdentity"
          type = "string"
        }
      ]
    }
  ]
  associations = [
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDQSAAS001"
    }
  ]
}
