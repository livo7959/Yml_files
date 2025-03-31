@description('Azure region for deployment')
param location string = resourceGroup().location

@description('If true Host Pool, App Group and Workspace will be created. Default is to join Session Hosts to existing AVD environment')
param newBuild bool = false

@description('Expiration time for the HostPool registration token. This must be up to 30 days from todays date.')
param hostPoolTokenExpirationTime string

@description('Host pool registration token operation')
@allowed([
  'Update'
  'Delete'
  'None'
])
param hostPoolRegistrationTokenOperation string

@description('Hostpool name')
param hostPoolName string

@description('Hostpool type')
@allowed([
  'BYODesktop'
  'Personal'
  'Pooled'
])
param hostPoolType string

@description('Load balancer type of the host pool')
@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param hostPoolloadBalancerType string

@description('Host pool preferred application group type')
@allowed([
  'Desktop'
  'None'
  'RailApplications'
])
param hostPoolAppGroupType string

@description('The maximum session limit of host pool')
param hostPoolMaxSessionLimit int

@description('Host pool friendly name')
param hostPoolFriendlyName string

@description('Public network access')
@allowed([
  'Enabled'
  'Disabled'
  'EnabledForClientsOnly'
  'EnabledForSessionHostsOnly'
])
param hostPoolPublicNetworkAccess string

@description('Flag to start VM on connection')
param hostPoolStartVmOnConnect bool

@description('Custom RDP property of host pool')
param hostPoolCustomRdpProperty string

@description('Host pool validation environment. Enabling sets host pool as a validation/test pool for first updates')
param hostPoolValidationEnvironment bool

@description('Application group name')
param applicationGroupName string

@description('Application group friendly name')
param applicationGroupFriendlyName string

@description('Application group type')
@allowed([
  'Desktop'
  'RemoteApp'
])
param applicationGroupType string

@description('Description of application group')
param applicationGroupDescription string = 'Created through Bicep'

@description('List of application group resource IDs to be added to Workspace. MUST add existing ones!')
param applicationGroupReferences string

@description('Workspace name')
param workspaceName string

var applicationGroupResourceID = array(resourceId('Microsoft.DesktopVirtualization/applicationgroups/', applicationGroupName))
var applicationGroupReferencesArr = applicationGroupReferences == '' ? applicationGroupResourceID : concat(split(applicationGroupReferences, ','), appGroupResourceID)

resource hostpool 'Microsoft.DesktopVirtualization/hostPools@2022-10-14-preview' = if (newBuild) {
  name: hostPoolName
  location: location
  properties: {
    hostPoolType: hostPoolType
    loadBalancerType: hostPoolloadBalancerType
    preferredAppGroupType: hostPoolAppGroupType
    friendlyName: hostPoolFriendlyName
    maxSessionLimit: hostPoolMaxSessionLimit
    publicNetworkAccess: hostPoolPublicNetworkAccess
    startVMOnConnect: hostPoolStartVmOnConnect
    customRdpProperty: hostPoolCustomRdpProperty
    validationEnvironment: hostPoolValidationEnvironment
    registrationInfo: {
      expirationTime: hostPoolTokenExpirationTime
      registrationTokenOperation: hostPoolRegistrationTokenOperation
      token: null
    }
  }
}

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2022-10-14-preview' = if (newBuild) {
  name: applicationGroupName
  location: location
  properties: {
    friendlyName: applicationGroupFriendlyName
    applicationGroupType: applicationGroupType
    hostPoolArmPath: resourceId('Microsoft.DesktopVirtualization/hostpools', hostPoolName)
    description: applicationGroupDescription
  }
  dependsOn: [
    hostpool
  ]
}

resource workspace 'Microsoft.DesktopVirtualization/workspaces@2022-10-14-preview' = if (newBuild) {
  name: workspaceName
  location: location
  properties: {
    applicationGroupReferences: applicationGroupReferencesArr
  }
  dependsOn: [
    applicationGroup
  ]
}
