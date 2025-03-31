param location string = resourceGroup().location

@description('IP Group name')
param ipgName string

@description('Application of IP Group. I.E AD DS, HTTPS Internet access etc')
param tagUsage string

@description('Array of IP Addresses or Ranges for access')
param ipAddresses array

resource ipg 'Microsoft.Network/ipGroups@2022-07-01' = {
  name: ipgName
  location: location
  tags: {
    Usage: tagUsage
  }
  properties: {
    ipAddresses: ipAddresses
  }
}
