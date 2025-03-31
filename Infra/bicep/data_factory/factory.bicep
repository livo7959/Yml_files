param location string
param environment_name string

param data_factory_basename string
param integration_runtimes array = []

var data_factory_name = '${data_factory_basename}-${environment_name}'

resource data_factory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: data_factory_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

module integration_runtime_mod './integrationRuntime.bicep' = [for integration_runtime in integration_runtimes: {
  name: integration_runtime
  params: {
    environment_name: environment_name
    integration_runtime_name: integration_runtime
    data_factory_name: data_factory_name
  }
}]
