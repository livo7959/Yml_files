# `terraform-modules`

This directory contains all of the company's Terraform modules be to used in downstream code & infrastructure deployments.

Note that the directory of "0_Global_Library/infrastructure_templates/terraform" also contains Terraform modules, but these contain older code that is not actually used. Eventually, all the code in that directory will be migrated here.

## Commonalities

All Terraform modules in this directory should contain the following characteristics:

- They should provide no version constraints. That [should be contained in end-user code](https://www.terraform-best-practices.com/faq#what-are-the-solutions-to-dependency-hell-with-modules).
- They should specify the "tags" attribute to an Azure resource whenever possible. (This helps document what resources were created by Terraform.)

## TODO

- Remove variables that are not being used in actual downstream code in order to minimize the amount of code that we need to manage. (For example, `account_tier` may not be necessary to expose.)
- Use `terraform_validate` on these automatically.
- Use `terraform_docs` on these automatically.
