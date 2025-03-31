@description('Region of the Data Collection Rule')
param location string = resourceGroup().location

@description('Name of the data collection rule')
param dataCollectionRuleName string

@description('Data collection rule OS type')
@allowed([
  'Windows'
  'Linux'
])
param dcrKind string

@description('Event logs to stream from the Windows Server')
@allowed([
  'Microsoft-WindowsEvent'
  'Microsoft-Event'
])
param sourceStream string

@description('Name of your data source')
param dataSourceName string

@description('Name of the event destination')
param eventDestinationName string

@description('Stream of the destination log analytics workspace')
@allowed([
  'Microsoft-Event'
  'Microsoft-InsightsMetrics'
  'Microsoft-Perf'
  'Microsoft-Syslog'
  'Microsoft-WindowsEvent'
  'Microsoft-SecurityEvent'
])
param destinationStream string

@description('Log analytics workspace name')
param logAnalyticsWorkspaceName string

@description('xPath Queries')
param xPathQuery string

@description('Private Endpoint Tags')
param dcrTags object

resource logAnalyticsWorkspaceResourceId 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dataCollectionRuleName
  location: location
  kind: dcrKind
  tags: dcrTags
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          name: dataSourceName
          streams: [
            sourceStream
          ]
          xPathQueries: [
            xPathQuery
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: eventDestinationName
          workspaceResourceId: logAnalyticsWorkspaceResourceId.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          destinationStream
        ]
        destinations: [
          'DataCollectionEvent'
        ]
      }
    ]
  }
}

