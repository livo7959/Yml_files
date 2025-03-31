include "root" {
  path = find_in_parent_folders()
}

include "dbx" {
  path = "${get_terragrunt_dir()}/../../_env/astro.hcl"
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//main"
}
