module "common_constants" {
  source = "../../common/constants"
}

locals {
  merged_tags = merge(module.common_constants.default_tags, var.tags)
}
