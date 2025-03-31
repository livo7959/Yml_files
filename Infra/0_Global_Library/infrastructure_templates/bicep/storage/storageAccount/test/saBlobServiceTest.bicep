targetScope = 'subscription'

param location string = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-tfstate-test'
  location: location
}

module blobServices '../saBlobServices/saBlobServices.bicep' = {
  name: 'lhsttfstatetest'
  scope: rg
  params: {
    tags: {
      environment: 'sbox'
    }
    location: rg.location
    name: 'lhtfstatetest'
    allowCrossTenantReplication: false
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    sku: 'Standard_GZRS'
    kind: 'StorageV2'
    enablePublicNetworkAccess: true
    supportHttpsTrafficOnly: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipAllowlist: [
        '66.97.189.250'
      ]
    }
    blobServiceProperties: {
      isVersioningEnabled: true
      changeFeed: {
        enabled: true
        retentionInDays: 30
      }
      restorePolicy: {
        enabled: true
        days: 30
      }
      deleteRetentionPolicy: {
        allowPermanentDelete: false
        enabled: true
        days: 90
      }
    }
    blobContainers: [
      {
        name: 'tfstate-subid001'
        properties: {
          publicAccess: 'None' 
        }
      }
      {
        name: 'tfstate-subid002'
        properties: {
          publicAccess: 'None'
        }
      }
    ]
    containerRoleAssignments: [
      {
        containerName: 'tfstate-subid001'
        principalId: 'b26d3edd-673c-4988-b46a-d75adf14678e'
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'User'
      }
    ]
  }
}

output saID string = blobServices.outputs.id
output saName string = blobServices.name
