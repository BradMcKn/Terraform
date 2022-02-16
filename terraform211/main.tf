data "azurerm_client_config" "current" {}

data "azurerm_subnet" "defualt_subnet_data"{
  name = var.subnet1
  virtual_network_name = azurerm_virtual_network.Hub_Network.name
  resource_group_name = azurerm_resource_group.bradm.name
}
output "defualt_subnet_info"{
  value = data.azurerm_subnet.defualt_subnet_data.id
}
resource "azurerm_resource_group" "bradm" {
    name = var.resource_name
    location = var.location
}
resource "azurerm_network_security_group" "Network_Security_Group" {
  name                = var.network_NSG
  location            = azurerm_resource_group.bradm.location
  resource_group_name = azurerm_resource_group.bradm.name
  security_rule {
    name                       = "allow-22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_virtual_network" "Hub_Network" {
  name                = var.network_name
  location            = azurerm_resource_group.bradm.location
  resource_group_name = azurerm_resource_group.bradm.name
  address_space       = var.address_space
  subnet {
    name           = var.subnet1
    address_prefix = var.subnet_address
     security_group = azurerm_network_security_group.Network_Security_Group.id
  }
  subnet {
    name           = var.subnet2
    address_prefix = var.subnet2_address
     security_group = azurerm_network_security_group.Network_Security_Group.id
  }
}
resource "azurerm_network_interface" "linux_nic" {
  name ="${var.demo_network_NSG}-${var.subnet1}-VMNIC}"
  location = azurerm_resource_group.bradm.location
  resource_group_name = azurerm_resource_group.bradm.name

  ip_configuration{
    name = "internal"
    subnet_id = data.azurerm_subnet.defualt_subnet_data.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.linux2_PIP.id
  }
}
resource "azurerm_public_ip" "linux2_PIP" {
  name                = "linux2_PIP"
  resource_group_name = azurerm_resource_group.bradm.name
  location            = azurerm_resource_group.bradm.location
  allocation_method   = "Static"
  }

resource "azurerm_virtual_machine" "main"{
  name                  = "${var.network_name}-${var.subnet2}-linux2"
  location              = azurerm_resource_group.bradm.location
  resource_group_name   = azurerm_resource_group.bradm.name
  network_interface_ids = [azurerm_network_interface.linux_nic.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.network_name}-${var.subnet2}-linux2-OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = azurerm_key_vault_secret.simple_secret_username.value
    admin_password = azurerm_key_vault_secret.simple_secret_password.value
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  }
  resource "azurerm_key_vault" "secrets" {
  name                        = "uniqueBrad"
  location                    = azurerm_resource_group.bradm.location
  resource_group_name         = azurerm_resource_group.bradm.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"
    ]
  }
    access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "fe944492-d863-447f-8f7b-a73b54576882"

    secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"
    ]
  }
}
resource "azurerm_key_vault_secret" "simple_secret_username" {
  name         = "username"
  value        = var.linux2_username
  key_vault_id = azurerm_key_vault.secrets.id
}
resource "azurerm_key_vault_secret" "simple_secret_password" {
  name         = "password"
  value        = var.linux2_password
  key_vault_id = azurerm_key_vault.secrets.id
}
