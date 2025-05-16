locals {
  resource_group_name = "Devops1-week12-Techmomentum-rg"
  location            = "Central US"
  tags                = { "env" : "production" }

  #network
  vnet_name          = "Devops1-w12-w"
  vnet_address_space = ["10.0.0.0/16"]
  subnets = [
    {
      name           = "vm-subnet"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "db-subnet"
      address_prefix = "10.0.2.0/24"
    }
  ]

  #database
  sql_server_name                 = "tch-sql-server"
  sql_db_name                     = "tch-sql-database"
  sql_admin_username              = "sqladmin"
  sql_admin_password              = "HitechP@ssyes2025" #Secret ,dont share
  sku_name                        = "Basic"
  db_subnet_id                    = module.network.subnet_ids[1] #output from Network
  private_endpoint_name           = "sql-private-endpoint"
  private_dns_zone_name           = "privatelink.database.windows.net"
  private_dns_zone_vnet_link_name = "sql-dns-link"
  virtual_network_id              = module.network.vnet_id #also outpot from network 


  #AKS
  prefix                      = "Devops1"
  vm_size                     = "Standard_D2s_v3"
  default_node_pool_name      = "default"
  virtual_network_name        = module.network.virtual_network  #also output from network module
  aks_subnet_address_prefixes = ["10.0.3.0/24"]

}



