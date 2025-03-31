# ------------------
# Required variables
# ------------------

variable "name" {
  type        = string
  description = "A name describing what the network is for. Note that the real name of the resource will have the location and the environment appended to it. The provided name should be all lowercase and one word. e.g. `avd` (for Azure Virtual Desktop)"
  nullable    = false
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_regex, var.name))
    error_message = "The name must contain only lowercase letters."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "vnet-")
    error_message = "The name must not start with \"vnet-\". (A prefix of \"vnet-\" will automatically be added by this module when creating the resource.)"
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

variable "resource_group" {
  type        = string
  description = "Name of the resource group that this virtual network should be inside. Should be in the format of: `rg-foo`"
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

variable "address_space" {
  type        = list(string)
  description = "Address space of the virtual network, e.g. `[\"10.0.0.0/8\"]`"
  nullable    = false
}

# ------------------
# Optional variables
# ------------------

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

variable "subnets" {
  type = map(object({
    address_prefix                                = string
    service_endpoints                             = optional(list(string))
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    delegation = optional(object({
      name    = string
      actions = list(string)
    }))
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
    })))
  }))
  description = "Map of subnets and their properties"
  default     = {}
  validation {
    condition = alltrue([
      for subnet_name, subnet in var.subnets :
      !startswith(subnet_name, "snet-")
    ])
    error_message = "Subnet names must not start with \"snet-\". (A prefix of \"snet-\" will automatically be added by this module when creating the subnet.)"
  }
  validation {
    condition = alltrue([
      for subnet_name, subnet in var.subnets :
      can(regex(module.common_constants.kebab_case_regex, subnet_name))
    ])
    error_message = "All subnet names must be kebab-case."
  }

  validation {
    condition = alltrue(flatten([
      for subnet in var.subnets :
      subnet.nsg_rules == null ? [true] : [
        for rule in subnet.nsg_rules :
        can(regex(module.common_constants.kebab_case_regex, rule.name))
      ]
    ]))
    error_message = "All network security group rule names must be kebab-case."
  }
}

variable "dns_servers" {
  type        = list(string)
  description = "List of custom DNS server IP addresses"
  default     = []
  validation {
    condition = alltrue([
      for dns_server in var.dns_servers :
      can(regex(local.ip_address_regex, dns_server))
    ])
    error_message = "Each DNS server must be an IP address."
  }
}

variable "route_table" {
  type = object({
    # If not specified, BGP route propagation will be enabled.
    bgp_route_propagation_enabled = optional(bool)
    # Map of routes and their properties. If this field is omitted, then the following default route
    # will be applied:
    # azure_firewall = {
    #   name                   = "udr-azfw"
    #   address_prefix         = "0.0.0.0/0"
    #   next_hop_type          = "VirtualAppliance"
    #   next_hop_in_ip_address = "10.120.0.68"
    # }
    routes = optional(map(object({
      address_prefix = string
      next_hop_type  = string
      # Only required when using: `next_hop_type = "VirtualAppliance"`
      next_hop_in_ip_address = optional(string)
    })))
  })
  description = "The route table that will be applied to every subnet. If no subnets are declared, then anything specified in this variable will be a no-op."
  default     = null
  validation {
    condition = var.route_table == null ? true : (
      var.route_table.routes == null ? true : (
        alltrue([
          for route_name, route in var.route_table.routes :
          can(regex(module.common_constants.kebab_case_regex, route_name))
        ])
      )
    )
    error_message = "All route names must be kebab-case."
  }
}

variable "peerings" {
  type = map(object({
    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_gateway_transit        = optional(bool)
    use_remote_gateways          = optional(bool)
  }))
  description = "A map representing the other virtual networks that this virtual network will be peered to. Each key in the map should be equal to the name for the other virtual network. Each value in the map should be the object representing its peering configuration. This can be an empty object, which means the peering will use all of the default values."
  default     = {}
}
