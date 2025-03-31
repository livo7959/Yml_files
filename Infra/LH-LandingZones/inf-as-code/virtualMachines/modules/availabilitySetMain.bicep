@description('resource group to deploy to')
param location string = resourceGroup().location

@description('Name of AvailabilitySet')
param availabilitySetName string

resource availabilitySet 'Microsoft.Compute/availabilitySets@2022-11-01' = {
  name: availabilitySetName
  location: location
  sku: {
    name: 'Aligned'
    tier: 'Standard'
  }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 4
  }
}
