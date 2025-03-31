output "VM" {
  description = "VM Names"
  value       = vsphere_virtual_machine.this.name
}

#output "ip" {
#  description = "default ip address of the deployed VM"
#  value       = vsphere_virtual_machine.this.*.ipv4_address
#}
