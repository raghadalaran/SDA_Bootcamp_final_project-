output "public_ip" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.vm_ip.ip_address
}

output "vm_private_ip" {
  description = "The private IP address of the virtual machine"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "tls_private_key" {
  description = "The private key for SSH access (sensitive)"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}
