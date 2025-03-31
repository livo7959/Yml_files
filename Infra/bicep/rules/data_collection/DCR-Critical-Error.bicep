
@description('Name of data collection rule')
param dcrName string

@description('Region of data collection rule')
param location string = resourceGroup().location

param workspaces_log_azure_sentinel_eus_externalid string = '/subscriptions/51298843-868a-4c67-a307-fc8f6b953ecd/resourceGroups/rg-sentinel-shared/providers/Microsoft.OperationalInsights/workspaces/log-azure-sentinel-eus'

resource ddcr 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  name: dcrName
  location: location
  kind: 'Windows'
  tags: {
    Department: 'Infrastructure'
    Application: 'Sentinel'
  }
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Application!*[System[(Level=1 or Level=2)]]'
            'Security!*[System[(band(Keywords,4503599627370496))]]'
            'System!*[System[(Level=1 or Level=2)]]'
          ]
          name: 'eventLogsDataSource'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaces_log_azure_sentinel_eus_externalid
          name: 'la--1178665619'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          'la--1178665619'
        ]
      }
    ]
  }
}
