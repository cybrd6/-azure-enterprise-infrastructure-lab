# Core network and compute infrastructure
# These resources define the lab's Azure environment and its management workload.

resource "azurerm_resource_group" "contoso" {
  # Logical container for related lab resources, access control, and cost tracking.
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
  # Private address space shared by the application and management subnets.
  name                = "vnet-contoso-prod"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
  address_space       = ["10.10.0.0/16"]
  tags                = {}
}

resource "azurerm_subnet" "app" {
  # Dedicated address range for future application workloads.
  name                            = "sn-app"
  resource_group_name             = azurerm_resource_group.contoso.name
  virtual_network_name            = azurerm_virtual_network.contoso.name
  address_prefixes                = ["10.10.1.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "mgmt" {
  # Separate management network zone; default outbound access is disabled.
  name                            = "sn-mgmt"
  resource_group_name             = azurerm_resource_group.contoso.name
  virtual_network_name            = azurerm_virtual_network.contoso.name
  address_prefixes                = ["10.10.2.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_network_security_group" "app" {
  # Traffic-filter policy container associated with the application subnet.
  name                = "nsg-app"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
}

resource "azurerm_network_security_group" "mgmt" {
  # Traffic-filter policy container for the management subnet.
  name                = "nsg-mgmt"
  location            = azurerm_resource_group.contoso.location
  resource_group_name = azurerm_resource_group.contoso.name
}

resource "azurerm_subnet_network_security_group_association" "app" {
  # Applies the application NSG rules at the subnet boundary.
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  # Applies the management NSG rules at the subnet boundary.
  subnet_id                 = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}

resource "azurerm_network_interface" "mgmt" {
  # VM network adapter; it receives a private address from the management subnet.
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
  # Isolated Windows administration host; no public IP is attached to its NIC.
  name                  = "vm-mgmt-01"
  computer_name         = "vm-mgmt-01"
  resource_group_name   = azurerm_resource_group.contoso.name
  location              = azurerm_resource_group.contoso.location
  size                  = "Standard_D2as_v7"
  admin_username        = "jayadmin"
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.mgmt.id]

  # System-assigned identity lets the VM authenticate to Azure services without embedded credentials.
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

  # Trusted Launch protections: Secure Boot verifies boot components; vTPM provides a virtual TPM.
  secure_boot_enabled = true
  vtpm_enabled        = true

  tags = {
    Environment = "Lab"
    ManagedBy   = "Jay"
    Owner       = "CloudEngineering"
    Project     = "EnterpriseCloud"
  }

  # Prevent an out-of-band password reset from causing Terraform to overwrite the password.
  lifecycle {
    ignore_changes = [admin_password]
  }
}

# Read the tenant ID of the Azure CLI-authenticated deployment identity for Key Vault configuration.
data "azurerm_client_config" "current" {}

# Identity and access management
# Reader is limited to this resource group; it grants visibility, not resource modification.
resource "azurerm_role_assignment" "mgmt_reader" {
  scope                = azurerm_resource_group.contoso.id
  role_definition_name = "Reader"
  principal_id         = azurerm_windows_virtual_machine.mgmt.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

# This data role permits the VM identity to read secret values from this vault, not manage secrets.
resource "azurerm_role_assignment" "mgmt_keyvault_secrets" {
  scope                = azurerm_key_vault.contoso.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_virtual_machine.mgmt.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

# Allows the lab operator's signed-in Entra user to create and manage test secrets in this vault.
# Scope is limited to this Key Vault; the object ID is the lab user's Entra object ID.
resource "azurerm_role_assignment" "user_keyvault_secrets_officer" {
  scope                = azurerm_key_vault.contoso.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.operator_object_id
  principal_type       = "User"
}

# Secrets management
resource "azurerm_key_vault" "contoso" {
  # Central secret store; RBAC controls data access and soft delete/purge protection aid recovery.
  name                          = "kvcontosolab655d6"
  location                      = azurerm_resource_group.contoso.location
  resource_group_name           = azurerm_resource_group.contoso.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"

  rbac_authorization_enabled    = true
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  # Public network access remains enabled; authorization is enforced by Key Vault RBAC.
  public_network_access_enabled = true

  tags = {
    Environment = "Lab"
    ManagedBy   = "Jay"
    Owner       = "CloudEngineering"
    Project     = "EnterpriseCloud"
  }
}

# Prevents accidental deletion of the vault while leaving its contents manageable by authorized roles.
resource "azurerm_management_lock" "keyvault_protection" {
  name       = "lock-keyvault-delete"
  scope      = azurerm_key_vault.contoso.id
  lock_level = "CanNotDelete"
  notes      = "Prevents accidental deletion of the Key Vault."
}

# Centralized monitoring
resource "azurerm_log_analytics_workspace" "contoso" {
  # Workspace for collecting and querying supported Azure diagnostic data with 30-day retention.
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

# Routes Key Vault audit events and supported metrics to the centralized workspace.
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


# Sends Azure Monitor alert notifications to the confirmed email receiver.
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

# Azure Monitor alert for failed Key Vault secret retrievals.
# Detects failed SecretGet operations (HTTP 400+) from the centralized audit stream.
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

  # Routes fired alert notifications to the email Action Group above.
  action {
    action_groups = [azurerm_monitor_action_group.contoso.id]
  }
}
