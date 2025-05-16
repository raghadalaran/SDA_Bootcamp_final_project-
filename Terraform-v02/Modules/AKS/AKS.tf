resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name 
  dns_prefix          = "${var.prefix}-dns"
  #depends_on           = [azurerm_virtual_network.virtual_network]
  

  node_resource_group = "${var.prefix}-aks-node"

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.240.0.10"
    service_cidr   = "10.240.0.0/16" # Should NOT overlap with any subnet
  }

  default_node_pool {
    name           = var.default_node_pool_name
    node_count     = 2
    vm_size        = var.vm_size
    vnet_subnet_id = var.aks_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
}

