include "root" {
  path = find_in_parent_folders()
}

include "data" {
  path = "${get_terragrunt_dir()}/../../_env/online/data.hcl"
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//main"
}
