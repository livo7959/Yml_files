@description('Name of data collection rule')
param dcrName string

@description('Region of data collection rule')
param location string = resourceGroup().location

@description('Log Analytics Workspace Name')
param workspaceName string = 'log-azure-sentinel-eus'

@description('Log Analytics Worksapce Resource ID')
param workspaceResourceId string = 'e9f79d4f-5b55-4c50-9a58-d24e97b37b22'

resource dcr 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  name: dcrName
  location: location
  tags: {
    Department: 'Infrastructure'
    Application: 'Sentinel'
  }
  kind: 'Windows'
  properties: {
    dataCollectionEndpointId: 'string'
    dataFlows:[
      {
      destinations: [
        workspaceName
      ]
      streams: [
       'Microsoft-WindowsEvent'
      ]
    }
    ]
    dataSources: {
      windowsEventLogs: [
        {
          name: 'windowsEventLogs'
          streams: [
            'Microsoft-WindowsEvent'
          ]
          xPathQueries: [
            'Application!*[System[(Level=1 or Level=2)]]'
            'Security!*[System[(band(Keywords,4503599627370496))]]'
            'System!*[System[(Level=1 or Level=2)]]'
          ]
        }
      ]
    }
    description: 'Data collection rule for security events'
    destinations: {
      logAnalytics: [
        {
          name: workspaceName
          workspaceResourceId: workspaceResourceId
        }
      ]
    }
  }
}
