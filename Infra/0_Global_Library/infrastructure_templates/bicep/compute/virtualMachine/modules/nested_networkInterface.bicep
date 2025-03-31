param networkInterfaceName string
param virtualMachineName string
param location string
param tags object?
param enableIPForwarding bool = false
param enableAcceleratedNetworking bool = false
param dnsServers array = []

@description('Optional. The network security group (NSG) to attach to the network interface.')
param networkSecurityGroupResourceId string = ''

param ipConfigurations array
param lock lockType

@description('Optional. The diagnostic settings of the Network Interface.')
param diagnosticSettings diagnosticSettingType

var enableReferencedModulesTelemetry = false

module networkInterface '../../../networking/networkInterface/networkInterface.bicep' = {
  name: '${deployment().name}-NetworkInterface'
  params: {
    name: networkInterfaceName
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurations: {
      name: !empty(ipConfiguration.name) ? ipConfiguration.name : null
      primary: index == 0
      privateIPAllocationMethod: contains(ipConfiguration, 'privateIPAllocationMethod') ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : null) : null
      privateIPAddress: contains(ipConfiguration, 'privateIPAddress') ? (!empty(ipConfiguration.privateIPAddress) ? ipConfiguration.privateIPAddress : null) : null
      publicIPAddressResourceId: contains(ipConfiguration, 'pipconfiguration') ? resourceId('Microsoft.Network/publicIPAddresses', '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}') : null
      subnetResourceId: ipConfiguration.subnetResourceId
      loadBalancerBackendAddressPools: contains(ipConfiguration, 'loadBalancerBackendAddressPools') ? ipConfiguration.loadBalancerBackendAddressPools : null
      applicationSecurityGroups: contains(ipConfiguration, 'applicationSecurityGroups') ? ipConfiguration.applicationSecurityGroups : null
      applicationGatewayBackendAddressPools: contains(ipConfiguration, 'applicationGatewayBackendAddressPools') ? ipConfiguration.applicationGatewayBackendAddressPools : null
      gatewayLoadBalancer: contains(ipConfiguration, 'gatewayLoadBalancer') ? ipConfiguration.gatewayLoadBalancer : null
      loadBalancerInboundNatRules: contains(ipConfiguration, 'loadBalancerInboundNatRules') ? ipConfiguration.loadBalancerInboundNatRules : null
      privateIPAddressVersion: contains(ipConfiguration, 'privateIPAddressVersion') ? ipConfiguration.privateIPAddressVersion : null
      virtualNetworkTaps: contains(ipConfiguration, 'virtualNetworkTaps') ? ipConfiguration.virtualNetworkTaps : null
    }]
    location: location
    tags: tags
    diagnosticSettings: diagnosticSettings
    dnsServers: !empty(dnsServers) ? dnsServers : []
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    enableIPForwarding: enableIPForwarding
    lock: lock
    networkSecurityGroupResourceId: !empty(networkSecurityGroupResourceId) ? networkSecurityGroupResourceId : ''
  }
}

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
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to llLogs to collect all logs.')
    categoryGroup: string?
  }[]?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to AllMetrics to collect all metrics.')
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

