param location string = resourceGroup().location
param environment_name string

param name string
param sku_name string
param sku_tier string
param availability_zones array
param allocation_method string
param idle_timeout_minutes int
param address_version string

resource publicip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: name
  location: location
  tags: {
    environment: environment_name
  }
  sku: {
    name: sku_name
    tier: sku_tier
  }
  zones: availability_zones
  properties: {
    publicIPAllocationMethod: allocation_method
    idleTimeoutInMinutes: idle_timeout_minutes
    publicIPAddressVersion: address_version
  }
}

output pip string = publicip.id
