output "basename" {
  value = local.resources[var.resource_type]
}

output "name" {
  value = "${local.resources[var.resource_type]}${lookup(local.internals.suffix, var.resource_type, "-${var.env}")}"
}
