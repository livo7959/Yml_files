variable "applications" {
  type = list(object({
    name = string
  }))
  description = "The names of all of the Entra ID applications that we are deploying"
  nullable    = false
}
