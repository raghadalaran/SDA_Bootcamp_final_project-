locals {

 resource_group_name = "Devops1-week12-Techmomentum-RG"
  location            = "germanywestcentral"
  tags                = { "env" : "production" }

  #network
  vnet_name          = "Devops1-week12-Techmomentum-Vnet"
  vnet_address_space = ["10.0.0.0/16"]
  subnets = [
    {
      name           = "aks-subnet"
      address_prefix = "10.0.1.0/24"
      nsg_name     = "aks_nsg"
    },
    {
      name           = "db-subnet"
      address_prefix = "10.0.2.0/24"
      nsg_name     = "db_nsg"
    }
  ]

  nsgs = {
    aks_nsg = {
      security_rule = {
        "AllowSSH" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "10.240.0.0/16"
          destination_address_prefix = "10.240.0.0/16"
        }
        "AllowIngressHTTP1" = {
          priority                   = 250
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
        "AllowIngressHTTP2" = {
          priority                   = 252
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      }
    }

    db_nsg = {
      security_rule = {
        "AllowMySQL" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "1433"
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "*"
        }
      }
    }
  }


  #database
  sql_server_name                 = "tch-sql-servertest"
  sql_db_name                     = "tch-sql-databasetest"
  sql_admin_username              = "sqladmin"
  sql_admin_password              = "HitechP@ssyes2025" #Secret ,dont share
  sku_name                        = "Basic"
  db_subnet_id                    = module.network.subnet_ids[1] #output from Network
  private_endpoint_name           = "sql-private-endpoint"
  private_dns_zone_name           = "privatelink.database.windows.net"
  private_dns_zone_vnet_link_name = "sql-dns-link"
  virtual_network_id              = module.network.vnet_id #also outpot from network 


  #AKS

  prefix                      = "Devops1-week12-Techmomentum"
  vm_size                = "Standard_D2s_v3"
  default_node_pool_name = "default"
  aks_subnet_id          = module.network.subnet_ids[0] #output from Network
}



