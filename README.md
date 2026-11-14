# Azure Enterprise Infrastructure & Security Operations Lab

A hands-on Azure portfolio project demonstrating network design, Windows Server infrastructure, identity and access management, secrets management, centralized monitoring, alerting, storage security, and infrastructure-as-code validation.

> **Project implementation:** 100% — planned lab infrastructure and security-control implementation is complete. Remaining items are explicitly documented validation limitations and optional production-hardening improvements.
> **Environment:** Azure trial subscription · **Region:** Central US · **Resource group:** `rg-contoso-cloud-lab`
> **Primary IaC:** Terraform with AzureRM provider `~> 4.0`

## Current implementation

| Area | Implemented configuration | Current validation/status |
|---|---|---|
| Resource organization | Resource group and tags | Deployed |
| Network | VNet `10.10.0.0/16`; app subnet `10.10.1.0/24`; management subnet `10.10.2.0/24` | Deployed; both subnets have default outbound access disabled |
| Network filtering | `nsg-app` and `nsg-mgmt` associated to their subnets; explicit bidirectional subnet deny rules at priority 4000 | Associations and rules verified in Azure; live packet-flow testing remains outstanding |
| Compute | Windows Server 2025 management VM, private NIC, no public IP, Trusted Launch, Secure Boot, vTPM, host encryption, system-assigned identity | Deployed; currently deallocated |
| Terraform | Azure infrastructure represented in Terraform; existing NIC/NSG association imported into state; storage diagnostics modeled | `terraform fmt`, `terraform validate`, and `terraform plan` completed; final plan reported no changes |
| Managed identity / RBAC | VM system-assigned identity; Reader at resource-group scope | Identity and role assignment verified |
| Key Vault | `kvcontosolab655d6`; RBAC authorization; 7-day soft delete; purge protection; deletion lock; firewall default deny with operator IP allowlisted | Deployed; lock, role assignments, and network ACL configuration verified |
| Key Vault data access | VM identity: Key Vault Secrets User; operator: Key Vault Secrets Officer | Test secret created and accessed successfully using operator identity; secret value excluded from repository |
| Monitoring | Log Analytics workspace `law-contoso-cloud-lab`, 30-day retention | Workspace deployed and settings verified |
| Diagnostics | Key Vault AuditEvent/AllMetrics and Storage Blob StorageRead/StorageWrite/StorageDelete routed to Log Analytics | Diagnostic settings verified; Key Vault audit events observed; storage diagnostic categories confirmed |
| Security alerting | Azure Monitor scheduled query alert `alert-kv-failed-secret-access` | Severity 2, 5-minute evaluation; failed secret retrieval detection validated |
| Notifications | Action Group `ag-contoso-alerts` with confirmed email receiver | End-to-end test successful: controlled Key Vault 404 generated, detected, alert fired, and email notification received |
| Azure Storage | `contosolabstorage655d6`; HTTPS-only; TLS 1.2 minimum; network default deny with AzureServices bypass and operator IP allowlist; LRS; 7-day blob/container soft-delete retention | Private container `contoso-private-data`; container-scoped Storage Blob Data Contributor; authenticated upload/list/download passed; server-side encryption confirmed; anonymous request returned HTTP 409 |
| Security scanning | Trivy Terraform misconfiguration scan | 0 Critical, 0 High; 2 Medium and 1 Low accepted/documented (see Security scan results) |

## Architecture summary

- **VNet and subnets** separate application and management address spaces.
- **NSGs** are associated at both subnet and management NIC scope. Two explicit inbound deny rules block traffic from the management subnet to the application subnet and vice versa. These rules have priority 4000, ahead of Azure's default virtual-network inbound allow rule. Live packet-flow testing has not been performed.
- **Management VM** has no public IP and is kept deallocated when not in use. Its system-assigned managed identity avoids embedding Azure service credentials in the VM.
- **Azure RBAC** grants Reader at the resource-group scope and Key Vault Secrets User at the vault scope to the VM identity.
- **Key Vault** centralizes secrets and uses RBAC, soft delete, purge protection, a CanNotDelete lock, and a default-deny network ACL with the operator IP allowlisted. A private endpoint was not deployed because a working private routing/administration path was not available for this lab.
- **Log Analytics** is the central workspace. Key Vault audit events and Storage Blob read/write/delete diagnostics are routed there.
- **Azure Monitor alerting** evaluates failed Key Vault secret retrievals every five minutes. A confirmed email Action Group is connected, and an end-to-end test successfully delivered an alert notification.
- **Azure Storage** uses HTTPS-only transport, TLS 1.2 minimum, default-deny network rules, disabled anonymous blob access, and 7-day soft-delete retention. The private container has operator data access scoped through Storage Blob Data Contributor. Authenticated upload/list/download tests passed, server-side encryption was confirmed, and an unauthenticated request was rejected with HTTP 409.

## Security scan results

Final local command: `trivy config .`

| Check | Severity | Result / disposition |
|---|---|---|
| AZU-0057 — Storage logging | Medium | Trivy's Terraform rule did not recognize the Azure Monitor Blob diagnostic setting. The configured StorageRead, StorageWrite, and StorageDelete categories were independently verified against the Blob service diagnostic setting. |
| AZU-0058 — Geo-redundant storage | Low | LRS retained intentionally as a cost-conscious lab choice; no regional redundancy claim is made. |
| AZU-0061 — Infrastructure encryption | Medium | Not enabled on the existing storage account. Enabling it at this stage may require account replacement; replacement was deliberately avoided. |
| Critical / High findings | Critical / High | 0 / 0 |

Trivy also warned that the local `admin_password` variable value was not available to its static Terraform parser. The sensitive value remains in local-only `terraform.tfvars` and is not committed. This warning does not indicate that a password was added to source control.

## Known limitations and future hardening

These are documented boundaries of the completed lab, not claims of tests that were not performed:

1. **Network data-plane testing:** no live allowed/denied packet-flow test was run because there is no running application workload; the management VM is deallocated.
2. **VM operations:** guest-agent health, patch compliance, and secure remote administration were not validated against a running VM.
3. **Private endpoints:** Key Vault and Storage do not have private endpoints. Network restrictions were configured without claiming private-link isolation.
4. **Paid security services:** paid Defender plans and Azure Backup were not enabled to avoid unapproved ongoing costs.
5. **Storage durability:** LRS is used instead of geo-redundant replication.
6. **Infrastructure encryption:** the existing Storage account was not replaced to enable infrastructure-level double encryption.

## Terraform directory

- `main.tf` — Azure resources, dependencies, network isolation rules, monitoring, diagnostics, and storage RBAC.
- `variables.tf` — sensitive VM administrator password input and other configuration variables.
- `providers.tf` — AzureRM provider configuration using the authenticated Azure CLI session.
- `versions.tf` — Terraform and provider version constraints.
- `terraform.tfvars` — local-only secret values; never commit.
- Terraform state, provider cache, saved plans, and real variable files must remain out of source control.

## Cost and security guardrails

- Check current Azure pricing before enabling additional services; monitor trial credit and actual usage.
- Keep the management VM deallocated when not in use. Managed disks may still incur charges.
- Avoid unnecessary paid services such as Bastion, NAT Gateway, VPN Gateway, AKS, paid Defender plans, or Azure Backup unless cost is reviewed first.
- Do not expose RDP/SSH to the entire internet.
- Do not commit passwords, access tokens, private keys, connection strings, Terraform state, or unredacted identifiers.
- Review every Terraform plan before applying; avoid unintended replacement or destruction.

## Validation standard

A configured resource is not fully validated merely because deployment succeeded. Record the configuration, why it matters, the validation command/result, and any remaining limitations. This project distinguishes deployed controls from data-plane tests and documents accepted residual risks.

## References

- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/)
- [Azure managed identities](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/overview)
- [Azure RBAC](https://learn.microsoft.com/azure/role-based-access-control/overview)
- [Key Vault RBAC guide](https://learn.microsoft.com/azure/key-vault/general/rbac-guide)
- [Key Vault soft delete](https://learn.microsoft.com/azure/key-vault/general/soft-delete-overview)
- [Azure Monitor diagnostic settings](https://learn.microsoft.com/azure/azure-monitor/platform/diagnostic-settings)
- [Log Analytics overview](https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-workspace-overview)
- [Terraform documentation](https://developer.hashicorp.com/terraform/docs)
