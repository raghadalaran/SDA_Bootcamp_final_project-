variable "resource_group_name" {
  description = "resource_group_name"
}

variable "name" {
  description = "name"
}

variable "vnet_name" {
  description = "vnet_name"
}

variable "address_prefixes" {
  description = "address_prefixes"
  default     = []
}

variable "db_subnet_name" {
  description = "db_subnet_name"
}


variable "aks_subnet_name" {
  description = "aks_subnet_name"
}

variable "vm_subnet_name" {
  description = "The name of the VM subnet"
  type        = string
  default     = "vm-subnet"
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    {
      name           = "vm-subnet"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "db-subnet"
      address_prefix = "10.0.2.0/24"
    }
  ]
}
