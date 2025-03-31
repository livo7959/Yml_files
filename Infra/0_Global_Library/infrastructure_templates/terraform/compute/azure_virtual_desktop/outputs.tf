output "session_host_count" {
  description = "The number of VMs created"
  value       = var.sh_count
}
output "host_pool_id" {
  description = "Host pool ID"
  value       = azurerm_virtual_desktop_host_pool.hostpool.id
}
