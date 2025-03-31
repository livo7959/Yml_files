
@description('Region to deploy resources to.')
param location string = resourceGroup().location

@description('Internal load balancer name.')
param internalLoadBalancerName string

@description('External boad Balancer name.')
param externalLoadBalancerName string

@description('Existing External Subnet Name')
param externalSubnetName string

@description('Existing Internal Subnet Name')
param internalSubnetName string

var internalLBPrivateIP  = '10.120.4.10'
var externalLBPublicIPName = 'pip-${externalLoadBalancerName}'

resource internalSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: internalSubnetName
}

resource externalSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: externalSubnetName
}

resource lbPublicIPAddress 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: externalLBPublicIPName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'statuc'
     publicIPAddressVersion: 'IPv4'
  }
}

resource loadBalancerInternal 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: internalLoadBalancerName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: internalLoadBalancerName
        properties: {
          privateIPAddress: internalLBPrivateIP
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: internalSubnet.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: '${internalLoadBalancerName}-backend-pool'
      }
    ]
    loadBalancingRules: [
      {
        name: '${internalLoadBalancerName}-lbrule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', internalLoadBalancerName, 'LoadBalancerFrontend')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', internalLoadBalancerName, 'backend-pool-001')
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', internalLoadBalancerName, 'lbprobe')
          }
        }
      }
    ]
    probes: [
      {
        name: '${internalLoadBalancerName}-probe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 15
          numberOfProbes: 2
        }
      }
    ]
  }
}

resource loadBalancerExternal 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: externalLoadBalancerName
  location: location
  sku:{
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: externalLoadBalancerName
        properties: {
          publicIPAddress: {
            id: lbPublicIPAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: '${externalLoadBalancerName}-backend-pool'
      }
    ]
    loadBalancingRules: [
      {
        name: '${externalLoadBalancerName}-lbrule'
        properties: {
          frontendIPConfiguration: {
             id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', externalLoadBalancerName, 'LoadBalancerFrontend')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', externalLoadBalancerName, 'backend-pool-001')
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: true
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', externalLoadBalancerName, 'lbprobe')
          }
        }
      }
    ]
    probes: [
      {
        name: '${externalLoadBalancerName}-probe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 15
          numberOfProbes: 2
        }
      }
    ]
  }
}
