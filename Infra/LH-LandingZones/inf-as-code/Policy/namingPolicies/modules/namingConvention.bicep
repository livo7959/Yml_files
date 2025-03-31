targetScope = 'managementGroup'

@description('Text pattern to enforce')
param textPattern string

@description('Name of the policy')
param policyName string

@description('Display Name of the policy assignment. This is what shows in the Azure Portal')
param assignmentDisplayName string

@description('Policy assignment name, this must be 24 characters or less')
param assignmentName string

@description('Type')
param type string

@allowed([
  'Deny'
  'Audit'
  'Disabled'
])
@description('The effect determines what happens when the policy rule is evaluated to match')
param effect string = 'Deny'

@allowed([
  'Default'
  'DoNotEnforce'
])
@description('When enforcement mode is disabled, the policy effect isn\'t enforced (i.e. deny policy won\'t deny resources). Compliance assessment results are still available.')
param enforcementMode string = 'Default'

@description('Description of the Policy')
param policyDescription string

resource basePolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: policyName
  properties:{
    description: policyDescription
    displayName: policyName
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: type
          }
          {
            field: 'name'
            notlike: textPattern
          }
          
        ]
      }
      then:{
        effect: effect
      }
    }
  }
}

resource baseAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: assignmentName
  properties: {
    policyDefinitionId: basePolicy.id
    enforcementMode: enforcementMode
    displayName: assignmentDisplayName
  }
}
