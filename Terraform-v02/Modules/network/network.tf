resource "azurerm_virtual_network" "vnet" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.vnet_name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet" {
  count               = length(var.subnets)
  resource_group_name = var.resource_group_name
  name                = var.subnets[count.index].name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [var.subnets[count.index].address_prefix]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count                     = length(var.subnets)
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[var.subnets[count.index].nsg_name].id
}