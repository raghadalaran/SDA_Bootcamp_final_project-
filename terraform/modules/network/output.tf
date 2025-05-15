output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = [for subnet in azurerm_subnet.subnet : subnet.id]
}

output "vm_nsg_id" {
  description = "ID of the VM NSG"
  value       = azurerm_network_security_group.vm_nsg.id
}

output "db_nsg_id" {
  description = "ID of the DB NSG"
  value       = azurerm_network_security_group.db_nsg.id
}