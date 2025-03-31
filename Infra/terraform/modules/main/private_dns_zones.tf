resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each = {
    for idx, each in local.private_dns_zones :
    each.private_dns_zone => each
  }

  name                = each.value.private_dns_zone
  resource_group_name = each.value.resource_group.name

  tags = local.common_tags
}
