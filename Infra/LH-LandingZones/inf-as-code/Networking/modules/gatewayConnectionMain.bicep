@description('Region of the connectection')
param location string = resourceGroup().location

@description('Name of the VPN-vNet connection')
param connectionName string = 'cn-vgw-hub-to-lgw-bed'

@description('Name of the existing Virtual Network Gateway')
param vgwName string = 'vgw-hub-eus-001'

@description('Name of the existing Local network Gateway')
param lgwName string = 'lgw-hub-eus-001'

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-07-01' existing = {
  name: vgwName
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-07-01' existing = {
  name: lgwName
}

resource vpnVnetConnection 'Microsoft.Network/connections@2022-07-01' = {
  name: connectionName
  location: location
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateway.id
      properties:{}
    }
    localNetworkGateway2: {
      id: localNetworkGateway.id
      properties:{}
    }
    connectionType: 'IPsec'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    sharedKey: 'sharedkey'
    ipsecPolicies: [
      {
        dhGroup: 'DHGroup14'
        ikeEncryption: 'AES256'
        ikeIntegrity: 'SHA256'
        ipsecEncryption: 'GCMAES256'
        ipsecIntegrity: 'GCMAES256'
        pfsGroup: 'None'
        saDataSizeKilobytes: 102400000
        saLifeTimeSeconds: 27000
      }
    ]
  }
}
