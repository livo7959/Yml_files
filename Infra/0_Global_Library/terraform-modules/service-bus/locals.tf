module "common_constants" {
  source = "../common/constants"
}

locals {
  base_namespace_name = "${var.namespace_name}-${var.location}-${var.environment}"
  merged_tags         = merge(module.common_constants.default_tags, var.tags)
}
