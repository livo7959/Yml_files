# Resources Tags Subscriptions `[Microsoft.Resources/tags/subscriptions]`

This module deploys Resources Tags on a subscription scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type              | API Version                                                                                        |
| :------------------------- | :------------------------------------------------------------------------------------------------- |
| `Microsoft.Resources/tags` | [2019-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/tags) |

## Parameters

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[deployment().location]` | Location deployment metadata. |
| `name` | string | `'default'` | The name of the tags resource. |
| `onlyUpdate` | bool | `False` | Instead of overwriting the existing tags, combine them with the new tags. |
| `tags` | object | `{object}` | Tags for the resource group. If not provided, removes existing tags. |

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

| Output Name  | Type   | Description                          |
| :----------- | :----- | :----------------------------------- |
| `name`       | string | The name of the tags resource.       |
| `resourceId` | string | The resource ID of the applied tags. |
| `tags`       | object | The applied tags.                    |
