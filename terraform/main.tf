resource "azurerm_resource_group" "contoso" {
  name     = "rg-contoso-cloud-lab"
  location = "Central US"

  tags = {
    Environment = "Lab"
    ManagedBy   = "Jay"
    Owner       = "CloudEngineering"
    Project     = "EnterpriseCloud"
  }
}

resource "azurerm_virtual_network" "contoso" {
  name                = "vnet-contoso-prod"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
  address_space       = ["10.10.0.0/16"]
  tags                = {}
}

resource "azurerm_subnet" "app" {
  name                            = "sn-app"
  resource_group_name             = azurerm_resource_group.contoso.name
  virtual_network_name            = azurerm_virtual_network.contoso.name
  address_prefixes                = ["10.10.1.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "mgmt" {
  name                            = "sn-mgmt"
  resource_group_name             = azurerm_resource_group.contoso.name
  virtual_network_name            = azurerm_virtual_network.contoso.name
  address_prefixes                = ["10.10.2.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
}

resource "azurerm_network_security_group" "mgmt" {
  name                = "nsg-mgmt"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                 = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}

resource "azurerm_network_interface" "mgmt" {
  name                           = "vm-mgmt-01787"
  location                       = azurerm_resource_group.contoso.location
  resource_group_name            = azurerm_resource_group.contoso.name
  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Jay"
    Owner       = "CloudEngineering"
    Project     = "EnterpriseCloud"
  }
}

resource "azurerm_windows_virtual_machine" "mgmt" {
  name                  = "vm-mgmt-01"
  computer_name         = "vm-mgmt-01"
  resource_group_name   = azurerm_resource_group.contoso.name
  location              = azurerm_resource_group.contoso.location
  size                  = "Standard_D2as_v7"
  admin_username        = "jayadmin"
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.mgmt.id]

  reboot_setting = "IfRequired"

  additional_capabilities {
    hibernation_enabled = false
    ultra_ssd_enabled   = false
  }

  boot_diagnostics {}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-azure-edition"
    version   = "latest"
  }

  secure_boot_enabled = true
  vtpm_enabled        = true

  tags = {
    Environment = "Lab"
    ManagedBy   = "Jay"
    Owner       = "CloudEngineering"
    Project     = "EnterpriseCloud"
  }

  lifecycle {
    ignore_changes = [admin_password]
  }
}
