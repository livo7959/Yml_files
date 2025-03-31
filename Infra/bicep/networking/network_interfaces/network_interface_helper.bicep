param location string
param nic_name string
param utc_time string = utcNow('u')

var script_content = 'output=$(az network nic list --resource-group ${resourceGroup().name} --query "[?name==\'${nic_name}\']" | jq \'. | length\'); outputJson=$(jq -n --arg resource_exists "$output" \'{resource_exists: $resource_exists}\'); echo $outputJson > $AZ_SCRIPTS_OUTPUT_PATH'

resource check_script 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'check_NIC_existence'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.52.0'
    forceUpdateTag: utc_time
    scriptContent: script_content
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
    timeout: 'PT5M'
  }
}

output nic_exists string = check_script.properties.outputs.resource_exists
