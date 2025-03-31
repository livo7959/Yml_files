variable "existing_resource_group" {
  description = "Optional. Required if an existing resource group will be used for dynamic lookup in the deployment."
  type        = string
  default     = null
}

variable "key_vaults" {
  type = list(object({
    resource_group                  = optional(string)
    name                            = string
    location                        = string
    environment                     = string
    sku_name                        = optional(string, "standard")
    tenant_id                       = optional(string, "")
    enabled_for_deployment          = optional(bool, false)
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    public_network_access_enabled   = optional(bool, false)
    network_acls = optional(list(object({
      bypass                     = optional(string)
      default_action             = optional(string)
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    })), [])
    purge_protection_enabled   = optional(bool, true)
    soft_delete_retention_days = optional(number, 90)
    rbac_authorization_enabled = optional(bool, true)
    create_service_principal   = optional(bool, false)
    administrative_unit_ids    = optional(set(string), [])
    tags                       = optional(map(string), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    kv_reader_member_object_ids = optional(list(string), [])
    pim_assignments = optional(object({
      kv_admin_pim_eligible_object_ids = optional(list(string))
    }), {})
    pim_eligibility_duration_days = optional(number, 365)
  }))
  default = []
}
