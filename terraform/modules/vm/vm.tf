
resource "azurerm_public_ip" "vm_ip" {
  name                = "vm_ip"
  resource_group_name = var.azurerm_resource_group.resource_group.name
  location            = var.azurerm_resource_group.resource_group.location
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm_nic"
  resource_group_name = var.azurerm_resource_group.resource_group.name
  location            = var.azurerm_resource_group.resource_group.location

  ip_configuration {
    name                          = "vm_nic_config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.vm_ip.id
  }
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.azurerm_resource_group.resource_group.name
  location              = var.azurerm_resource_group.resource_group.location
  size                  = var.vm_size
  admin_username = var.username
  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.vm_ip.ip_address
}


output "vm_private_ip" {
  value = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}
