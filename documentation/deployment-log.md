# Deployment Log

This log records the implementation and validation results. A successful deployment is not the same as a successful functional test; remaining checks are called out explicitly.

## Existing infrastructure and Terraform adoption

The resource group, VNet, application and management subnets, NSGs, subnet/NSG associations, management NIC, and Windows Server VM were imported into Terraform state. The VM uses a sensitive `admin_password` variable stored in a local, ignored `terraform.tfvars`. Earlier import/reconciliation work produced a clean plan with 0 add, 0 change, and 0 destroy.

## Identity and access management

### VM managed identity

- Added a system-assigned managed identity to `vm-mgmt-01` through Terraform.
- Apply result: 0 added, 1 changed, 0 destroyed.
- Verified identity type: `SystemAssigned`.
- The VM principal ID was returned by Azure CLI; identifiers are not repeated in this public project log.

### Resource-group Reader role

- Assigned the VM managed identity the built-in **Reader** role at the `rg-contoso-cloud-lab` resource-group scope.
- Added the role assignment to Terraform and imported the existing assignment into state.
- Verified the role assignment list showed Reader at the resource-group scope.
- Significance: allows resource visibility without granting resource modification.

## Key Vault and secrets management

### Key Vault deployment

- Vault: `kvcontosolab655d6`.
- SKU: Standard.
- Authorization: Azure RBAC enabled.
- Soft-delete retention: 7 days.
- Purge protection: enabled.
- Public network access: enabled; private endpoint/network isolation has not been implemented.
- Terraform apply succeeded.

### VM secret-read permission

- Assigned **Key Vault Secrets User** to the VM's system-assigned managed identity at the Key Vault scope.
- Verified the role assignment.
- Significance: the VM identity can read secret values when it authenticates to the vault; it cannot manage secrets.

### Operator secret-management permission

- Assigned **Key Vault Secrets Officer** to the lab operator's Entra user at the Key Vault scope.
- Terraform apply succeeded.
- Initial secret creation was denied before this assignment because the caller was the operator user, not the VM managed identity.
- After the role assignment, the user confirmed secret creation succeeded.
- Secret name: `Lab-Test-Secret`; synthetic test value was used.
- User confirmed the secret retrieval command returned the expected name and enabled status without displaying the secret value.

### Deletion protection

- Added management lock `lock-keyvault-delete` with level `CanNotDelete`.
- Terraform apply succeeded.
- Azure CLI lock listing verified the lock name, level, and note.
- Significance: prevents accidental deletion of the vault; it does not prevent authorized secret changes.

## Centralized monitoring and diagnostics

### Log Analytics workspace

- Workspace: `law-contoso-cloud-lab`.
- SKU: `PerGB2018`.
- Retention: 30 days.
- Terraform apply succeeded.
- Azure CLI verification confirmed the workspace name, SKU, retention, and provisioning state `Succeeded`.

### Key Vault diagnostic setting

- Diagnostic setting: `diag-keyvault-audit`.
- Target: Key Vault `kvcontosolab655d6`.
- Destination: `law-contoso-cloud-lab`.
- Enabled log category: `AuditEvent`.
- Enabled metric category: `AllMetrics`.
- Terraform apply succeeded.
- Azure CLI diagnostic-settings query confirmed the setting name and enabled categories.

### Audit event query — pending validation

- A Key Vault secret-read operation was executed successfully to generate an audit event.
- The Azure CLI `log-analytics` extension was installed in preview because no stable extension version was available.
- The first Log Analytics query returned no records.
- **Status: Not yet confirmed.** Allow ingestion time, then query again. If records remain absent, inspect diagnostic-setting destination/category and workspace query/table availability before changing infrastructure.
- Do not claim that audit event ingestion is working until a matching record is returned.

## Outstanding validation

- [ ] Confirm Key Vault AuditEvent records appear in Log Analytics.
- [ ] Complete NSG custom-rule design and allowed/denied traffic tests.
- [ ] Validate VM agent health, administration path, outbound connectivity, and Windows patch state.
- [ ] Complete Storage Account security exercise.
- [ ] Complete vulnerability scan, remediation, and retest.
- [ ] Complete local Docker/Trivy exercise.
- [ ] Complete baseline assessment and portfolio evidence.
