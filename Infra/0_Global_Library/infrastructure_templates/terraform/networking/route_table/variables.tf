variable "resource_group_name" {
  description = "description"
  type        = string
}

variable "route_table_name" {
  description = "Azure route table name"
  type        = string
}

variable "disable_bgp_route_propagation" {
  description = "Enable or disable BGP Route Propagation"
  type        = bool
  default     = true
}

variable "routes" {
  description = "Map of routes and their properties. Variable next_hop_in_ip_address is only required when using VirtualAppliance next_hop_type"
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {
    azure_firewall = {
      name                   = "udr-azfw"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.120.0.68"
    }
  }
}
