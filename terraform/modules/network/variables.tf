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
