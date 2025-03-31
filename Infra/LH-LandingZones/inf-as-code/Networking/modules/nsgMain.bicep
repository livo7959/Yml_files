targetScope = 'resourceGroup'

@description('Name of Network Security Group')
param nsgName string

param location string = resourceGroup().location

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgName
  location: location
  tags: {

  }
  properties: {
    securityRules: [
      {
        name: 'nsg1'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Icmp'
          destinationPortRanges: [
            
          ]
        }
      }
    ]
  }
}
