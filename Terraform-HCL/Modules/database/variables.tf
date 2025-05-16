variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "sql_server_name" {
  description = "The name of the SQL server"
  type        = string
}

variable "sql_db_name" {
  description = "The name of the SQL database"
  type        = string
}

variable "sql_admin_username" {
  description = "The administrator username for the SQL server"
  type        = string
}

variable "sql_admin_password" {
  description = "The administrator password for the SQL server"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  type    = string
  default = "Basic"
}

variable "db_subnet_id" {
  description = "The database subnet id"
}

variable "private_endpoint_name" {
  description = "The private endpoint name"
  type        = string
  default     = "sql-private-endpoint"
}
variable "private_dns_zone_name" {
  description = "The private dns zone name"
  type        = string
  default     = "privatelink.database.windows.net"
}
variable "private_dns_zone_vnet_link_name" {
  description = "The private dns zone vnet link name"
  type        = string
  default     = "sql-dns-link"
}

variable "virtual_network_id" {
  description = "The azurerm virtual network id"
  type        = string
}