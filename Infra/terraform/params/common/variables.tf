variable "env" {
  type        = string
  description = "Environment shortname"
  validation {
    condition = contains([
      "sbox",
      "dev",
      "prod"
    ], lower(var.env))
    error_message = "Invalid value"
  }
}

variable "resource_groups" {
  type = list(object({
    name     = string
    location = string
    resources = object({
      container_apps = optional(list(object({
        name          = string
        registry_name = string
        containers = list(object({
          container_name = string
          image_name     = string
          cpu_core       = number
          memory_size    = string
        }))
        domains = list(object({
          name         = string
          binding_type = string
        }))
      })), [])
      container_registries = optional(list(object({
        name = string
        sku  = string
      })), [])
      databricks_workspaces = optional(list(object({
        name = string
        sku  = string
        network = object({
          virtual_network = string
          public_subnet   = string
          private_subnet  = string
        })
        private_endpoints = list(object({
          name = string
          private_link_service_connection = object({
            name              = string
            subresource_names = list(string)
          })
          private_dns_zone_name = optional(string, null)
          vnet                  = string
          subnet                = string
        }))
      })), [])
      data_factories = optional(list(object({
        name                 = string
        integration_runtimes = optional(list(string), [])
        linked_services = object({
          key_vault = optional(list(object({
            name           = string
            key_vault_name = string
          })), [])
          sql_server = optional(list(object({
            name                                    = string
            integration_runtime_name                = string
            connection_string_key_vault_ref_name    = string
            connection_string_key_vault_secret_name = string
            username                                = string
            password_key_vault_ref_name             = string
            password_key_vault_secret_name          = string
          })), [])
        })
      })), [])
      key_vaults   = optional(list(string), [])
      nat_gateways = optional(list(string), [])
      network_security_groups = optional(list(object({
        name = string
        security_rules = list(object({
          name                       = string
          access                     = string
          description                = string
          destination_address_prefix = string
          destination_port_range     = string
          direction                  = string
          priority                   = number
          protocol                   = string
          source_address_prefix      = string
          source_port_range          = string
        }))
      })), [])
      private_dns_zones = optional(list(string), [])
      private_endpoints = optional(list(object({
        name = string
        private_link_service_connection = object({
          name              = string
          subresource_names = list(string)
        })
        private_dns_zone_name = optional(string, null)
        vnet                  = string
        subnet                = string
      })), [])
      storage_accounts = optional(list(object({
        name                          = string
        account_kind                  = string
        account_tier                  = string
        account_replication_type      = string
        access_tier                   = string
        public_network_access_enabled = bool
        sftp_enabled                  = bool
        hns_enabled                   = bool
        bypass                        = optional(set(string), ["AzureServices"])
        vnet_access = optional(list(object({
          virtual_network = string
          subnet          = string
        })), [])
      })), [])
      virtual_networks = optional(list(object({
        name          = string
        address_space = map(list(string))
        subnets = optional(list(object({
          name                   = string
          address_prefixes       = map(string)
          network_security_group = optional(string)
          delegation = optional(list(object({
            name = string
            actions = optional(list(string), [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
            ])
          })), [])
          service_endpoints                         = optional(list(string), [])
          nat_gateway                               = optional(string, "")
          private_endpoint_network_policies_enabled = optional(bool, null)
        })), [])
        dns_servers       = optional(list(string), [])
        private_dns_zones = optional(list(string), [])
      })), [])
    })
  }))
  description = "Configuration of Resource Groups"
}

variable "subscription_id" {
  type        = string
  description = "subscription id (guid)"
}
