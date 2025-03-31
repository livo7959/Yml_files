param location string
param environment_name string

param storageAccounts array

resource storageAccountResources 'Microsoft.Storage/storageAccounts@2022-09-01' = [for storageAccount in storageAccounts: {
  name: '${storageAccount.name}${environment_name}'
  location: location
  sku: {
    name: storageAccount.accountType
  }
  kind: storageAccount.kind
  tags: {
    environment: environment_name
  }
  properties: {
    accessTier: storageAccount.accessTier
    allowBlobPublicAccess: storageAccount.allowBlobPublicAccess
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    minimumTlsVersion: 'TLS1_2'
    isSftpEnabled: storageAccount.isSftpEnabled
    isHnsEnabled: storageAccount.isHnsEnabled
    isLocalUserEnabled: storageAccount.isSftpEnabled
    routingPreference:{
      routingChoice: 'MicrosoftRouting'
    }
    encryption:{
      keySource: 'Microsoft.Storage'
    }
    publicNetworkAccess: 'Enabled'
    networkAcls: storageAccount.?networkAccess.public == true ? {
      defaultAction: 'Allow'
    } : {
      bypass: storageAccount.?networkAccess.?bypass ?? 'AzureServices'
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
      resourceAccessRules: map(
        storageAccount.?networkAccess.?resourceAccessRules ?? [],
        resourceAccessRule => {
          resourceId: resourceAccessRule.resourceId
          tenantId: tenant().tenantId
        }
      )
      virtualNetworkRules: map(
        storageAccount.?networkAccess.?virtualNetworkRules ?? [],
        virtualNetworkRule => {
          action: 'Allow'
          id: resourceId(
            virtualNetworkRule.?subscriptionId ?? subscription().subscriptionId,
            virtualNetworkRule.?resourceGroupName ?? resourceGroup().name,
            'Microsoft.Network/VirtualNetworks/subnets',
            virtualNetworkRule.virtualNetworkName,
            virtualNetworkRule.subnetName
          )
        }
      )
    }
  }
}]

module containers 'storage_containers.bicep' = [ for storageAccount in storageAccounts: {
  name: '${storageAccount.name}-containers'
  params: {
    storageAccountName: '${storageAccount.name}${environment_name}'
    containers: storageAccount.containers
  }
  dependsOn: [
    storageAccountResources
  ]
}]

module local_users 'local_users.bicep' = [ for storageAccount in storageAccounts: {
  name: '${storageAccount.name}-local_users'
  params: {
    storage_account_name: '${storageAccount.name}${environment_name}'
    local_users: storageAccount.?local_users ?? []
    environment_name: environment_name
  }
  dependsOn: [
    storageAccountResources
    containers
  ]
}]

module event_topics '../event_grid/event_grid_topic.bicep' = [ for storageAccount in storageAccounts: {
  name: '${storageAccount.name}-event_grid_topics'
  params: {
    storage_account_name: '${storageAccount.name}${environment_name}'
    event_grid_topic_subscriptions: storageAccount.?event_grid_topic_subscriptions ?? []
    environment_name: environment_name
    location: location
  }
  dependsOn: [
    storageAccountResources
    containers
  ]
}]

module event_subscriptions '../event_grid/event_grid_subscription.bicep' = [ for storageAccount in storageAccounts: {
  name: '${storageAccount.name}-event_grid_subs'
  params: {
    storage_account_name: '${storageAccount.name}${environment_name}'
    event_grid_topic_subscriptions: storageAccount.?event_grid_topic_subscriptions ?? []
    environment_name: environment_name
  }
  dependsOn: [
    event_topics
  ]
}]
