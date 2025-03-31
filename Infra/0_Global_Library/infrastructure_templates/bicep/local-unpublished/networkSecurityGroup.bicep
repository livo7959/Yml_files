metadata overview ='wrapper for Bicep Public Registry/modules/network/virtual-network@1.1.3'

targetScope = 'resourceGroup'

// reference: https://github.com/Azure/ResourceModules/tree/v0.11.1/modules/network/network-security-group

@description('Specifies the location for resources. Defaults to the resource group\'s location.')
param location string = resourceGroup().location

@description('Specifies how the NSG(s) will be used')
param usage string

@description('Specifies the number iteration to append to the resource. Defaults to "01".')
param resourceNameIter string = '01'

param securityRules array = []

param tags object = {}

module networkSecurityGroup '../carml/v0.11.1/network/network-security-group/main.bicep' = {
  name: 'nsg-${usage}-${resourceNameIter}-${uniqueString(deployment().name, location)}'
  params: {
    // Required parameters
    name: 'nsg-${usage}-${resourceNameIter}'
    location: location
    // Non-required parameters
    // diagnosticEventHubAuthorizationRuleId: ''
    // diagnosticEventHubName: ''
    // diagnosticStorageAccountId: ''
    // diagnosticWorkspaceId: ''
    enableDefaultTelemetry: false
    lock: ''
    roleAssignments: []
    securityRules: securityRules
    // securityRules: [
    //   {
    //     name: 'Specific'
    //     properties: {
    //       access: 'Allow'
    //       description: 'Tests specific IPs and ports'
    //       destinationAddressPrefix: '*'
    //       destinationPortRange: '8080'
    //       direction: 'Inbound'
    //       priority: 100
    //       protocol: '*'
    //       sourceAddressPrefix: '*'
    //       sourcePortRange: '*'
    //     }
    //   }
    //   {
    //     name: 'Ranges'
    //     properties: {
    //       access: 'Allow'
    //       description: 'Tests Ranges'
    //       destinationAddressPrefixes: [
    //         '10.2.0.0/16'
    //         '10.3.0.0/16'
    //       ]
    //       destinationPortRanges: [
    //         '90'
    //         '91'
    //       ]
    //       direction: 'Inbound'
    //       priority: 101
    //       protocol: '*'
    //       sourceAddressPrefixes: [
    //         '10.0.0.0/16'
    //         '10.1.0.0/16'
    //       ]
    //       sourcePortRanges: [
    //         '80'
    //         '81'
    //       ]
    //     }
    //   }
    //   {
    //     name: 'Port_8082'
    //     properties: {
    //       access: 'Allow'
    //       description: 'Allow inbound access on TCP 8082'
    //       destinationApplicationSecurityGroups: [
    //         {
    //           id: '<id>'
    //         }
    //       ]
    //       destinationPortRange: '8082'
    //       direction: 'Inbound'
    //       priority: 102
    //       protocol: '*'
    //       sourceApplicationSecurityGroups: [
    //         {
    //           id: '<id>'
    //         }
    //       ]
    //       sourcePortRange: '*'
    //     }
    //   }
    // ]
    tags: tags
  }
}

@description('The resource group the network security group was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the network security group.')
output resourceId string = networkSecurityGroup.outputs.resourceId

@description('The name of the network security group.')
output name string = networkSecurityGroup.outputs.name

@description('The location the resource was deployed into.')
output location string = networkSecurityGroup.outputs.location
