

var workspaceResourceId = '/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-lh-logging-001/providers/Microsoft.OperationalInsights/workspaces/lh-log-analytics'



@description('Generated from /subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-lh-logging-001/providers/microsoft.insights/dataCollectionRules/dcr-security-events-baseline')
resource dcrsecurityeventsbaseline 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-WindowsEvent'
          ]
          xPathQueries: [
            'Security!*[System[(EventID=1102) or (EventID=4624) or (EventID=4625) or (EventID=4657) or (EventID=4663) or (EventID=4688) or (EventID=4700) or (EventID=4702) or (EventID=4719) or (EventID=4720) or (EventID=4722) or (EventID=4723) or (EventID=4724) or (EventID=4727) or (EventID=4728)]]'
            'Security!*[System[(EventID=4732) or (EventID=4735) or (EventID=4737) or (EventID=4739) or (EventID=4740) or (EventID=4754) or (EventID=4755) or (EventID=4756) or (EventID=4767) or (EventID=4799) or (EventID=4825) or (EventID=4946) or (EventID=4948) or (EventID=4956) or (EventID=5024)]]'
            'Security!*[System[(EventID=5033) or (EventID=8222)]]'
            'Microsoft-Windows-AppLocker/EXE and DLL!*[System[(EventID=8001) or (EventID=8002) or (EventID=8003) or (EventID=8004)]]'
            'Microsoft-Windows-AppLocker/MSI and Script!*[System[(EventID=8005) or (EventID=8006) or (EventID=8007)]]'
          ]
          name: 'eventLogsDataSource'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'DataCollectionEvent'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-SecurityEvent'
        ]
        destinations: [
          'DataCollectionEvent'
        ]
      }
    ]
  }
  location: 'eastus'
  tags: {
    createdBy: 'Sentinel'
  }
  kind: 'Windows'
  name: 'dcr-security-events-baseline'
}
