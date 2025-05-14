resource "azurerm_resource_group" "RG" {
  name     = "DevOps1-week12-Techmomentum-RG"
  location = "germanywestcentral"
}


resource "azurerm_virtual_network" "vnet" {
  name = "vnet"
  address_space = ["10.0.0.0/16"]
  location = "germanywestcentral"
  resource_group_name = "DevOps1-week12-Techmomentum-RG"

}
