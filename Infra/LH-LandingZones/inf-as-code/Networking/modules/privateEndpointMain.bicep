@description('Resource group location')
param location string = resourceGroup().location

@description('Private Endpoint Name')
param peName string

@description('Target sub resource')
param targetSubResource string = 'file'

var virtualNetworkID = '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-private-endpoint-eus-001/providers/Microsoft.Network/virtualNetworks/vnet-private-endpoint-eus-001'
var virtualNetworkRg = 'rg-private-endpoint-eus-001'
var peSubnetID = '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-private-endpoint-eus-001/providers/Microsoft.Network/virtualNetworks/vnet-private-endpoint-eus-001/subnets/snet-corp-fileshares-eus-001'
var peNicName = 'nic-${peName}'
var privatelinkResourceId = '/subscriptions/1148a73b-9055-4020-a3ad-00518ff5ed56/resourceGroups/rg-fileshares-itinfra-001/providers/Microsoft.Storage/storageAccounts/lhitinfrafileshares'


resource pe 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: peName
  location: location
  properties: {
    customNetworkInterfaceName: peNicName
    subnet: {
      id: peSubnetID
    }
    privateLinkServiceConnections: [
      {
        name: peName
        properties: {
          groupIds: [
            targetSubResource
          ]
          privateLinkServiceId: privatelinkResourceId
        }
      }
    ]
    ]
  }
}

resource dnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = {
  name: 
}
