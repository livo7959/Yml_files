variable "endpoints" {
  description = "A list of private endpoints and their associated DNS zones"
  type = list(object({
    name                 = string
    dns_zone             = string
    target_resource      = string
    subresource_names    = list(string)
    vnet_name            = string
    subnet_name          = string
    env                  = string
    tags                 = map(string)
    is_manual_connection = optional(bool, false)
    request_message      = optional(string, "Private Endpoint Deployment")
  }))
  default = []
}
