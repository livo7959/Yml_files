param environment_name string
param location string
param network_interface_name string
param subnet_id string

var nic_name = 'nic-pep-${network_interface_name}-${environment_name}'

resource network_interfaces 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: nic_name
  location: location
  tags: {
    environment: environment_name
  }
  properties: {
    nicType: 'Standard'
    enableIPForwarding: false
    enableAcceleratedNetworking: false
    disableTcpStateTracking: false
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
    dnsSettings:{
      dnsServers: []
    }
    ipConfigurations: [
      {
        name: 'ipConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          primary: true
          subnet: {
            id: subnet_id
          }
        }
      }
    ]
  }
}
