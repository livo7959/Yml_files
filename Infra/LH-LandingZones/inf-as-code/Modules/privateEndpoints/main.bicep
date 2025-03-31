@description('Region of the private endpoint')
param location string = resourceGroup().location

@description('Environment of private endpoint')
@allowed([
  'prod'
  'uat'
  'qa'
  'dev'
  'sbox'
  'shared'
])
param env string

@description('Name of the private endpoint')
param privateEndpointName string

@description('Private endpoint group IDs. I.E Blob etc')
param privateEndpointGroupIds string

@description('Private endpoint virutal network name')
param virtualNetworkName string

@description('Private endpoint subnet name')
param subnetName string

@description('Resource ID of the resource to create the private endpoint for')
param privateEndpointTargetResourceId string

@description('Private DNS zone')
param privateDnsZoneName string

@description('Private DNS zone resource group name')
param privateDnsZoneResourceGroupName string

@description('Private Endpoint resource group name')
param privateEndpointResourceGroupName string

var tagValues = {
  environment: env
}

module pe 'privateEndpoint.bicep' = {
  name: privateEndpointName
  params: {
    location: location
    privateEndpointGroupIds: privateEndpointGroupIds
    privateEndpointName: privateEndpointName
    privateEndpointTargetResourceId: privateEndpointTargetResourceId
    subnetName: subnetName
    virtualNetworkName: virtualNetworkName
    tagValues: tagValues
    privateDnsZoneName: privateDnsZoneName
    privateDnsZoneResourceGroupName: privateDnsZoneResourceGroupName
    privateEndpointResourceGroupName: privateEndpointResourceGroupName
  }
}
