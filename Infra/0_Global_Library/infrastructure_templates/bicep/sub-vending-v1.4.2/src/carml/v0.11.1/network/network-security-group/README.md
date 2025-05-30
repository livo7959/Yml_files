# Network Security Groups `[Microsoft.Network/networkSecurityGroups]`

This module deploys a Network security Group (NSG).

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type                                           | API Version                                                                                                                      |
| :------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------- |
| `Microsoft.Authorization/locks`                         | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)                         |
| `Microsoft.Authorization/roleAssignments`               | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)               |
| `Microsoft.Insights/diagnosticSettings`                 | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/networkSecurityGroups`               | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkSecurityGroups)               |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkSecurityGroups/securityRules) |

## Parameters

**Required parameters**

| Parameter Name | Type   | Description                         |
| :------------- | :----- | :---------------------------------- |
| `name`         | string | Name of the Network Security Group. |

**Optional parameters**

| Parameter Name                          | Type   | Default Value                | Allowed Values                                                              | Description                                                                                                                                                                                                                                                                                                                                                                                           |
| :-------------------------------------- | :----- | :--------------------------- | :-------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''`                         |                                                                             | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.                                                                                                                                                                                                                                                      |
| `diagnosticEventHubName`                | string | `''`                         |                                                                             | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.                                                                                                                                                                                                                                                        |
| `diagnosticLogCategoriesToEnable`       | array  | `[allLogs]`                  | `['', allLogs, NetworkSecurityGroupEvent, NetworkSecurityGroupRuleCounter]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.                                                                                                                                                                                                                                                                   |
| `diagnosticSettingsName`                | string | `''`                         |                                                                             | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".                                                                                                                                                                                                                                                                                   |
| `diagnosticStorageAccountId`            | string | `''`                         |                                                                             | Resource ID of the diagnostic storage account.                                                                                                                                                                                                                                                                                                                                                        |
| `diagnosticWorkspaceId`                 | string | `''`                         |                                                                             | Resource ID of the diagnostic log analytics workspace.                                                                                                                                                                                                                                                                                                                                                |
| `enableDefaultTelemetry`                | bool   | `True`                       |                                                                             | Enable telemetry via a Globally Unique Identifier (GUID).                                                                                                                                                                                                                                                                                                                                             |
| `flushConnection`                       | bool   | `False`                      |                                                                             | When enabled, flows created from Network Security Group connections will be re-evaluated when rules are updates. Initial enablement will trigger re-evaluation. Network Security Group connection flushing is not available in all regions.                                                                                                                                                           |
| `location`                              | string | `[resourceGroup().location]` |                                                                             | Location for all resources.                                                                                                                                                                                                                                                                                                                                                                           |
| `lock`                                  | string | `''`                         | `['', CanNotDelete, ReadOnly]`                                              | Specify the type of lock.                                                                                                                                                                                                                                                                                                                                                                             |
| `roleAssignments`                       | array  | `[]`                         |                                                                             | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `securityRules`                         | array  | `[]`                         |                                                                             | Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.                                                                                                                                                                                                                                                        |
| `tags`                                  | object | `{object}`                   |                                                                             | Tags of the NSG resource.                                                                                                                                                                                                                                                                                                                                                                             |

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name         | Type   | Description                                                      |
| :------------------ | :----- | :--------------------------------------------------------------- |
| `location`          | string | The location the resource was deployed into.                     |
| `name`              | string | The name of the network security group.                          |
| `resourceGroupName` | string | The resource group the network security group was deployed into. |
| `resourceId`        | string | The resource ID of the network security group.                   |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.

> **Note**: The name of each example is based on the name of the file from which it is taken.

> **Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module networkSecurityGroup './network/network-security-group/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nnsgcom'
  params: {
    // Required parameters
    name: 'nnsgcom001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    securityRules: [
      {
        name: 'Specific'
        properties: {
          access: 'Allow'
          description: 'Tests specific IPs and ports'
          destinationAddressPrefix: '*'
          destinationPortRange: '8080'
          direction: 'Inbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Ranges'
        properties: {
          access: 'Allow'
          description: 'Tests Ranges'
          destinationAddressPrefixes: [
            '10.2.0.0/16'
            '10.3.0.0/16'
          ]
          destinationPortRanges: [
            '90'
            '91'
          ]
          direction: 'Inbound'
          priority: 101
          protocol: '*'
          sourceAddressPrefixes: [
            '10.0.0.0/16'
            '10.1.0.0/16'
          ]
          sourcePortRanges: [
            '80'
            '81'
          ]
        }
      }
      {
        name: 'Port_8082'
        properties: {
          access: 'Allow'
          description: 'Allow inbound access on TCP 8082'
          destinationApplicationSecurityGroups: [
            {
              id: '<id>'
            }
          ]
          destinationPortRange: '8082'
          direction: 'Inbound'
          priority: 102
          protocol: '*'
          sourceApplicationSecurityGroups: [
            {
              id: '<id>'
            }
          ]
          sourcePortRange: '*'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nnsgcom001"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": ["<managedIdentityPrincipalId>"],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "securityRules": {
      "value": [
        {
          "name": "Specific",
          "properties": {
            "access": "Allow",
            "description": "Tests specific IPs and ports",
            "destinationAddressPrefix": "*",
            "destinationPortRange": "8080",
            "direction": "Inbound",
            "priority": 100,
            "protocol": "*",
            "sourceAddressPrefix": "*",
            "sourcePortRange": "*"
          }
        },
        {
          "name": "Ranges",
          "properties": {
            "access": "Allow",
            "description": "Tests Ranges",
            "destinationAddressPrefixes": ["10.2.0.0/16", "10.3.0.0/16"],
            "destinationPortRanges": ["90", "91"],
            "direction": "Inbound",
            "priority": 101,
            "protocol": "*",
            "sourceAddressPrefixes": ["10.0.0.0/16", "10.1.0.0/16"],
            "sourcePortRanges": ["80", "81"]
          }
        },
        {
          "name": "Port_8082",
          "properties": {
            "access": "Allow",
            "description": "Allow inbound access on TCP 8082",
            "destinationApplicationSecurityGroups": [
              {
                "id": "<id>"
              }
            ],
            "destinationPortRange": "8082",
            "direction": "Inbound",
            "priority": 102,
            "protocol": "*",
            "sourceApplicationSecurityGroups": [
              {
                "id": "<id>"
              }
            ],
            "sourcePortRange": "*"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module networkSecurityGroup './network/network-security-group/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nnsgmin'
  params: {
    // Required parameters
    name: 'nnsgmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nnsgmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>
