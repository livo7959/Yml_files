variable "env" {
  type        = string
  description = "Environment shortname"
  validation {
    condition = contains([
      "sbox",
      "dev",
      "qa",
      "uat",
      "stg",
      "prod"
    ], lower(var.env))
    error_message = "Invalid value"
  }
}

variable "tags" {
  description = "Tags of the resource."
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Region of the resources"
  type        = string
}

variable "name" {
  description = "Key Vault name"
  type        = string
}

variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  description = "Tenant ID of the key vault"
  type        = string
  default     = "54ba6692-0195-4329-9a5d-08a427817083"
}

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

variable "kv_admin_objects_ids" {
  description = "IDs of the objects that can do all operations on all keys, secrets and certificates."
  type        = list(string)
  default     = []
}

variable "kv_reader_objects_ids" {
  description = "IDs of the objects that can read metadata of key vaults and its certificates, keys, and secrets. Cannot read sensitive values such as secret contents or key material."
  type        = list(string)
  default     = []
}

variable "kv_secrets_user_objects_ids" {
  description = "IDs of the objects that can read secret contents, including certificate private keys."
  type        = list(string)
  default     = []
}

variable "kv_certificate_user_objects_ids" {
  description = "IDs of the objects that can read entire certificate contents including secret and key portion."
  type        = list(string)
  default     = []
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
  default     = 7
}

variable "rbac_authorization_enabled" {
  type        = bool
  description = "Whether the Key Vault uses Role Based Access Control (RBAC) for authorization of data actions instead of access policies."
  default     = false
}

