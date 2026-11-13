# Security Controls

## Implemented controls and evidence

| Area | Implemented control | Validation / limitation |
|---|---|---|
| Network segmentation | Separate application and management subnets | Subnets and NSG associations verified; custom NSG rules and traffic tests pending |
| Public exposure | Management VM has no public IP | Confirmed in Azure inventory |
| Outbound access | Default outbound access disabled on both subnets | No replacement egress path has been established; outbound connectivity remains to be tested |
| VM platform security | Trusted Launch, Secure Boot, and vTPM enabled | Configured on Windows Server 2025 VM |
| Managed identity | System-assigned identity on management VM | Identity verified |
| Azure RBAC | VM identity has Reader at resource-group scope | Role assignment verified |
| Key Vault data access | VM identity has Key Vault Secrets User at vault scope | Role assignment verified; VM-side identity access test remains pending |
| Operator permissions | Entra user has Key Vault Secrets Officer at vault scope | Secret creation and retrieval confirmed |
| Secrets protection | Key Vault RBAC, 7-day soft delete, purge protection | Configuration deployed |
| Deletion protection | Key Vault CanNotDelete lock | Azure CLI lock listing verified |
| Centralized logging | Log Analytics workspace, 30-day retention | Workspace settings verified |
| Key Vault diagnostics | AuditEvent and AllMetrics diagnostic categories enabled | Setting verified; successful event ingestion/query remains pending |

## Important scope distinctions

- **Reader** is a management-plane role; it provides visibility but not resource changes.
- **Key Vault Secrets User** is a data-plane role for reading secret contents.
- **Key Vault Secrets Officer** allows secret lifecycle management at the assigned vault scope; it does not grant general ownership of the Azure subscription.
- **CanNotDelete** prevents deletion of the locked resource, but it does not make secret values immutable.
- Key Vault public network access is currently enabled. RBAC is not a network firewall; private endpoint or network ACL hardening is a separate future task.

## Remaining control work

- Design minimal NSG allow rules and validate allowed and denied network paths.
- Establish a supported secure VM administration method without public RDP exposure.
- Validate VM agent health, outbound connectivity, and patch state.
- Confirm Key Vault audit event ingestion in Log Analytics.
- Configure and test secure Storage Account access.
- Perform vulnerability discovery, remediation, and retesting.
- Complete container image scanning and baseline assessment.

## Credential handling

Never commit passwords, private keys, access tokens, connection strings, real secret values, or Terraform state. Use synthetic test data and sanitized screenshots only.
