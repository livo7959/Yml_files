metadata name = 'Route Tables'
metadata description = 'This module deploys a User Defined Route Table (UDR).'
metadata owner = 'Azure/module-maintainers'

param name string

param location string = resourceGroup().location

param routes array = []

param disableBgpRoutePropagation bool = false

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
param lock string = ''

param tags object = {}

param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource routeTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    routes: routes
    disableBgpRoutePropagation: disableBgpRoutePropagation
  }
}

resource routeTable_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${routeTable.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: routeTable
}

output resourceGroupName string = resourceGroup().name

output name string = routeTable.name

output resourceId string = routeTable.id

output location string = routeTable.location
