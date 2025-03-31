targetScope = 'resourceGroup'

@description('Name of the storage account, must me all lowercase and globally unique to Azure')
param strName string = 'lhinfsftp001'

@description('region of the storage account. Will be the same as the resource group.')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: strName
  location: location
  kind: 'StorageV2'
  sku: {
    name:'Standard_LRS'
  }
  tags: {
    Environment: 'Test'
    Application: 'SFTP'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    isHnsEnabled: true
    isLocalUserEnabled: true
    isSftpEnabled: true
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Enabled'
    networkAcls:  {
      defaultAction: 'Deny'
      ipRules: [{
        action: 'Allow'
        value: '66.97.189.250'
    }]
  }
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccount.name}/default/sftp'
}

output outStorageAccountName string = storageAccount.name
output outStorageAccountID string = storageAccount.id
output outContainerName string = container.name
output outContainerID string = container.id
