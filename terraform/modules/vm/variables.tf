variable "resource_group_name" {
  description = "The name of the resource group in which to create the VM"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed"
  type        = string
  default     = "eastus"
}

variable "subnet_id" {
  description = "The ID of the subnet where the VM will be connected"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "my-vm"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "username" {
  description = "The admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "public_ip_name" {
  description = "The name of the public IP address"
  type        = string
  default     = "vm_ip"
}

variable "vm_nic_name" {
  description = "The name of the network interface"
  type        = string
  default     = "vm_nic"
}