@description('The name of the key vault to be created.')
param vaultName string

type key = {
  keyName: string
  // The JsonWebKeyType of the key to be created.
  keyType: 'EC' | 'EC-HSM' | 'RSA' | 'RSA-HSM'
  @description('The permitted JSON web key operations of the key to be created.')
  keyOps: array?
  @description('The size in bits of the key to be created.')
  keySize: int
  curveName: '' | 'P-256' | 'P-256K' | 'P-384' | 'P-521'
}
param keys key[] 

type secret = {
  name: string
  value: string
}
param secrets secret[]

@description('The location of the resources')
param location string = resourceGroup().location

@description('The SKU of the vault to be created.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

param ipRules array = []
param virtualNetworkRules array = []

@allowed([
  'enabled'
  'disabled'
])
param publickNetworkAccess string

resource vault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: vaultName
  location: location
  properties: {
    accessPolicies:[]
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enablePurgeProtection: true
    publicNetworkAccess: publickNetworkAccess
    tenantId: subscription().tenantId
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: ipRules
      virtualNetworkRules: virtualNetworkRules
    }
  }
}

resource Keys 'Microsoft.KeyVault/vaults/keys@2023-02-01' = [ for (key, index) in keys: {
  parent: vault
  name: key.keyName
  properties: {
    kty: key.keyType
    keyOps: key.keyOps
    keySize: key.keySize
    curveName: key.curveName
  }
}]

resource Secrets 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = [ for (secret, index) in secrets: {
  parent: vault
  name: secret.name
  properties: {
    value: secret.value
  }
}]

@description('The resource ID of the key vault.')
output resourceId string = vault.id

@description('The name of the resource group the key vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the key vault.')
output name string = vault.name

// output proxyKey array = [ for key in devKey: key.properties ]
