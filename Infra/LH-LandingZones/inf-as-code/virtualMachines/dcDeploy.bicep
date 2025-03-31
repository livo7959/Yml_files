param location string = resourceGroup().location

@description('Password for the administrator')
@minLength(16)
@secure()
param adminPassword string

module vmDC 'modules/domainControllerEncryptedMain.bicep' = {
  name: 'azeuscorpdc002'
  params: {
    OSVersion: '2019-Datacenter'
    adminPassword: adminPassword
    computerName: 'azeuscorpdc002'
    snetName: 'snet-dc-eus-001'
    tagEnvironment: 'Production'
    vmName: 'azeuscorpdc002'
    vmSize: 'Standard_D4as_v5'
    vnetName: 'vnet-identity-eus-001'
    location: location
    adminUsername: 'lhadmin'
    tagDepartment: 'Infrastructure'
    existingVnetResourceGroupName: 'rg-net-identity-eus-001'
    availabilityZone: '2'
  }
}
