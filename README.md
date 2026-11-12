# Azure Enterprise Infrastructure Lab

A hands-on, portfolio-focused Azure project demonstrating the design, deployment, configuration, and validation of core cloud infrastructure and security controls.

> **Project status:** In progress  
> **Environment:** Azure trial subscription  
> **Region:** Central US  
> **Resource group:** `rg-contoso-cloud-lab`

## Objectives

- Design a segmented Azure virtual network.
- Deploy and securely administer Windows Server infrastructure.
- Configure Microsoft Entra ID identities and Azure role-based access control (RBAC).
- Collect and investigate operational and security logs.
- Document validation, troubleshooting, and cost controls.
- Introduce repeatable administration with PowerShell and infrastructure as code (Bicep).

## Project plan

| Stage | Work | Status |
|---|---|---|
| 1 | Resource group, cost guardrails, and network design | In progress |
| 2 | Virtual network, subnets, and network security groups | Planned |
| 3 | Windows Server virtual machine | Planned |
| 4 | Entra ID and RBAC | Planned |
| 5 | Azure Monitor and Log Analytics | Planned |
| 6 | Security investigation and KQL | Planned |
| 7 | PowerShell, Bicep, and final documentation | Planned |

## Current environment

| Resource or setting | Configuration |
|---|---|
| Resource group | `rg-contoso-cloud-lab` |
| Azure region | Central US |
| Virtual network name | `vnet-contoso-prod` (lab resource) |
| Virtual network address space | `10.10.0.0/16` |
| Planned application subnet | `sn-app` — `10.10.1.0/24` |
| Planned management subnet | `sn-mgmt` — `10.10.2.0/24` |

Subnet deployment and validation will be updated as the build progresses. The word `prod` in the virtual network name is a naming choice for this simulated environment; this is a lab, not a production workload.

## Repository guide

- [Architecture](documentation/architecture.md) — project design and component relationships.
- [Network design](documentation/network-design.md) — address plan, subnet purpose, and network decisions.
- [Deployment log](documentation/deployment-log.md) — chronological build notes and validation evidence.
- [Security controls](documentation/security-controls.md) — access and network security decisions.
- [Diagrams](diagrams/README.md) — architecture and network diagrams.
- [Screenshots](screenshots/README.md) — sanitized evidence from the Azure portal.
- [Scripts](scripts/README.md) — PowerShell and Bicep automation.

## Key terms

- **Resource group:** A logical container for related Azure resources.
- **Virtual network (VNet):** A private network boundary in Azure.
- **Subnet:** A smaller IP network carved out of a VNet.
- **Network security group (NSG):** A rule set that allows or denies network traffic.
- **Microsoft Entra ID:** Microsoft's cloud identity and access-management service.
- **RBAC:** Role-based access control; permissions assigned through roles.
- **Log Analytics:** An Azure service/workspace used to collect and query log data.
- **KQL:** Kusto Query Language, used to query supported Azure data.
- **Bicep:** A declarative language for deploying Azure resources as code.

## Cost and security notes

This project is designed around a limited Azure trial-credit budget. Resource costs vary by region, configuration, and usage. Check cost estimates before deployment, monitor actual usage, and deallocate or delete billable resources when they are not needed. A budget alert notifies you; it does not itself stop resources.

Never commit passwords, access tokens, private keys, connection strings, or unredacted personal or subscription information. Screenshots must be reviewed and sanitized before publication.

## Validation standard

A resource is not considered complete merely because it was created. Each stage should include:
1. The configuration applied.
2. A brief explanation of the setting and why it was selected.
3. A validation check and its result.
4. Sanitized evidence where useful.
5. Any issue encountered and how it was resolved.

