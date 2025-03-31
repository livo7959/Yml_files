/* 
This bicep file will be used for deploying Domain Controllers
Recommended DC configurations in Azure
https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/identity/adds-extend-domain
*/

targetScope = 'resourceGroup'

@description('Name of Virtual Machine in the Azure portal')
param vmName string

@description('Name of the Computer within the OS')
param computerName string

@description('Sku of virtual machine')
param vmSize string

@description('resource group to deploy to')
param location string = resourceGroup().location

@description('Department Tag')
param tagDepartment string = 'Infrastructure'

@description('Environment tag')
@allowed([
  'Production'
  'Development'
  'UAT'
  'QA'
])
param tagEnvironment string

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

@description('Password for the administrator')
@minLength(16)
@secure()
param adminPassword string

@description('Availability Zone')
param availabilityZone string

// Variables

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName = 'nic-${vmName}'

// Define Exisitng Resources

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
  scope: resourceGroup(existingVnetResourceGroupName)
}

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: snetName
  parent: vnet
}

resource nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations:[
      {
      name: 'ipconfig1'
      properties: {
        privateIPAllocationMethod: 'Dynamic'
        subnet: {
          id: snet.id
        }
        primary: true
        privateIPAddressVersion: 'IPv4'
      }
    }
  ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: location
  tags: {
    Department: tagDepartment
    Environment: tagEnvironment
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'FromImage'
        diskSizeGB: 128
        managedDisk:{
          storageAccountType: 'Premium_LRS'
        }
      }
      dataDisks:[
        {
          createOption: 'Empty'
          lun: 0
          diskSizeGB: 16
          caching: 'None'
           managedDisk: {
             storageAccountType: 'Premium_LRS'
           }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true 
      }
    }
  }
  zones: [
    availabilityZone
  ]
}



