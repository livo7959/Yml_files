data "azurerm_resource_group" "rg" {
  name = "rg-data-collection-sbox"
}

module "dce" {
  source                        = "../"
  name                          = "assoc"
  resource_group                = data.azurerm_resource_group.rg.name
  location                      = "eus"
  environment                   = "sbox"
  public_network_access_enabled = true
  tags = {
    usage = "moduletest"
  }

  associations = [
    {
      target_resource_id = "/subscriptions/sub-id/resourceGroups/rg-azure-arc-servers/providers/Microsoft.HybridCompute/machines/ServerName"
    }
  ]
}
