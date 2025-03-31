module "common_constants" {
  source = "../common/constants"
}

locals {
  base_name   = "${var.name}${var.environment}"
  merged_tags = merge(module.common_constants.default_tags, var.tags)
}
