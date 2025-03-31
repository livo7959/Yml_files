param location string
param environment_name string

param serviceBusNamespaces array

resource sb_namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = [for serviceBusNamespace in serviceBusNamespaces: {
  name: '${serviceBusNamespace.name}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  sku: {
    name: serviceBusNamespace.accountType
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    disableLocalAuth: true
    minimumTlsVersion: '1.2'
    publicNetworkAccess: serviceBusNamespace.publicNetworkAccess
    zoneRedundant: serviceBusNamespace.zoneRedundant
  }
}]

module topics './service_bus_topic.bicep' = [for serviceBusNamespace in serviceBusNamespaces: {
  name: serviceBusNamespace.name
  params: {
    namespace: '${serviceBusNamespace.name}-${environment_name}'
    sb_topics: serviceBusNamespace.topics
    environment_name: environment_name
  }
  dependsOn: [
    sb_namespace
  ]
}]
