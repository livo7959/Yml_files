param location string
param environment_name string

param container_registries array
param identity_id string

resource azure_container_registries 'Microsoft.ContainerRegistry/registries@2022-12-01' = [for container_registry in container_registries : {
  name: '${container_registry.name}${environment_name}'
  location: location
  sku: {
    name: container_registry.sku
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity_id}': {}
    }
  }
  properties: {
    adminUserEnabled: true
    dataEndpointEnabled: false
    encryption: {
      status: 'disabled'
    }
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSet: {
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          value: '66.97.189.250'
        }
        {
          action: 'Allow'
          value: '20.121.254.164'
        }
      ]
    }
    policies: {
      exportPolicy: {
        status: 'enabled'
      }
      quarantinePolicy: {
        status: 'disabled'
      }
      retentionPolicy: {
        days: 14
        status: 'disabled'
      }
      trustPolicy: {
        status: 'disabled'
        type: 'Notary'
      }
    }
    publicNetworkAccess: 'Disabled'
    zoneRedundancy: 'Disabled'
  }
  tags: {
    environment: environment_name
  }
}]
