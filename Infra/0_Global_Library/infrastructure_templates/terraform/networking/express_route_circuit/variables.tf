variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location/region where the resources are created."
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
