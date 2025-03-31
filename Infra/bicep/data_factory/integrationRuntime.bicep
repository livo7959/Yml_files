param environment_name string

param integration_runtime_name string
param data_factory_name string

resource data_factory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: data_factory_name
}

resource symbolicname 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: integration_runtime_name // per documentation, ADF requires the same name and type of integration runtime across all stages of CI/CD
  parent: data_factory
  properties: {
    type: 'SelfHosted'
  }
}
