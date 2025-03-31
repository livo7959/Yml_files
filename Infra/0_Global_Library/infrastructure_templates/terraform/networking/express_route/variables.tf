variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location/region where the resources are created."
  type        = string
}

variable "public_ip_name" {
  description = "The name of the public IP."
  type        = string
}


variable "public_ip_sku" {
  description = "SKU of public IP resource. Possible values are Basic or Standard."
  type        = string
  default     = "Standard"
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
  default     = "Dynamic"
}

variable "public_ip_zones" {
  description = "List of availability zone for the public IP resource."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "gateway_name" {
  description = "The name of the gateway."
  type        = string
}

variable "gateway_type" {
  description = "The type of the gateway."
  type        = string
  default     = "ExpressRoute"
}

variable "vpn_type" {
  description = "The type of the VPN."
  type        = string
  default     = "value"
}

variable "sku_tier" {
  description = "The SKU tier of the gateway."
  type        = string
}

variable "express_route_sku" {
  description = "ExpressRoute circuit SKU"
  type = object({
    tier   = string,
    family = string
  })
  default = {
    tier   = "Standard"
    family = "MeteredData"
  }
}

variable "sku_capacity" {
  description = "The SKU capacity of the gateway."
  type        = number
}

variable "subnet_id" {
  description = "The ID of the subnet."
  type        = string
}

variable "circuit_name" {
  description = "The name of the circuit."
  type        = string
}

variable "peering_location" {
  description = "The peering location for the circuit."
  type        = string
}

variable "bandwidth_in_mbps" {
  description = "The bandwidth in Mbps for the circuit."
  type        = number
}

variable "service_provider_name" {
  description = "The name of the service provider."
  type        = string
}

variable "peering_type" {
  description = "The type of the peering."
  type        = string
}

variable "express_route_circuit_peerings" {
  description = "Configuration block of Private, Public and Microsoft ExpressRoute Circuit Peerings."
  type = list(object({
    peering_type                  = string
    primary_peer_address_prefix   = string
    secondary_peer_address_prefix = string
    peer_asn                      = number
    vlan_id                       = number
    shared_key                    = optional(string)
    microsoft_peering_config = optional(object({
      advertised_public_prefixes = list(string)
      customer_asn               = optional(number)
      routing_registry_name      = optional(string)
    }))
  }))
}

variable "express_route_circuit_peering_enabled" {
  description = "Enable or disable Express Route Circuit Peering configuration. (Should be disable at start. When the ExpressRoute circuit status is 'Provisioned', enable it.)"
  type        = bool
}
