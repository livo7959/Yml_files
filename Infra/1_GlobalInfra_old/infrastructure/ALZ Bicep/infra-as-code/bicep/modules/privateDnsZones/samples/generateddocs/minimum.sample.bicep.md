# Azure template

## Parameters

| Parameter name | Required | Description                                                                      |
| -------------- | -------- | -------------------------------------------------------------------------------- |
| location       | No       | The Azure Region to deploy the resources into. Default: resourceGroup().location |

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into. Default: resourceGroup().location

- Default value: `[resourceGroup().location]`

## Snippets

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "template": "infra-as-code/bicep/modules/privateDnsZones/samples/minimum.sample.json"
  },
  "parameters": {
    "location": {
      "value": "[resourceGroup().location]"
    }
  }
}
```
