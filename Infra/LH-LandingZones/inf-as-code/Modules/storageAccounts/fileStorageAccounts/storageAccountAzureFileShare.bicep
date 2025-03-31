@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Name of the storage account. Must be lowercase and 3-15 characters')
param storageAccountName string

@description('Current Date for deployment records. Do not overwrite!')
param currentDate string = utcNow('yyyy-MM-dd')

@description('Environment for deployment')
@allowed([
  'prod'
  'uat'
  'qa'
  'dev'
])
param environment string

@description('Storage account Sku')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountSku string

@description('Kind of storage account')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param storageAccountKind string

@description('Storage Account Access tier')
@allowed([
  'Hot'
  'Cool'
  'Premium'
])
param accessTier string

@description('Enable or Disable large file shares')
@allowed([
  'Enabled'
  'Disabled'
])
param largeFileShareState string

@description('Allow Public Blob Access')
param allowPublicBlobAccess bool = false

@description('Allow Public Network Access')
@allowed([
  'Enabled'
  'Disabled'
])
param allowPublicNetworkAccess string

@description('Allowed public IPs I.E 66.97.189.250')
param allowedIpAddresses string

@description('Active Directory services options')
@allowed([
  'AD'
  'AADKERB'
  'None'
])
param activeDirectoryServicesOptions string

@description('Active Directory domain GUID')
param activeDirectoryDomainGuid string

@description('Active Directory domain name')
param activeDirectoryDomainName string

@description('Azure file shares array')
param azureFileShares array

var tagValues = {
  environment: environment
  deploymentDate: currentDate
} 

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  tags: tagValues
  sku: {
    name: storageAccountSku
  }
  kind: storageAccountKind
  properties: {
    accessTier: accessTier
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: allowPublicBlobAccess
    publicNetworkAccess: allowPublicNetworkAccess
    largeFileSharesState: largeFileShareState
    networkAcls: {
      defaultAction:'Deny'
      bypass: 'AzureServices'
      ipRules: [
        {
          value: allowedIpAddresses
          action: 'Allow'
        }
      ]
    }
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: activeDirectoryServicesOptions
      activeDirectoryProperties: {
        domainGuid: activeDirectoryDomainGuid
        domainName: activeDirectoryDomainName
      }
    }
  }
}

resource azfsprod001 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = [ for azureFileShare in azureFileShares:{
  name: '${storageAccount.name}/default/${azureFileShare.name}'
  properties: {
    accessTier: azureFileShare.accessTier
    enabledProtocols: azureFileShare.enabledProtocols
    shareQuota: azureFileShare.shareQuota
  }
} ]

