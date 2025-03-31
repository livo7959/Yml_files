param location string
param host_plan_name string
param host_plan_id string
param function_apps array
param environment_name string

resource app_insights 'Microsoft.Insights/components@2020-02-02' = {
  name: host_plan_name
  location: location
  tags: {
    environment: environment_name
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
    DisableLocalAuth: true
    IngestionMode: 'ApplicationInsights'
    Request_Source: 'rest'
    RetentionInDays: 30
  }
}

module function_app_resources './function_app.bicep' = [ for function_app in function_apps: {
  name: '${function_app.name}-${environment_name}'
  params: {
    location: location
    environment_name: environment_name
    function_app: function_app
    host_plan_id: host_plan_id
    app_insights_instrumentation_key: app_insights.properties.InstrumentationKey
  }
}]
