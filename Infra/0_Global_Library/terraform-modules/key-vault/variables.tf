# ------------------
# Required variables
# ------------------

variable "resource_group" {
  type        = string
  description = "Name of the resource group that the key vault should be in. Should be in the format of: `rg-foo`"
  nullable    = false
  validation {
    condition     = var.resource_group != null && can(regex(module.common_constants.kebab_case_regex, var.resource_group))
    error_message = "The resource group must be kebab-case."
  }
  validation {
    condition     = var.resource_group != null && startswith(var.resource_group, "rg-")
    error_message = "The resource group must start with \"rg-\"."
  }
}

variable "name" {
  type        = string
  description = "A name describing what the key vault is for. Note that the real name of the resource will have the location and the environment appended to it. The provided name should be all lowercase and one word. e.g. `avd` (for Azure Virtual Desktop)"
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "lh-kv-")
    error_message = "The name must not start with \"lh-kv-\". (A prefix of \"lh-kv-\" will automatically be added by this module when creating the resource.)"
  }
  validation {
    condition     = var.name != null && length(var.name) <= 24 - length("lh-kv-") - length("-") - length(var.location) - length("-") - length(var.environment)
    error_message = "The name is too long. (Key vaults have a maximum length of 24, we bake in a standard prefix and use a suffix containing the region and environment.)"
  }
}

variable "location" {
  type        = string
  description = "Azure region short name (CAF). e.g. `eus` for East US. See: https://www.jlaundry.nz/2022/azure_region_abbreviations/"
  nullable    = false
  validation {
    condition     = contains(keys(module.common_constants.region_short_name_to_long_name), var.location)
    error_message = "The location must be one of: ${join(", ", keys(module.common_constants.region_short_name_to_long_name))}"
  }
}

variable "environment" {
  type        = string
  description = "Environment shortname"
  nullable    = false
  validation {
    condition     = contains(module.common_constants.valid_environments, var.environment)
    error_message = "The environment must be one of: ${join(", ", module.common_constants.valid_environments)}"
  }
}

variable "sku_name" {
  description = "The Name of the SKU used for this key vault. Possible values are standard and premium."
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  description = "If no value is provided the default tenant_id will be the current tenant of the deployment principal."
  type        = string
  default     = ""
}

# ------------------
# Optional variables
# ------------------

variable "enabled_for_deployment" {
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether the Key Vault is available from public network."
  type        = bool
  default     = false
}

variable "network_acls" {
  description = "Object with attributes: bypass, default_action, ip_rules, virtual_network_subnet_ids. Set to null to disable. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more information."
  type = list(object({
    bypass                     = optional(string)
    default_action             = optional(string)
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  }))
  default = []
}

variable "purge_protection_enabled" {
  description = "Whether to activate purge protection."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between `7` and `90` days."
  type        = number
  default     = 90
}

variable "rbac_authorization_enabled" {
  type        = bool
  description = "Whether the Key Vault uses Role Based Access Control (RBAC) for authorization of data actions instead of access policies."
  default     = true
}

variable "create_service_principal" {
  type        = bool
  description = "Boolean to control the creation of an Entra ID service principal if an intermediate identity is needed for authenticating to the Key Vault."
  default     = false
}

variable "administrative_unit_ids" {
  type        = set(string)
  description = "administrative unit ID for the Key Vault access groups"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for the deployment. Tag names are case insensitive, but tag values are case sensitive. The `managedBy = \"terraform\"` tag will automatically be applied in addition to any other tags specified."
  default     = {}
  validation {
    condition = alltrue([
      for tag in var.tags :
      lower(tag) == tag
    ])
    error_message = "All tag names must be in lowercase."
  }
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = "The lock level to apply to the Key Vault. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`."

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "Lock kind must be either `\"CanNotDelete\"` or `\"ReadOnly\"`."
  }
}

variable "kv_reader_member_object_ids" {
  type        = list(string)
  description = "User object IDs to be added to the kv_reader group. Note if deploying a service principal, it will be automatically added."
  default     = []
}

# Creating the variable below as a list object to allow us to add additional roles managed by PIM if necessary.
variable "pim_assignments" {
  type = object({
    kv_admin_pim_eligible_object_ids = optional(list(string))
  })
  description = "Object IDs of users who require Key Vault Reader/Secrets User and/or Key Vault Administrator assigned through PIM."
  default     = {}
}

variable "pim_eligibility_duration_days" {
  type        = number
  description = "Duration in days for the PIM eligibility assignment. Defaults to 365 days. Depends on pim_assignments being not null or empty"
  default     = 365
}
