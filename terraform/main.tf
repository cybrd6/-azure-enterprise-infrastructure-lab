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

# Prevent management subnet traffic from entering the application subnet.
resource "azurerm_network_security_rule" "deny_mgmt_to_app" {
  name                        = "Deny-Mgmt-To-App"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.10.2.0/24"
  destination_address_prefix  = "10.10.1.0/24"
  resource_group_name         = azurerm_resource_group.contoso.name
  network_security_group_name = azurerm_network_security_group.app.name
}

# Prevent application subnet traffic from entering the management subnet.
resource "azurerm_network_security_rule" "deny_app_to_mgmt" {
  name                        = "Deny-App-To-Mgmt"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.10.1.0/24"
  destination_address_prefix  = "10.10.2.0/24"
  resource_group_name         = azurerm_resource_group.contoso.name
  network_security_group_name = azurerm_network_security_group.mgmt.name
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

  identity {
    type = "SystemAssigned"
  }

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

resource "azurerm_role_assignment" "mgmt_reader" {
  scope                = azurerm_resource_group.contoso.id
  role_definition_name = "Reader"
  principal_id         = azurerm_windows_virtual_machine.mgmt.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "contoso" {
  name                = "kvcontosolab655d6"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled    = true
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  public_network_access_enabled = true

  tags = {
    Environment = "Lab"
    ManagedBy   = "Jay"
    Owner       = "CloudEngineering"
    Project     = "EnterpriseCloud"
  }
}

resource "azurerm_role_assignment" "mgmt_keyvault_secrets" {
  scope                = azurerm_key_vault.contoso.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_virtual_machine.mgmt.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_management_lock" "keyvault_protection" {
  name       = "lock-keyvault-delete"
  scope      = azurerm_key_vault.contoso.id
  lock_level = "CanNotDelete"
  notes      = "Prevents accidental deletion of the Key Vault."
}

resource "azurerm_role_assignment" "user_keyvault_secrets_officer" {
  scope                = azurerm_key_vault.contoso.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "28d9ac9a-6bcf-4dc3-87ad-cdbf35d74546"
  principal_type       = "User"
}

resource "azurerm_log_analytics_workspace" "contoso" {
  name                = "law-contoso-cloud-lab"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
    Project     = "EnterpriseCloud"
  }
}

resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = "diag-keyvault-audit"
  target_resource_id         = azurerm_key_vault.contoso.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.contoso.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Email notification Action Group
resource "azurerm_monitor_action_group" "contoso" {
  name                = "ag-contoso-alerts"
  resource_group_name = azurerm_resource_group.contoso.name
  short_name          = "ContosoAG"

  email_receiver {
    name                    = "Jayden"
    email_address           = "jaydenstewart1400@gmail.com"
    use_common_alert_schema = true
  }
}

# Azure Monitor alert for failed Key Vault secret retrievals
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "keyvault_failed_secret_access" {
  name                = "alert-kv-failed-secret-access"
  resource_group_name = azurerm_resource_group.contoso.name
  location            = azurerm_resource_group.contoso.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_log_analytics_workspace.contoso.id]

  severity                = 2
  enabled                 = true
  auto_mitigation_enabled = true
  description             = "Detects failed Key Vault secret retrieval requests."

  criteria {
    query = <<-QUERY
      AzureDiagnostics
      | where ResourceProvider == "MICROSOFT.KEYVAULT"
      | where Category == "AuditEvent"
      | where OperationName == "SecretGet"
      | where httpStatusCode_d >= 400
    QUERY

    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.contoso.id]
  }
}


# Dedicated storage account with secure transport and private blob access.
resource "azurerm_storage_account" "contoso" {
  name                     = "contosolabstorage655d6"
  resource_group_name      = azurerm_resource_group.contoso.name
  location                 = azurerm_resource_group.contoso.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                  = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  public_network_access_enabled  = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
    Owner       = "CloudEngineering"
    Project     = "EnterpriseCloud"
  }
}

# Grant the operator blob data access only to the private container.
resource "azurerm_role_assignment" "user_storage_blob_contributor" {
  scope = "${azurerm_storage_account.contoso.id}/blobServices/default/containers/contoso-private-data"

  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = "28d9ac9a-6bcf-4dc3-87ad-cdbf35d74546"
  principal_type       = "User"
}
