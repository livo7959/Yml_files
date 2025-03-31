param location string
param location_shortname string
param environment_name string

param network_security_groups array

resource network_security_group_resources 'Microsoft.Network/networkSecurityGroups@2022-09-01' = [ for network_security_group in network_security_groups: {
  name: '${network_security_group.name}-${location_shortname}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  properties: {
    flushConnection: false
  }
}]

module security_rules_resources './security_rules.bicep' = [ for network_security_group in network_security_groups: {
  name: network_security_group.name
  params: {
    security_rules: network_security_group.?security_rules ?? []
    security_group_name: '${network_security_group.name}-${location_shortname}-${environment_name}'
  }
  dependsOn: [
    network_security_group_resources
  ]
}]
