metadata name = 'Network Interface'
metadata description = 'This module deploys a Network Interface.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the network interface.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Indicates whether IP forwarding is enabled on this network interface.')
param enableIPForwarding bool = false

@description('Optional. If the network interface is accelerated networking enabled.')
param enableAcceleratedNetworking bool = false

@description('Optional. List of DNS servers IP addresses. Use \'AzureProvidedDNS\' to switch to azure provided DNS resolution. \'AzureProvidedDNS\' value cannot be combined with other IPs, it must be the only value in dnsServers collection.')
param dnsServers array = []

@description('Optional. The network security group (NSG) to attach to the network interface.')
param networkSecurityGroupResourceId string = ''

@allowed([
  'Floating'
  'MaxConnections'
  'None'
])
@description('Optional. Auxiliary mode of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.')
param auxiliaryMode string = 'None'

@allowed([
  'A1'
  'A2'
  'A4'
  'A8'
  'None'
])
@description('Optional. Auxiliary sku of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.')
param auxiliarySku string = 'None'

@description('Optional. Indicates whether to disable tcp state tracking. Subscription must be registered for the Microsoft.Network/AllowDisableTcpStateTracking feature before this property can be set to true.')
param disableTcpStateTracking bool = false

@description('Required. A list of IPConfigurations of the network interface.')
param ipConfigurations array

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    auxiliaryMode: auxiliaryMode
    auxiliarySku: auxiliarySku
    disableTcpStateTracking: disableTcpStateTracking
    dnsSettings: !empty(dnsServers) ? {
      dnsServers: dnsServers
    } : null
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableIPForwarding: enableIPForwarding
    networkSecurityGroup: !empty(networkSecurityGroupResourceId) ? {
      id: networkSecurityGroupResourceId
    } : null
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurations: {
      name: contains(ipConfiguration, 'name') ? ipConfiguration.name : 'ipconfig0${index + 1}'
      properties: {
        primary: index == 0 ? true : false
        privateIPAllocationMethod: contains(ipConfiguration, 'privateIPAllocationMethod') ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : null) : null
        privateIPAddress: contains(ipConfiguration, 'privateIPAddress') ? (!empty(ipConfiguration.privateIPAddress) ? ipConfiguration.privateIPAddress : null) : null
        publicIPAddress: contains(ipConfiguration, 'publicIPAddressResourceId') ? (ipConfiguration.publicIPAddressResourceId != null ? {
          id: ipConfiguration.publicIPAddressResourceId
        } : null) : null
        subnet: {
          id: ipConfiguration.subnetResourceId
        }
        loadBalancerBackendAddressPools: contains(ipConfiguration, 'loadBalancerBackendAddressPools') ? ipConfiguration.loadBalancerBackendAddressPools : null
        applicationSecurityGroups: contains(ipConfiguration, 'applicationSecurityGroups') ? ipConfiguration.applicationSecurityGroups : null
        applicationGatewayBackendAddressPools: contains(ipConfiguration, 'applicationGatewayBackendAddressPools') ? ipConfiguration.applicationGatewayBackendAddressPools : null
        gatewayLoadBalancer: contains(ipConfiguration, 'gatewayLoadBalancer') ? ipConfiguration.gatewayLoadBalancer : null
        loadBalancerInboundNatRules: contains(ipConfiguration, 'loadBalancerInboundNatRules') ? ipConfiguration.loadBalancerInboundNatRules : null
        privateIPAddressVersion: contains(ipConfiguration, 'privateIPAddressVersion') ? ipConfiguration.privateIPAddressVersion : null
        virtualNetworkTaps: contains(ipConfiguration, 'virtualNetworkTaps') ? ipConfiguration.virtualNetworkTaps : null
      }
    }]
  }
}

resource networkInterface_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: diagnosticSetting.?metricCategories ?? [
      {
        category: 'AllMetrics'
        timeGrain: null
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: networkInterface
}]

resource networkInterface_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: networkInterface
}

@description('The name of the deployed resource.')
output name string = networkInterface.name

@description('The resource ID of the deployed resource.')
output resourceId string = networkInterface.id

@description('The resource group of the deployed resource.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = networkInterface.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to \'AllMetrics\' to collect all metrics.')
    category: string
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics' | null)?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
