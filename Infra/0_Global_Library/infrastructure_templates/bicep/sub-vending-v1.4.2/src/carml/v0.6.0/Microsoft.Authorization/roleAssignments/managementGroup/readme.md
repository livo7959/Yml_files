# Role Assignment on Management Group level `[Microsoft.Authorization/roleAssignments/managementGroup]`

With this module you can perform role assignments on a management group level

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

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

## Outputs

| Output Name  | Type   | Description                                |
| :----------- | :----- | :----------------------------------------- |
| `name`       | string | The GUID of the Role Assignment.           |
| `resourceId` | string | The scope this Role Assignment applies to. |
| `scope`      | string | The resource ID of the Role Assignment.    |
