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
