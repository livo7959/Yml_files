@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Name of the storage account. Must be lowercase and 3-15 characters')
param storageAccountName string

@description('Environment for deployment')
@allowed([
  'prod'
  'uat'
  'qa'
  'dev'
  'sbox'
])
param env string

@description('Storage account Sku')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountSku string

@description('Kind of storage account')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param storageAccountKind string

@description('Storage Account Access tier')
@allowed([
  'Hot'
  'Cool'
  'Premium'
])
param accessTier string

@description('Allow Public Blob Access')
param allowPublicBlobAccess bool

@description('Allow Public Network Access')
@allowed([
  'Enabled'
  'Disabled'
])
param allowPublicNetworkAccess string

@description('Blob container array')
param blobContainers array

// Declare Variables
var tagValues = {
  env: env
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  tags: tagValues
  sku: {
    name: storageAccountSku
  }
  kind: storageAccountKind
  properties: {
    accessTier: accessTier
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: allowPublicBlobAccess
    publicNetworkAccess: allowPublicNetworkAccess
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: [
        {
          value: '66.97.189.250'
         action: 'Allow'
        }
      ]
    }
  }
}

resource service 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccount
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for blobContainer in blobContainers:{
  parent: service
  name: blobContainer.name
}]

