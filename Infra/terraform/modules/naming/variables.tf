variable "env" {
  type        = string
  description = "Environment shortname"
  validation {
    condition = contains([
      "sbox",
      "stg",
      "prod",
      "shared",
      "ostg",
      "oprd"
    ], lower(var.env))
    error_message = "Invalid value"
  }
}

variable "location" {
  type        = string
  description = "The Azure Region"
}

variable "name" {
  type        = string
  description = "Base name of the resource"
}

variable "resource_type" {
  type = string
  validation {
    # Spelling out explicitly because of limitation documented here https://github.com/hashicorp/terraform/issues/24187
    # Would like to just reference keys(local.resources)
    condition = contains([
      "cdn_profile",
      "container_app",
      "container_app_managed_environment",
      "container_registry",
      "databricks",
      "data_factory",
      "key_vault",
      "nat_gateway",
      "network_interface",
      "network_security_group",
      "private_endpoint",
      "public_ip",
      "resource_group",
      "role_definition",
      "service_bus",
      "storage_account",
      "subnet",
      "virtual_network"
    ], lower(var.resource_type))
    error_message = "Invalid value"
  }
  description = "Type of resource"
}
