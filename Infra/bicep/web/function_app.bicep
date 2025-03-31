param location string
param function_app object
param environment_name string
param host_plan_id string
param app_insights_instrumentation_key string

resource function_app_storage_account 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: '${function_app.storageAccountName}${environment_name}'
}

var function_app_name = '${function_app.name}-${environment_name}'
var storage_connector = 'DefaultEndpointsProtocol=https;AccountName=${function_app_storage_account.name};AccountKey=${function_app_storage_account.listKeys().keys[0].value}'

resource func_app 'Microsoft.Web/sites@2022-03-01' = {
  name: function_app_name
  location: location
  kind: 'functionapp,linux'
  tags: {
    environment: environment_name
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    clientAffinityEnabled: false
    serverFarmId: host_plan_id
    publicNetworkAccess: 'Disabled'
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.10'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storage_connector
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: app_insights_instrumentation_key
        }
      ]
    }
  }
}
