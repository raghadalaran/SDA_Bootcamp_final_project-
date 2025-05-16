variable "resource_group_name" {
  description = "resource_group_name"
}
variable "vnet_name" {
  description = "vnet_name"
}
variable "location" {
  description = "location"
}
variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "address_prefixes" {
  description = "address_prefixes"
  default     = []
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name           = string
    address_prefix = string
    nsg_name     = string
  }))
  default = [
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
}

variable "nsgs" {
  type = map(object({
    security_rule   = map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

