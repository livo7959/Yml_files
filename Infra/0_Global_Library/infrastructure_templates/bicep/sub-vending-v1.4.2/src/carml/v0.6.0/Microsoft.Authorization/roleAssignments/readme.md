# Role Assignments `[Microsoft.Authorization/roleAssignments]`

This module deploys Role Assignments across the management group, subscription or resource group scope.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Module Usage Guidance](#Module-Usage-Guidance)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type                             | API Version                                                                                                                       |
| :---------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------- |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `principalId` | string | The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity). |
| `roleDefinitionIdOrName` | string | You can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `condition` | string | `''` | | The conditions on the role assignment. This limits the resources it can be assigned to. |
| `conditionVersion` | string | `'2.0'` | `[2.0]` | Version of the condition. Currently accepted value is "2.0". |
| `delegatedManagedIdentityResourceId` | string | `''` | | ID of the delegated managed identity resource. |
| `description` | string | `''` | | The description of the role assignment. |
| `enableDefaultTelemetry` | bool | `True` | | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[deployment().location]` | | Location deployment metadata. |
| `managementGroupId` | string | `[managementGroup().name]` | | Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment. |
| `principalType` | string | `''` | `[ServicePrincipal, Group, User, ForeignGroup, Device, ]` | The principal type of the assigned principal ID. |
| `resourceGroupName` | string | `''` | | Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group. |
| `subscriptionId` | string | `''` | | Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |

### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.

<details>

<summary>Parameter JSON format</summary>

```json
"managementGroupId": {
    "value": "contoso-group"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
managementGroupId: 'contoso-group'
```

</details>
<p>

> `managementGroupId` is an optional parameter. If not provided, the deployment will use the management group defined in the current deployment scope (i.e. `managementGroup().name`).

### Parameter Usage: `subscriptionId`

To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:

<details>

<summary>Parameter JSON format</summary>

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
```

</details>
<p>

### Parameter Usage: `resourceGroupName`

To deploy resource to a Resource Group, provide the `subscriptionId` and `resourceGroupName` as an input parameter to the module. **Example**:

<details>

<summary>Parameter JSON format</summary>

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
},
"resourceGroupName": {
    "value": "target-resourceGroup"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
resourceGroupName: 'target-resourceGroup'
```

</details>
<p>

> The `subscriptionId` is used to enable deployment to a Resource Group Scope, allowing the use of the `resourceGroup()` function from a Management Group Scope. [Additional Details](https://github.com/Azure/bicep/pull/1420).

## Module Usage Guidance

In general, most of the resources under the `Microsoft.Authorization` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `deploy.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](deploy.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/deploy.bicep'](./subscription/deploy.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/deploy.bicep'](./subscription/deploy.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**

```bicep
module roleassignment 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.roleassignments.subscription:version' = {}
```

**Local Path Reference**

```bicep
module roleassignment 'yourpath/arm/Microsoft.Authorization.roleAssignments/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name  | Type   | Description                                |
| :----------- | :----- | :----------------------------------------- |
| `name`       | string | The GUID of the Role Assignment.           |
| `resourceId` | string | The resource ID of the Role Assignment.    |
| `scope`      | string | The scope this Role Assignment applies to. |

## Considerations

This module can be deployed at the management group, subscription or resource group level

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "roleDefinitionIdOrName": {
      "value": "Storage Queue Data Reader"
    },
    "principalId": {
      "value": "<<deploymentSpId>>"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignments './Microsoft.Authorization/roleAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-roleAssignments'
  params: {
    roleDefinitionIdOrName: 'Storage Queue Data Reader'
    principalId: '<<deploymentSpId>>'
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "roleDefinitionIdOrName": {
      "value": "Backup Reader"
    },
    "description": {
      "value": "Role Assignment (management group scope)"
    },
    "principalId": {
      "value": "<<deploymentSpId>>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "managementGroupId": {
      "value": "<<managementGroupId>>"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignments './Microsoft.Authorization/roleAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-roleAssignments'
  params: {
    roleDefinitionIdOrName: 'Backup Reader'
    description: 'Role Assignment (management group scope)'
    principalId: '<<deploymentSpId>>'
    principalType: 'ServicePrincipal'
    managementGroupId: '<<managementGroupId>>'
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "roleDefinitionIdOrName": {
      "value": "Storage Queue Data Reader"
    },
    "principalId": {
      "value": "<<deploymentSpId>>"
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    },
    "resourceGroupName": {
      "value": "<<resourceGroupName>>"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignments './Microsoft.Authorization/roleAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-roleAssignments'
  params: {
    roleDefinitionIdOrName: 'Storage Queue Data Reader'
    principalId: '<<deploymentSpId>>'
    subscriptionId: '<<subscriptionId>>'
    resourceGroupName: '<<resourceGroupName>>'
  }
}
```

</details>
<p>

<h3>Example 4</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "roleDefinitionIdOrName": {
      "value": "Backup Reader"
    },
    "description": {
      "value": "Role Assignment (resource group scope)"
    },
    "principalId": {
      "value": "<<deploymentSpId>>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    },
    "resourceGroupName": {
      "value": "<<resourceGroupName>>"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignments './Microsoft.Authorization/roleAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-roleAssignments'
  params: {
    roleDefinitionIdOrName: 'Backup Reader'
    description: 'Role Assignment (resource group scope)'
    principalId: '<<deploymentSpId>>'
    principalType: 'ServicePrincipal'
    subscriptionId: '<<subscriptionId>>'
    resourceGroupName: '<<resourceGroupName>>'
  }
}
```

</details>
<p>

<h3>Example 5</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "roleDefinitionIdOrName": {
      "value": "Storage Queue Data Reader"
    },
    "principalId": {
      "value": "<<deploymentSpId>>"
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignments './Microsoft.Authorization/roleAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-roleAssignments'
  params: {
    roleDefinitionIdOrName: 'Storage Queue Data Reader'
    principalId: '<<deploymentSpId>>'
    subscriptionId: '<<subscriptionId>>'
  }
}
```

</details>
<p>

<h3>Example 6</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "roleDefinitionIdOrName": {
      "value": "Backup Reader"
    },
    "description": {
      "value": "Role Assignment (subscription scope)"
    },
    "principalId": {
      "value": "<<deploymentSpId>>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignments './Microsoft.Authorization/roleAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-roleAssignments'
  params: {
    roleDefinitionIdOrName: 'Backup Reader'
    description: 'Role Assignment (subscription scope)'
    principalId: '<<deploymentSpId>>'
    principalType: 'ServicePrincipal'
    subscriptionId: '<<subscriptionId>>'
  }
}
```

</details>
<p>
