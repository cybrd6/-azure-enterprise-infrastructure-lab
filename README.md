# Azure Enterprise Infrastructure & Security Operations Lab

A hands-on Azure portfolio project demonstrating network design, Windows Server infrastructure, identity and access management, secrets management, centralized monitoring, and security validation.

> **Current project progress:** 95% — core infrastructure, subnet-level network isolation rules, Key Vault auditing, centralized logging, failed-secret-access detection, and email alert delivery are deployed and verified.
> **Environment:** Azure trial subscription · **Region:** Central US · **Resource group:** `rg-contoso-cloud-lab`
> **Primary IaC:** Terraform with AzureRM provider `~> 4.0`

## Current implementation

| Area | Implemented configuration | Current validation/status |
|---|---|---|
| Resource organization | Resource group and tags | Deployed |
| Network | VNet `10.10.0.0/16`; app subnet `10.10.1.0/24`; management subnet `10.10.2.0/24` | Deployed; both subnets have default outbound access disabled |
| Network filtering | `nsg-app` and `nsg-mgmt` associated to their subnets; `Deny-Mgmt-To-App` and `Deny-App-To-Mgmt` inbound rules at priority 4000 | Both custom rules deployed and verified in Azure; live packet-flow testing remains outstanding |
| Compute | Windows Server 2025 management VM, private NIC, no public IP, Trusted Launch, Secure Boot, vTPM | Deployed; currently deallocated; guest access/agent and network tests remain outstanding |
| Terraform | Existing infrastructure imported; VM managed identity and later resources represented in code | Terraform validate/plan/apply used during implementation; network-rule plan showed 2 additions, 0 changes, 0 destructions |
| Managed identity / RBAC | VM system-assigned identity; Reader at resource-group scope | Identity and role assignment verified |
| Key Vault | `kvcontosolab655d6`; RBAC authorization; 7-day soft delete; purge protection; deletion lock | Deployed; lock and role assignments verified |
| Key Vault data access | VM identity: Key Vault Secrets User; operator: Key Vault Secrets Officer | Test secret created and read successfully using operator account |
| Monitoring | Log Analytics workspace `law-contoso-cloud-lab`, PerGB2018, 30-day retention | Workspace deployed and settings verified |
| Diagnostics | Key Vault AuditEvent and AllMetrics sent to Log Analytics | Verified actual Key Vault audit records in `AzureDiagnostics`, including successful reads and a controlled 404 secret lookup; detection query confirmed the failed request |
| Security alerting | Azure Monitor scheduled query alert `alert-kv-failed-secret-access` | Deployed and verified enabled at severity 2; evaluates every 5 minutes for `SecretGet` events with HTTP status 400+ |
| Notifications | Action Group `ag-contoso-alerts` with confirmed email receiver | End-to-end test successful: controlled Key Vault 404 generated, detected, alert fired, and email notification received |

## Architecture summary

- **VNet and subnets** separate application and management address spaces.
- **NSGs** are associated at the subnet level. Two explicit inbound deny rules block traffic from the management subnet to the application subnet and vice versa. These rules have priority 4000, ahead of Azure's default virtual-network inbound allow rule. Live packet-flow testing has not yet been performed.
- **Management VM** has no public IP. Its system-assigned managed identity avoids embedding Azure service credentials in the VM.
- **Azure RBAC** grants Reader at the resource-group scope and Key Vault Secrets User at the vault scope to the VM identity.
- **Key Vault** centralizes secrets and uses RBAC, soft delete, purge protection, and a CanNotDelete lock. Public network access is currently enabled; this vault is not described as network-isolated.
- **Log Analytics** is the central workspace. Key Vault diagnostic settings route audit events and metrics there; actual audit ingestion and KQL detection of failed secret retrievals have been validated.
- **Azure Monitor alerting** evaluates failed Key Vault secret retrievals every five minutes. A confirmed email Action Group is connected, and an end-to-end test successfully delivered an alert notification.

## Terraform directory

- `main.tf` — Azure resources, dependencies, and network isolation rules.
- `variables.tf` — sensitive VM administrator password input and other configuration variables.
- `providers.tf` — AzureRM provider configuration using the authenticated Azure CLI session.
- `versions.tf` — Terraform and provider version constraints.
- `terraform.tfvars` — local-only secret values; never commit.
- Terraform state, provider cache, saved plans, and real variable files must remain out of source control.

## Remaining work

1. Perform controlled allowed/denied network traffic tests when a safe test path and running workload are available; management VM is currently deallocated.
2. Validate management VM agent health, secure administration, outbound connectivity, and Windows patch state.
3. Complete secure Azure Storage configuration and access tests.
4. Perform vulnerability discovery, remediation, and retesting.
5. Complete local container image scanning with Docker/Trivy.
6. Assess selected settings against a documented security baseline.
7. Add sanitized screenshots, architecture evidence, final Terraform validation, and lessons learned.

## Cost and security guardrails

- Check current Azure pricing before enabling additional services; monitor trial credit and actual usage.
- Keep the management VM deallocated when not in use. Managed disks may still incur charges.
- Avoid unnecessary paid services such as Bastion, NAT Gateway, VPN Gateway, AKS, or paid Defender plans unless cost is reviewed first.
- Do not expose RDP/SSH to the entire internet.
- Do not commit passwords, access tokens, private keys, connection strings, Terraform state, or unredacted identifiers.
- Review every Terraform plan before applying; avoid unintended replacement or destruction.

## Validation standard

A configured resource is not fully validated merely because deployment succeeded. Record the configuration, why it matters, the validation command/result, and any remaining limitations. Mark a phase complete only after its required tests and evidence are complete.

## References

- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/)
- [Azure managed identities](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/overview)
- [Azure RBAC](https://learn.microsoft.com/azure/role-based-access-control/overview)
- [Key Vault RBAC guide](https://learn.microsoft.com/azure/key-vault/general/rbac-guide)
- [Key Vault soft delete](https://learn.microsoft.com/azure/key-vault/general/soft-delete-overview)
- [Azure Monitor diagnostic settings](https://learn.microsoft.com/azure/azure-monitor/platform/diagnostic-settings)
- [Log Analytics overview](https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-workspace-overview)
- [Terraform documentation](https://developer.hashicorp.com/terraform/docs)
