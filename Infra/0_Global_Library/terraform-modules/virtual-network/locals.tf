module "common_constants" {
  source = "../common/constants"
}

locals {
  ip_address_regex = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

  base_name        = "${var.name}-${var.location}-${var.environment}"
  route_table_name = "rt-${local.base_name}"
  merged_tags      = merge(module.common_constants.default_tags, var.tags)

  # Deploying the route table is contingent upon a subnet being specified and the "route_table"
  # object being specified.
  deploy_route_table = var.subnets != null && length(var.subnets) > 0 && var.route_table != null

  # Specify the default route for the route table.
  default_routes = {
    azure_firewall = {
      name                   = "udr-azfw"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.120.0.68"
    }
  }
  routes = (
    var.route_table == null ? local.default_routes : (
      var.route_table.routes == null ? local.default_routes : var.route_table.routes
    )
  )
}
