@description('The name of the storage account')
param storageAccountName string

@description('The location of the storage account')
param location string

@description('The SKU of the storage account')
param storageAccountSku string

@description('The name of the blob container')
param blobContainerName string

@description('The name of the private endpoint')
param privateEndpointName string

@description('The location of the private endpoint')
param privateEndpointLocation string

@description('The ID of the subnet to connect the private endpoint to')
param subnetId string

@description('The IP address to allow access to the storage account')
param allowedIpAddress string

var vnetID = '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-private-endpoint-eus-001/providers/Microsoft.Network/virtualNetworks/vnet-private-endpoint-eus-001'
var snetID = '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-private-endpoint-eus-001/providers/Microsoft.Network/virtualNetworks/vnet-private-endpoint-eus-001/subnets/snet-corp-fileshares-eus-001'

resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSku
  }
  properties: {
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: [
        {
          value: allowedIpAddress
          action: 'Allow'
        }
      ]
    }
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccountName}/default/${blobContainerName}'
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: privateEndpointName
  location: privateEndpointLocation
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'myPLSConnection'
        properties: {
          privateLinkServiceId: stg.id
        }
      }
    ]
    subnet: {
      id: snetID
    }
  }
}
