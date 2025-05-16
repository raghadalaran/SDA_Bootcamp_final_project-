output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = [for subnet in azurerm_subnet.subnet : subnet.id]
}

output "db_nsg_id" {
  description = "ID of the NSG"
  value       = [for nsg in azurerm_network_security_group.nsg : nsg.id]
}

output "vnet_id" {
  description = "The ID of the created Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network" {
  value = azurerm_virtual_network.vnet.name
}