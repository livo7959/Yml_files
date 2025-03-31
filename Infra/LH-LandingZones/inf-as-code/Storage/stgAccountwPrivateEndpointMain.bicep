@description('The name of the storage account')
param storageAccountName string

@description('The name of the virtual network')
param virtualNetworkName string

@description('The name of the resource group containing the virtual network')
param virtualNetworkResourceGroupName string

@description('The subscription ID of the existsing virtual network')
param virtualNetworkSubscriptionId

@description('The name of the subnet to use for the private endpoint')
param subnetName string

@description('The name of the private endpoint')
param privateEndpointName string

@description('The name of the existing private DNS zone')
param privateDnsZoneName string

@description('The subscription ID containing the existing private DNS zone')
param privateDnsZoneSubscriptionId string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  scope: resourceGroup(virtualNetworkSubscriptionId, virtualNetworkResourceGroupName)
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: vnet
  name: subnetName
}

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '100.1.1.100'
          action: 'Allow'
        }
      ]
    }
  }
}


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: privateEndpointName
  location: resourceGroup().location
  properties: {
    customNetworkInterfaceName: 'nic-pep-'
    privateLinkServiceConnections: [
      {
        name: 'myprivatelinkserviceconnection'
        properties: {
          privateLinkServiceId: stg.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
    subnet: {
      id: subnet.id
    }
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
  scope: subscription(privateDnsZoneSubscriptionId)
}

resource aRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateEndpoint.properties.customDnsConfigs[0].fqdn}'
  properties:{
    ttl : 3600
    aRecords : [
      {
        ipv4Address : privateEndpoint.properties.customDnsConfigs[0].ipAddresses[0]
      }
    ]
  }
}
