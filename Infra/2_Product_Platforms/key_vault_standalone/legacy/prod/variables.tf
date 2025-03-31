variable "key_vaults_prod" {
  description = "List of Key Vaults"
  type = list(object({
    env                             = string
    tags                            = map(string)
    resource_group_name             = optional(string)
    location                        = optional(string)
    name                            = string
    sku_name                        = string
    tenant_id                       = optional(string)
    enabled_for_deployment          = bool
    enabled_for_disk_encryption     = bool
    enabled_for_template_deployment = bool
    kv_admin_objects_ids            = list(string)
    kv_reader_objects_ids           = list(string)
    kv_secrets_user_objects_ids     = list(string)
    kv_certificate_user_objects_ids = list(string)
    public_network_access_enabled   = bool
    network_acls = list(object({
      bypass                     = optional(string)
      default_action             = optional(string)
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
    purge_protection_enabled   = bool
    soft_delete_retention_days = number
    rbac_authorization_enabled = bool
    create_rbac_groups         = optional(bool)
  }))
  default = []
}
