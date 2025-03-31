param security_group_name string
param security_rules array

// Reference to the parent resource
resource security_group_resource 'Microsoft.Network/networkSecurityGroups@2022-09-01' existing = {
  name: security_group_name
}

resource security_rules_resources 'Microsoft.Network/networkSecurityGroups/securityRules@2022-09-01' = [ for security_rule in security_rules : {
  name: '${security_rule.name}'
  parent: security_group_resource
  properties: {
    access: security_rule.access
    description: security_rule.?description ?? ''
    destinationAddressPrefix: security_rule.?destinationAddressPrefix ?? ''
    destinationAddressPrefixes: security_rule.?destinationAddressPrefixes ?? []
    destinationPortRange: security_rule.?destinationPortRange ?? ''
    destinationPortRanges: security_rule.?destinationPortRanges ?? []
    direction: security_rule.direction
    priority: security_rule.priority
    protocol: security_rule.protocol
    sourceAddressPrefix: security_rule.?sourceAddressPrefix ?? ''
    sourceAddressPrefixes: security_rule.?sourceAddressPrefixes ?? []
    sourcePortRange: security_rule.?sourcePortRange ?? ''
    sourcePortRanges: security_rule.?sourcePortRanges ?? []
  }
}]
