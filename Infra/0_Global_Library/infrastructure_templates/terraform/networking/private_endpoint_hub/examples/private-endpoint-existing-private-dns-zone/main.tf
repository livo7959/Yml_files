# This example uses and existing subnet, DNS zone and resource group

module "example_private_enpoint" {
  source = "../../"
  endpoints = [
    {
      name              = "pep-resource-name"
      subnet_name       = "snet-pe-shared-https-eus-001"
      vnet_name         = "vnet-private-endpoint-eus-001"
      subresource_names = ["vault"]
      target_resource   = "target-resource-id"
      dns_zone          = "privatelink.vaultcore.azure.net"
      env               = "sbox"
      tags = {
        environment = "sbox"
        managedBy   = "terraform"
      }
    }
  ]
}
