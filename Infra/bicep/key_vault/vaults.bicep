param location string
param environment_name string

param key_vault_name string

resource key_vault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: '${key_vault_name}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  properties: {
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '66.97.189.250'
        }
      ]
    }
    publicNetworkAccess: 'Enabled'
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: tenant().tenantId
  }
}

output key_vault_name string = key_vault.name
