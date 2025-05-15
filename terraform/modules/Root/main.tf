module "resource_group" {

 source = "../Azure/resource_group/"

 name = terraform.resource_group_name

 location = terraform.location

 tags = terraform.tags

}
module "database" {
  source = "../Azure/database"

  resource_group_name = terraform.resource_group_name
  location = terraform.location
  sql_server_name     = terraform.sql_server_name
  sql_db_name         = terraform.sql_db_name
  sql_admin_username  = terraform.sql_admin_username
  sql_admin_password  = terraform.sql_admin_password
  sku_name            = terraform.sku_name
  db_subnet_id        = terraform.db_subnet_id
  private_endpoint_name = terraform.private_endpoint_name
  private_dns_zone_name = terraform.private_dns_zone_name
  private_dns_zone_vnet_link_name = terraform.private_dns_zone_vnet_link_name
  virtual_network_id  = terraform.virtual_network_id
}