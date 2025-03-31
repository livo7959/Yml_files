targetScope = 'subscription'

param rgName string = 'rg-terraform-state-shared'
param location string = deployment().location

resource terraformStateRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

var sharedVars = loadYamlContent('./shared-vars.yml')

module tfstateStorageAccount '../../../0_Global_Library/infrastructure_templates/bicep/storage/storageAccount/saBlobServices/saBlobServices.bicep' = {
  scope: terraformStateRG
  name: 'lhtfstateshared'
  params: {
    tags: {
      environment: sharedVars.environment
    }
    location: terraformStateRG.location
    name: 'lhtfstateshared'
    allowCrossTenantReplication: false
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    sku: 'Standard_ZRS'
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
    storageRoleAssignments: [
      {
        principalId: '07076dd2-2a2d-4b97-a529-b845ddc3c016'
        roleDefinitionIdOrName: 'LH Storage Account Key List Operator'
        principalType: 'Group'
      }
    ]
    blobContainers: [
      {
        name: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        properties: {
          publicAccess: 'None'
        }
      }
      {
        name: '59161e1f-62f6-456e-93d6-162d6f3c6d91-tfstate' // Subscription: LH-Sandbox-Infra-001
        properties: {
          publicAccess: 'None'
        }
      }
      {
        name: 'bf6bb924-c903-43e9-9e06-2c2d2c605d1a-tfstate' // Subscription: LH-Corp-Dev-001
        properties: {
          publicAccess: 'None'
        }
      }
      {
        name: 'f533a95b-ce94-4023-a472-ab4c3748b37c-tfstate' // Subscription: LH-Corp-Prod-001
        properties: {
          publicAccess: 'None'
        }
      }
      {
        name: '32759c43-ba2f-4ddc-8298-c1e77c1cfb35-tfstate' // Subscription: LH-VDI-Sub-001
        properties: {
          publicAccess: 'None'
        }
      }
      {
        name: '4cd6ebc5-58d1-40fc-98dc-8645df2ffcc4-tfstate' // Subscription: LH-Corp-Shared-001
        properties: {
          publicAccess: 'None'
        }
      }
    ]
    containerRoleAssignments: [
      {
        containerName: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        principalId: '2e8f9de1-6bdc-4f63-855d-eb1fa365ea0d'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: '59161e1f-62f6-456e-93d6-162d6f3c6d91-tfstate' // Subscription: LH-Sandbox-Infra-001
        principalId: '7c3e99ad-c3ca-4bdf-8ba7-fa7c7b92076f' // Object ID for: sp-azdo-lhSandboxInfra001
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: 'bf6bb924-c903-43e9-9e06-2c2d2c605d1a-tfstate' // Subscription: LH-Corp-Dev-001
        principalId: '50688df7-9072-461d-8978-4bf415e8866f'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: 'f533a95b-ce94-4023-a472-ab4c3748b37c-tfstate' // Subscription: LH-Corp-Prod-001
        principalId: '2ff9c1ad-76b1-4a62-8200-1f8cf3270b55'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: '32759c43-ba2f-4ddc-8298-c1e77c1cfb35-tfstate' // Subscription: LH-VDI-Sub-001
        principalId: '8dbb7447-a7f1-4454-a49f-4c4f697c4011'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: '4cd6ebc5-58d1-40fc-98dc-8645df2ffcc4-tfstate' // Subscription: LH-Corp-Shared-001
        principalId: 'e3d2db81-b345-4510-b275-f71ac70894df'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        principalId: 'a7abc731-d062-4cc1-af10-0b11bd3dc192'
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        principalType: 'Group'
      }
      {
        containerName: 'bf6bb924-c903-43e9-9e06-2c2d2c605d1a-tfstate' // Subscription: LH-Corp-Dev-001
        principalId: 'a81df436-743e-4277-8b1b-3578a811ce96'
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        principalType: 'Group'
      }
      {
        containerName: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        principalId: '89ac18c3-ef5f-4b27-a693-f522021bba2d'
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'Group'
      }
      {
        containerName: 'bf6bb924-c903-43e9-9e06-2c2d2c605d1a-tfstate' // Subscription: LH-Corp-Dev-001
        principalId: 'af9c6ab4-fb32-45f8-8dda-fcbda9962eec'
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'Group'
      }

      // sp-azdo-lhSandboxData001
      {
        containerName: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        principalId: '6906d294-5a5a-4a79-a650-0f11b86c0969' // Object ID for: sp-azdo-lhSandboxData001
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        principalId: '6906d294-5a5a-4a79-a650-0f11b86c0969' // Object ID for: sp-azdo-lhSandboxData001
        roleDefinitionIdOrName: 'LH Storage Account Key List Operator'
        principalType: 'Group'
      }

      // sp-azdo-lhSandboxDev001
      {
        containerName: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        principalId: '9fe00ab2-26ab-41cd-85aa-6460e2c0661e' // Object ID for: sp-azdo-lhSandboxDev001
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        principalType: 'ServicePrincipal'
      }
      {
        containerName: '8192a5d8-1a56-4caf-b961-0eae16cbd1d3-tfstate' // Subscription: LH-Sandbox-Data-001
        principalId: '9fe00ab2-26ab-41cd-85aa-6460e2c0661e' // Object ID for: sp-azdo-lhSandboxDev001
        roleDefinitionIdOrName: 'LH Storage Account Key List Operator'
        principalType: 'Group'
      }
    ]
  }
}

output saID string = tfstateStorageAccount.outputs.id
output saName string = tfstateStorageAccount.name
