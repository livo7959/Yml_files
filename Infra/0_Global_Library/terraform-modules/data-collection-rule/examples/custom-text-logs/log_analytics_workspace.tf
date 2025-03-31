resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-inf-eus-sbox"
  resource_group_name = data.azurerm_monitor_data_collection_endpoint.dep.resource_group_name
  location            = data.azurerm_monitor_data_collection_endpoint.dep.location
  sku                 = "PerGB2018"
}

# Creating the custom table using azapi. The azurerm provider only supports table management not creation.

resource "azapi_resource" "dcr_table" {
  name      = "logixlogstest_CL"
  parent_id = azurerm_log_analytics_workspace.this.id
  type      = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  body = jsonencode(
    {
      "properties" : {
        "schema" : {
          "name" : "logixlogstest_CL",
          "columns" : [
            {
              "name" : "TimeGenerated",
              "type" : "datetime",
              "description" : "The time at which the data was generated"
            },
            {
              "name" : "LogLevel",
              "type" : "string",
              "description" : "Log level"
            },
            {
              "name" : "Action",
              "type" : "dynamic",
              "description" : ""
            },
            {
              "name" : "ActionDateTime",
              "type" : "datetime",
              "description" : "Context of the log line"
            },
            {
              "name" : "AdditionalInfo",
              "type" : "dynamic",
              "description" : ""
            },
            {
              "name" : "ApplicationName",
              "type" : "string",
              "description" : "Name of the application"
            },
            {
              "name" : "ErrorMessage",
              "type" : "string"
            },
            {
              "name" : "HttpStatus",
              "type" : "String"
            },
            {
              "name" : "LogDateTime",
              "type" : "datetime"
            },
            {
              "name" : "StackTrace",
              "type" : "string"
            },
            {
              "name" : "SyncID",
              "type" : "string"
            },
            {
              "name" : "UserIdentity",
              "type" : "string"
            }
          ]
        },
        "retentionInDays" : 30,
        "totalRetentionInDays" : 30
      }
    }
  )
}
