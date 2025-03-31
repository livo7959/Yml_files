// ----------------------------------------
// Parameter declaration
@description('Application components these resources are part of.')
param component string

@description('Environment for deployment')
@allowed([
  'prod'
  'uat'
  'qa'
  'dev'
  'sbox'
])
param env string

@description('Current Date for deployment records. Do not overwrite!')
param currentDate string = utcNow('yyyy-MM-dd')

@description('Application product these resource are assigned too')
param product string

@description('Azure region for deployment.')
param location string = resourceGroup().location

@description('Dictionary of deployment regions and the shortname')
param locationList object

@description('Name of the vm at the Azure resource level')
param vmName string

@description('Name of the Computer within the OS')
param computerName string

@description('Sku of virtual machine')
param vmSize string

@description('OS Disk Size')
param osDiskSizeGB int

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version')
@allowed([
  '2019-Datacenter'
  '2019-Datacenter-Core'
  '2019-datacenter-core-g2'
  '2022-datacenter'
  '2022-datacenter-azure-edition'
  '2022-datacenter-azure-edition-core'
  '2022-datacenter-core'
  '2022-datacenter-core-g2'
  '2022-datacenter-g2'
])
param OSVersion string

@description('Existing virtual network resource group name')
param existingVnetResourceGroupName string

@description('Name of the EXISTING virtual network')
param vnetName string

@description('Name of the EXISTING subnet')
param snetName string

@description('Username for the administrator')
param adminUsername string = 'lhadmin'

@description('Enable or disable Encryption at host')
param encryptionAtHost bool

@description('Data disks array')
param dataDisks array

@description('Password for the administrator')
@minLength(16)
@secure()
param adminPassword string

// ----------------------------------------
// Variable declaration
var groupName = '${product}-${component}'
var environmentName = '${groupName}-${env}-${locationShortName}'
var resourceGroupName = 'rg-${environmentName}-001'
var locationShortName = locationList[location]
var tagValues = {
  createdBy: 'AZ CLI'
  environment: env
  deploymentDate: currentDate
  product: product
}

module winVM 'winVm.bicep' = {
  name: vmName
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
    component: component
    computerName: computerName
    dataDisks: dataDisks
    env: env
    existingVnetResourceGroupName: existingVnetResourceGroupName
    OSVersion: OSVersion
    product: product
    snetName: snetName
    tagValues: tagValues
    vmName: vmName
    vmSize: vmSize
    vnetName: vnetName
    osDiskSizeGB: osDiskSizeGB
    encryptionAtHost: encryptionAtHost
  }
}
