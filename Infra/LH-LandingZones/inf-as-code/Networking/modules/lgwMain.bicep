@description('Local Network Gateway Region')
param location string = resourceGroup().location

@description('Local network gateway name')
param lgwName string = 'lgw-hub-eus-001'

@description('IP Address of local gateway')
param gatewayIpAddress string = '66.97.189.250'

@description('Address space of the local network')
param localNetworkAddressSpace string = '10.10.0.0/16'

resource lgw 'Microsoft.Network/localNetworkGateways@2022-07-01' = {
  name:lgwName
  location: location
  properties: {
     gatewayIpAddress: gatewayIpAddress
     localNetworkAddressSpace: {
      addressPrefixes: [
        localNetworkAddressSpace
        '10.0.0.0/23'
        '10.0.24.0/23'
        '10.20.0.0/16'
        '192.168.160.0/24'
      ]
     }
  }
}
