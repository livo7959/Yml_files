variable "env" {
  type        = string
  description = "Environment shortname"
  validation {
    condition = contains([
      "sbox",
      "stg",
      "prod",
      "shared"
    ], lower(var.env))
    error_message = "Invalid value"
  }
}

variable "location" {
  type        = string
  description = "The Azure Region"
}

variable "subscription_id" {
  type        = string
  description = "subscription id (guid)"
}
