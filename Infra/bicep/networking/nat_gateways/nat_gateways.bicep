param location string = resourceGroup().location
param environment_name string

param nat_gateways array

module ngw_public_ip '../public_ips/public_ip.bicep' = [for nat_gateway in nat_gateways: {
  name: 'pip-ngw-${nat_gateway.name}-${environment_name}'
  params: {
    environment_name: environment_name
    location: location
    name: 'pip-ngw-${nat_gateway.name}-${environment_name}'
    sku_name: nat_gateway.?pip.?env_overrides[?environment_name].?sku_name ?? nat_gateway.?pip.defaults.?sku_name ?? 'Standard'
    sku_tier: nat_gateway.?pip.?env_overrides[?environment_name].?sku_tier ?? nat_gateway.?pip.defaults.?sku_tier ?? 'Regional'
    availability_zones: nat_gateway.?pip.?env_overrides[?environment_name].?availability_zones ?? nat_gateway.?pip.defaults.?availability_zones ?? ['1', '2', '3']
    allocation_method: nat_gateway.?pip.?env_overrides[?environment_name].?allocation_method ?? nat_gateway.?pip.defaults.?allocation_method ?? 'Static'
    address_version: nat_gateway.?pip.?env_overrides[?environment_name].?address_version ?? nat_gateway.?pip.defaults.?address_version ?? 'IPv4'
    idle_timeout_minutes: nat_gateway.?pip.?env_overrides[?environment_name].?idle_timeout_minutes ?? nat_gateway.?pip.defaults.?idle_timeout_minutes ?? 4
  }
}]

resource ngw 'Microsoft.Network/natGateways@2023-05-01' = [for (nat_gateway, idx) in nat_gateways: {
  name: 'ngw-${nat_gateway.name}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  sku: {
    name: 'Standard' // only standard exists, can move to param if that changes
  }
  properties: {
    publicIpAddresses: [
      {
        id: ngw_public_ip[idx].outputs.pip
      }
    ]
    idleTimeoutInMinutes: nat_gateway.?idle_timeout_minutes ?? 4
  }
  dependsOn: [
    ngw_public_ip
  ]
}]
