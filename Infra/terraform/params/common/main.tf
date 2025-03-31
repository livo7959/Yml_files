module "main" {
  source = "../../../modules/main"

  subscription_id = var.subscription_id
  env             = var.env
  resource_groups = var.resource_groups
}
