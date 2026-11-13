# Architecture

## Purpose

A segmented Azure lab for practicing infrastructure administration, cloud identity, least-privilege authorization, secrets management, and centralized monitoring.

## Deployed components

| Component | Configuration | Purpose / current status |
|---|---|---|
| Resource group | `rg-contoso-cloud-lab`, Central US | Organizes related resources and access/cost scope |
| Virtual network | `vnet-contoso-prod`, `10.10.0.0/16` | Private network address space |
| Application subnet | `sn-app`, `10.10.1.0/24` | Separate zone for future application workloads; default outbound access disabled |
| Management subnet | `sn-mgmt`, `10.10.2.0/24` | Isolated management zone; default outbound access disabled |
| NSGs | `nsg-app`, `nsg-mgmt` | Subnet-level traffic filters; custom rules and traffic tests remain outstanding |
| Management VM | `vm-mgmt-01`, Windows Server 2025, no public IP | Administration/security test workload; currently deallocated |
| Managed identity | System-assigned identity on VM | Lets VM authenticate to Azure without storing service credentials |
| Azure RBAC | Reader at resource-group scope for VM identity | Read-only visibility into the lab resource group |
| Key Vault | `kvcontosolab655d6`, RBAC, soft delete, purge protection | Central secret store; public network access currently enabled |
| Key Vault lock | `CanNotDelete` | Protects the vault from accidental deletion |
| Log Analytics | `law-contoso-cloud-lab`, 30-day retention | Central destination for supported diagnostic data |
| Diagnostic setting | Key Vault AuditEvent + AllMetrics | Configured to route vault diagnostics; event ingestion still being verified |

## Trust boundaries and data flow

1. The resource group contains the lab resources.
2. The VNet contains separate application and management subnets.
3. Each subnet has an associated NSG; least-privilege custom rules and connectivity testing are not yet complete.
4. The Windows management VM has a private NIC and no public IP.
5. The VM's system-assigned identity is granted Reader at resource-group scope and Key Vault Secrets User at the vault scope.
6. The lab operator's Entra user has Key Vault Secrets Officer at the vault scope to manage synthetic test secrets.
7. Key Vault diagnostic settings are configured to send AuditEvent logs and AllMetrics to Log Analytics. A matching event has not yet been observed in the workspace.

## Security caveats

- The Key Vault public endpoint is enabled. RBAC protects authorization, but this is not a private-network-only vault.
- The VM has no public IP. A secure administration path and guest-level health checks remain to be completed.
- Disabling default outbound access on the subnets does not itself provide a replacement outbound path.
- NSG default rules have been reviewed, but custom traffic policy and allowed/denied path tests are still pending.
- The VNet name includes `prod` for naming practice; this is a lab, not a production environment.

## Future components

Secure Azure Storage, vulnerability assessment/remediation, local Docker/Trivy scanning, baseline assessment, and final portfolio evidence remain planned work.
