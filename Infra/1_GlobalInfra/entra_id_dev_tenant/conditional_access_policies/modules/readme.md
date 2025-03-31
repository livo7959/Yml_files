# Terraform Variables for Azure AD Conditional Access Policy

## How to use the module

### Adding new Conditional Access Policies

- First add the CA policy details as an object under the local variable: ca_policies.
- All required groups will be created based off the name.
- Next implement the policy in the ".tf" related to the Persona of your policy. See Personas below.

For example:

```locals {
  ca_policies = {
    "CA100" = {
      name                   = "CA100-GlobalBase-Require-MFA"
      description            = "Require MFA for all users"
      create_inclusion_group = false
    }
    "CA110" = {
      name                   = "CA100-Persona-Description-Action"
      description            = "Require MFA for all users"
      create_inclusion_group = false
    }
  }
}
```

## Personas

Personas are categories to group policies based on their target. For example, LogixHealth uses the persona mapping below:

- CA100-199 = GlobalBase (Policies applied to "All Users", baseline security policies for global coverage).
- CA200-299 = Admins
- CA300-399 = Internals
- CA400-499 = CorpServiceAccounts (on-premise workloads)
- CA500-599 = WorkloadIdentities (cloud-based workloads or when the cloud is the target from an on-premise resource I.E Key Vault identities)
- CA600-699 = Azure Resource Specific Policies
- CA700-799 = Guest and Externals policies
- CA800-899 = Unused
- CA900-999 = Unused

See Microsoft document: https://learn.microsoft.com/en-us/azure/architecture/guide/security/conditional-access-architecture#conditional-access-personas

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version    |
| ------------------------------------------------------------------------ | ---------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.8     |
| <a name="requirement_azuread"></a> [azuread](#requirement_azuread)       | 2.48.0     |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)       | >= 3.101.0 |

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azuread"></a> [azuread](#provider_azuread) | 2.48.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                 | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [azuread_authentication_strength_policy.internal_user_supported_mfa](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/authentication_strength_policy) | resource    |
| [azuread_conditional_access_policy.ca100](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca101](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca102](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca103](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca104](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca105](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca106](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca107](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca200](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_conditional_access_policy.ca700](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/conditional_access_policy)                                 | resource    |
| [azuread_group.emergency_access_group](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/group)                                                        | resource    |
| [azuread_group.exemption_group](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/group)                                                               | resource    |
| [azuread_group.inclusion_group](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/group)                                                               | resource    |
| [azuread_named_location.azure_trusted_ips](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/named_location)                                           | resource    |
| [azuread_named_location.bangalore](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/named_location)                                                   | resource    |
| [azuread_named_location.bedford](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/named_location)                                                     | resource    |
| [azuread_named_location.coimbatore](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/named_location)                                                  | resource    |
| [azuread_named_location.trusted_countries](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/resources/named_location)                                           | resource    |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/2.48.0/docs/data-sources/client_config)                                                    | data source |

## Inputs

No inputs.

## Outputs

| Name                                                                                                                          | Description                                     |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| <a name="output_emergency_access_group_id"></a> [emergency_access_group_id](#output_emergency_access_group_id)                | The object ID of the emergency access group     |
| <a name="output_exemption_group_ids"></a> [exemption_group_ids](#output_exemption_group_ids)                                  | The object IDs of exemption groups              |
| <a name="output_inclusion_group_ids"></a> [inclusion_group_ids](#output_inclusion_group_ids)                                  | The object IDs of exemption groups              |
| <a name="output_internal_user_supported_mfa_id"></a> [internal_user_supported_mfa_id](#output_internal_user_supported_mfa_id) | Object ID of the Authentication Policy Strength |

<!-- END_TF_DOCS -->
