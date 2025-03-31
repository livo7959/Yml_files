variable "public_ip_name" {
  description = "The name of the public IP."
  type        = string
  default     = " "
}

variable "public_ip_sku" {
  description = "SKU of public IP resource. Possible values are Basic or Standard."
  type        = string
  default     = " "
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
  default     = " "
}

variable "public_ip_zones" {
  description = "List of availability zone for the public IP resource."
  type        = list(number)
  default     = []
}

variable "gateway_name" {
  description = "The name of the gateway."
  type        = string
  default     = " "
}

variable "gateway_type" {
  description = "The type of the gateway."
  type        = string
  default     = " "
}

variable "vpn_type" {
  description = "The type of the VPN."
  type        = string
  default     = " "
}

variable "gateway_sku" {
  description = "The SKU tier of the gateway."
  type        = string
  default     = " "
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
  }))
}

variable "express_route_circuit_peering_enabled" {
  description = "Enable or disable Express Route Circuit Peering configuration. (Should be disable at start. When the ExpressRoute circuit status is 'Provisioned', enable it.)"
  type        = bool
}

variable "routing_weight" {
  description = "ExpressRoute circuit connection routing weight. Default is 0"
  type        = number
  default     = 0
}

