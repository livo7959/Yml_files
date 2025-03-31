param location string
param environment_name string

param hosting_plans array

resource host_plan_resources 'Microsoft.Web/serverfarms@2022-03-01' = [for hosting_plan in hosting_plans: {
  name: '${hosting_plan.name}-${environment_name}'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
  tags: {
    environment: environment_name
  }
}]

module function_resources './app_insights.bicep' = [ for (hosting_plan, idx) in hosting_plans: {
  name: host_plan_resources[idx].name
  params: {
    location: location
    environment_name: environment_name
    function_apps: hosting_plan.function_apps
    host_plan_name: host_plan_resources[idx].name
    host_plan_id: host_plan_resources[idx].id
  }
  dependsOn: [
    host_plan_resources
  ]
}]
