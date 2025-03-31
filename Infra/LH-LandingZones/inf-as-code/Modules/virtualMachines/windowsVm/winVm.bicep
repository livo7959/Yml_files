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

@description('Tag values to be applied to resources in this deployment')
param tagValues object

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

@description('Password for the administrator')
@minLength(16)
@secure()
param adminPassword string

@description('Enable or disable Encryption at host')
param encryptionAtHost bool

@description('Data disks array')
param dataDisks array

// ----------------------------------------
// Variable declaration
var nicName = 'nic-${vmName}'

// ---------------------------------------
// Existing Resource Declaration

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
  scope: resourceGroup(existingVnetResourceGroupName)
}

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: snetName
  parent: vnet
}

// ----------------------------------------
// Resource Declaration

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
  tags: tagValues
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
        diskSizeGB: osDiskSizeGB
        managedDisk:{
          storageAccountType: 'Premium_LRS'
        }
      }
      dataDisks: [for dataDisk in dataDisks: {
          createOption: dataDisk.createOption
          lun: dataDisk.lun
          diskSizeGB: dataDisk.diskSizeGB
          caching: dataDisk.caching
           managedDisk: {
             storageAccountType: dataDisk.storageAccountType
           }
        }]
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
    securityProfile: {
      encryptionAtHost: encryptionAtHost
    }
  }
}


