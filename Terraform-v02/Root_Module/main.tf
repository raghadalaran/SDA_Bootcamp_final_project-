module "resource_group" {
  source   = "../Modules/resource_group/"
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}
#network 
module "network" {
  source = "../Modules/network"

  resource_group_name = local.resource_group_name
  location            = local.location
  vnet_name           = local.vnet_name
  vnet_address_space  = local.vnet_address_space
  subnets             = local.subnets
  nsgs                = local.nsgs
  depends_on = [ module.resource_group ]
}
#Database
module "database" {
  source                          = "../Modules/database"
  resource_group_name             = local.resource_group_name
  location                        = local.location
  sql_server_name                 = local.sql_server_name
  sql_db_name                     = local.sql_db_name
  sql_admin_username              = local.sql_admin_username
  sql_admin_password              = local.sql_admin_password
  sku_name                        = local.sku_name
  db_subnet_id                    = local.db_subnet_id
  private_endpoint_name           = local.private_endpoint_name
  private_dns_zone_name           = local.private_dns_zone_name
  private_dns_zone_vnet_link_name = local.private_dns_zone_vnet_link_name
  virtual_network_id              = local.virtual_network_id
  depends_on = [ module.network ]
}
#AKS
module "AKS" {
  source                 = "../Modules/AKS"
  resource_group_name    = local.resource_group_name
  location               = local.location
  prefix                 = local.prefix
  vm_size                = local.vm_size
  default_node_pool_name = local.default_node_pool_name
  aks_subnet_id          = local.aks_subnet_id
  depends_on = [ module.network ]
}

