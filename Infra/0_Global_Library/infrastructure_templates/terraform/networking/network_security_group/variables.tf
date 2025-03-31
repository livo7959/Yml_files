variable "resource_group_name" {
  description = "description"
  type        = string
}

variable "nsg_name" {
  description = "description"
  type        = string
}

variable "security_rules" {
  description = "A list of security rules to add to the security group."
}

variable "tags" {
  description = "nsg tags"
  type        = map(string)
}