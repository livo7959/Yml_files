# Commands for local what-if runs

## Resource Group Target

```
az login
az account set --subscription "LH-Sandbox-Data-001"
python ci_cd/templates/decompose_params.py
jq '.parameters.management_groups.value[] | select(.name=="lh-sandbox") | .subscriptions[0].resource_groups[0]' ./bicep/params/prepared_params.json > ./bicep/params/_rg_params.json
az deployment group what-if --mode Complete --template-file ./bicep/rg_target.bicep --parameters resource_group=@./bicep/params/_rg_params.json environment_name=sbox --resource-group rg-data-sbox
```

```powershell
az login
az account set --subscription "LH-Sandbox-Data-001"
python ci_cd/templates/decompose_params.py
$params_obj = Get-Content -Path ./bicep/params/prepared_params.json | ConvertFrom-Json
$resource_group = ($params_obj.parameters.management_groups.value | Where-Object {$_.name -eq "lh-sandbox"}).subscriptions[0].resource_groups[0]
$resource_group | ConvertTo-Json -Depth 100 -Compress | Out-File ./bicep/params/_rg_params.json
az deployment group what-if --mode Complete --template-file ./bicep/rg_target.bicep --parameters resource_group=@./bicep/params/_rg_params.json environment_name=sbox --resource-group rg-data-sbox
```

## Subscription Target

```powershell
az login
az account set --subscription "LH-Sandbox-Data-001"
python ci_cd/templates/decompose_params.py
$account_details = az account show | ConvertFrom-Json
$account_name = $account_details.name
az deployment sub what-if --location eastus --template-file ./bicep/subscription_target.bicep --parameters ./bicep/params/prepared_params.json environment_name=sbox deploy_type=resources target_subscription_name=$account_name
az deployment sub what-if --location eastus --template-file ./bicep/subscription_target.bicep --parameters ./bicep/params/prepared_params.json environment_name=sbox deploy_type=iam target_subscription_name=$account_name
```

## Tenant Target

```
az login
python ci_cd/templates/decompose_params.py
az deployment tenant what-if -l eastus --parameters ./bicep/params/prepared_params.json --template-file ./bicep/tenant_target.bicep
```

# Instructions for running Tenant Target pipeline

1. Have global admin elevate permissions to the SPA used to allow tenant target deployments https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure
   ```powershell
   New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId (Get-AzADServicePrincipal -DisplayName "<service_principal_name>").id
   ```
2. Make sure global admin revokes permissions once deployment is complete!
   ```powershell
   Remove-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId (Get-AzADServicePrincipal -DisplayName "<service_principal_name>").id
   ```

# Global Admin Commands

## Grant account owner at root level

- Grant with:
  ```powershell
  New-AzRoleAssignment -SignInName "<az_admin_account>" -Scope "/" -RoleDefinitionName "Owner"
  ```
- Revoke with:
  ```powershell
  Remove-AzRoleAssignment -SignInName "<az_admin_account>" -Scope "/" -RoleDefinitionName "Owner"
  ```

# Assign Service Principal "Contributor" role for a specific Subscription

In the portal:

1. Go to the subscription
2. IAM
3. Add Role assignment
4. Privileged administrator roles
5. Contributor
6. Add the respective service principle account
