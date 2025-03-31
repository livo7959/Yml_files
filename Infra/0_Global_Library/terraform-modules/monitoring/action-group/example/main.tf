module "resource-group" {
  source      = "../../../resource-group"
  name        = "test"
  location    = "eus"
  environment = "sbox"
}


module "action_group" {
  source              = "../../action-group"
  resource_group_name = module.resource-group.resource_group_name
  name                = "test"
  location            = "eus"
  short_name          = "test"
  email_receivers = [
    {
      name          = "test email"
      email_address = "testemail@logixhealth.com"
    },
    {
      name          = "test email_2"
      email_address = "testemail2@logixhealth.com"
    }
  ]
}
