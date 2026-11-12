# Azure Enterprise Infrastructure & Security Operations Lab

A hands-on, portfolio-focused Azure project demonstrating the design, deployment, hardening, monitoring, assessment, and documentation of cloud infrastructure and security controls.

> **Project status:** In progress  
> **Environment:** Azure trial subscription  
> **Primary region:** Central US  
> **Resource group:** `rg-contoso-cloud-lab`  
> **Primary platform:** Microsoft Azure  
> **Infrastructure as Code (IaC):** Terraform adoption in progress  
> **Cost constraint:** Keep the lab within the available trial-credit budget; avoid unnecessary paid services.

## Project objectives

- Build a segmented Azure network and securely administer a Windows Server workload.
- Configure Microsoft Entra ID, Azure RBAC, and least-privilege access.
- Secure cloud storage and review network exposure.
- Collect and investigate logs using Azure Monitor, Log Analytics, and KQL.
- Perform vulnerability discovery, risk prioritization, remediation, and retesting.
- Demonstrate container image security with local Docker and Trivy scans, without deploying a paid Kubernetes cluster.
- Assess selected configurations against baseline security recommendations and document evidence.
- Adopt the already-deployed Azure infrastructure into Terraform without rebuilding it; validate plans before making changes.
- Use PowerShell for operational tasks. Bicep may be used for a small Azure-native comparison, but Terraform is the primary IaC learning path.
- Relate cloud controls to the existing on-premises Active Directory home lab without claiming a production hybrid connection.

## Project roadmap

| Phase | Work | Main evidence | Status |
|---|---|---|---|
| 1 | Foundation, resource group, budget guardrails, architecture | Resource group, tags, cost plan | Complete |
| 2 | VNet, subnets, NSGs, network validation | Address plan, effective rules, connectivity tests | Configuration complete; traffic validation pending |
| 3 | Windows Server workload and secure administration | VM configuration, patch state, restricted admin access | VM deployed and deallocated; administration and hardening pending |
| 3A | Terraform adoption of existing Azure infrastructure | Terraform configuration, imported state, clean plan | In progress — CLI authenticated, provider initialized, resource group import initiated |
| 4 | Entra ID, Azure RBAC, least privilege | Role assignments and access tests | Planned |
| 5 | Secure Azure Storage | Public-access restrictions, authorization and encryption review | Planned |
| 6 | Logging, monitoring, and security investigation | Diagnostic settings, Log Analytics queries, alert evidence | Planned |
| 7 | Vulnerability assessment and remediation | Scan findings, risk ranking, remediation and retest | Planned |
| 8 | Container security | Docker image scan, findings, rebuilt image and retest | Planned |
| 9 | Security baseline and compliance review | Azure Policy/Defender recommendations review and control matrix | Planned |
| 10 | PowerShell, IaC refinement, final validation, and portfolio publication | Reusable code, diagrams, evidence, lessons learned | Planned |

Terraform adoption is intended to bring existing resources under code management, not recreate the Azure environment. The resource group import command has been initiated; successful completion and state verification are pending. No Terraform apply has been performed.

## Current environment

| Resource or setting | Configuration |
|---|---|
| Resource group | `rg-contoso-cloud-lab` |
| Azure region | Central US |
| Virtual network | `vnet-contoso-prod` — lab resource |
| VNet address space | `10.10.0.0/16` |
| Application subnet | `sn-app` — `10.10.1.0/24` |
| Management subnet | `sn-mgmt` — `10.10.2.0/24` |
| Application NSG | `nsg-app`, associated with `sn-app` |
| Management NSG | `nsg-mgmt`, associated with `sn-mgmt` |
| Windows Server VM | `vm-mgmt-01`, Windows Server 2025 Datacenter: Azure Edition |
| VM size | `Standard_D2as_v7` — 2 vCPUs, 8 GiB RAM |
| VM power state at end of latest confirmed Azure session | Stopped (deallocated) |
| Public IP / public inbound ports | None / None |

The word `prod` in the VNet name is a naming choice for this simulated environment; this is a lab, not a production workload. The VM deployment showed an Azure VM Agent readiness warning, and outbound connectivity has not yet been tested. See the deployment log.

## Terraform workstation progress

- Terraform CLI installed and verified: v1.17.2 (Windows AMD64).
- Azure CLI installed; command verified after adding its installation directory to the current PowerShell PATH and then the user PATH.
- Azure CLI authenticated successfully; the single available subscription was selected.
- Azure resource inventory and resource group properties were inspected using read-only Azure CLI commands.
- Local Terraform configuration created: `versions.tf`, `providers.tf`, and `main.tf`.
- AzureRM provider initialized with `terraform init`; `terraform fmt` and `terraform validate` succeeded.
- Resource group import command initiated; completion and state verification are pending.
- No `terraform apply` has been run. Do not commit Terraform state or credentials.

## Repository guide

- [Architecture](documentation/architecture.md) — component relationships and trust boundaries.
- [Network design](documentation/network-design.md) — address plan, subnet purpose, and network decisions.
- [Deployment log](documentation/deployment-log.md) — chronological build notes and validation evidence.
- [Security controls](documentation/security-controls.md) — access, network, and hardening decisions.
- [Role-alignment roadmap](documentation/role-alignment-roadmap.md) — maps project evidence to the target job requirements.
- [Terraform adoption plan](documentation/terraform-adoption-plan.md) — safe adoption of existing resources into Terraform.
- [Vulnerability management](documentation/vulnerability-management.md) — scan, prioritize, remediate, and retest workflow.
- [Container security](documentation/container-security.md) — local Docker and Trivy security exercise.
- [Storage security](documentation/storage-security.md) — Azure Storage hardening and validation.
- [Compliance assessment](documentation/compliance-assessment.md) — baseline review and control evidence.
- [Diagrams](diagrams/README.md) — architecture and network diagrams.
- [Screenshots](screenshots/README.md) — sanitized evidence from the Azure portal.
- [Scripts](scripts/README.md) — PowerShell and future IaC automation.
- [Terraform directory](terraform/) — local Terraform configuration and adoption work.

## Key terms

- **Resource group:** A logical container for related Azure resources.
- **Virtual network (VNet):** A private network boundary in Azure.
- **Subnet:** A smaller IP network carved out of a VNet.
- **Network security group (NSG):** A rule set that allows or denies network traffic.
- **Microsoft Entra ID:** Microsoft's cloud identity and access-management service.
- **RBAC:** Role-based access control; permissions assigned through roles.
- **Least privilege:** Giving an identity only the access required for its task.
- **Log Analytics:** An Azure service/workspace used to collect and query log data.
- **KQL:** Kusto Query Language, used to query supported Azure data.
- **Vulnerability:** A weakness that could be exploited to affect confidentiality, integrity, or availability.
- **Remediation:** An action that removes or reduces a security weakness.
- **Container image:** A packaged template used to create a container.
- **Trivy:** An open-source scanner for vulnerabilities and other risks in container images and related artifacts.
- **Azure Policy:** A service for evaluating and enforcing organizational rules on Azure resources.
- **Infrastructure as Code (IaC):** Managing infrastructure through declarative or programmatic configuration files.
- **Terraform:** An IaC tool that uses configuration and state to manage resources across cloud providers.
- **Terraform state:** Terraform's record of the resources it manages and their relationship to configuration.

## Cost and safety guardrails

This project is designed around a limited Azure trial-credit budget. Check estimates and current pricing before creating resources. Monitor actual cost, use the smallest practical VM size, and deallocate or delete billable resources when they are not needed. A budget alert notifies you; it does not itself stop resources.

- Do not deploy AKS, Bastion, VPN Gateway, NAT Gateway, or other costly services for this portfolio exercise.
- Perform Docker and Trivy exercises locally where possible; do not provision a Kubernetes cluster.
- Prefer free configuration assessment features and local tools. Do not enable paid Defender plans or paid scanning tiers without checking cost and receiving an explicit decision.
- Keep Log Analytics ingestion small; send only the data needed for the exercise and review retention settings.
- Do not expose RDP (TCP 3389) or SSH (TCP 22) to the entire internet.
- Keep the VM deallocated when it is not actively needed. Managed disk storage may continue to incur charges.
- Terraform import and planning do not require rebuilding the infrastructure. Never run `terraform apply` until the plan has been reviewed for unintended replacement or deletion.
- Never commit Terraform state, passwords, access tokens, private keys, connection strings, or unredacted personal, tenant, or subscription information.

## Validation standard

A resource or control is not complete merely because it was created. Each phase should include:
1. The configuration applied.
2. A brief definition and reason for the setting.
3. A validation check and its actual result.
4. Sanitized evidence where useful.
5. Any issue encountered, remediation, and retest result.
6. Cost or security trade-offs that influenced the decision.

Only mark work **Complete** after it has been performed and validated. Keep planned work clearly labeled as planned.
