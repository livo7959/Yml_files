param location string
param location_shortname string
param environment_name string
param databricks_workspace_config object
param databricks_workspace_name string
param databricks_managed_resource_group_id string
param databricks_key_vault_basename string

resource databricks_workspace_resource 'Microsoft.Databricks/workspaces@2023-02-01' = {
  location: location
  name: databricks_workspace_name
  sku: {
    name: databricks_workspace_config.sku_name
  }
  properties: {
      publicNetworkAccess: 'Disabled'
      parameters: {
        customVirtualNetworkId: {
          value: resourceId('Microsoft.Network/virtualNetworks', '${databricks_workspace_config.network.virtual_network}-${location_shortname}-${environment_name}')
        }
        customPublicSubnetName: {
          value: '${databricks_workspace_config.network.public_subnet}-${location_shortname}-${environment_name}'
        }
        customPrivateSubnetName: {
          value: '${databricks_workspace_config.network.private_subnet}-${location_shortname}-${environment_name}'
        }
        enableNoPublicIp: {
          value: true
        }
      }
      requiredNsgRules: 'NoAzureDatabricksRules'
      managedResourceGroupId: databricks_managed_resource_group_id
    }
  tags: {
    environment: environment_name
  }
}

resource databricks_access_connector 'Microsoft.Databricks/accessConnectors@2022-10-01-preview' = {
  name: databricks_workspace_name
  location: location
  tags: {
    environment: environment_name
  }
  identity: {
    type: 'SystemAssigned'
  }
}

module databricks_key_vault '../key_vault/vaults.bicep' = {
  name: 'databricks_key_vault_${databricks_workspace_config.workspace_name}'
  params: {
    location: location
    environment_name: environment_name
    key_vault_name: databricks_key_vault_basename
  }
}
