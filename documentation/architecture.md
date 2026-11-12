# Architecture

## Purpose

Build a small, segmented Azure environment that demonstrates infrastructure administration and security practices relevant to an entry-level cloud infrastructure security role.

## Environment

- **Resource group:** `rg-contoso-cloud-lab`
- **Region:** Central US
- **Virtual network:** `vnet-contoso-prod` (lab resource)
- **Address space:** `10.10.0.0/16`
- **Application subnet:** `sn-app` — `10.10.1.0/24` (planned)
- **Management subnet:** `sn-mgmt` — `10.10.2.0/24` (planned)

The deployment log is the source of truth for what has actually been created and tested. The Windows Server 2025 VM is deployed in the management subnet with no public IP or public inbound ports. It was deallocated after deployment to stop compute charges.

## Planned architecture components

| Component | Security or operational purpose | Status |
|---|---|---|
| Resource group and tags | Organize resources and support cost/governance tracking | Created |
| Virtual network and subnets | Establish network boundaries and segmentation | Created; both subnets user-confirmed |
| Network security groups | Restrict traffic between network zones and workloads | Created, associated, and default rules reviewed |
| Windows Server VM | Provide a manageable server workload for hardening and logging exercises | Deployed; currently deallocated; guest-agent readiness and connectivity checks pending |
| Microsoft Entra ID | Cloud identity and authentication foundation | Planned |
| Azure RBAC | Scope administrative permissions using least privilege | Planned |
| Azure Storage Account | Demonstrate secure data access, encryption, and public-access restrictions | Planned |
| Azure Monitor / Log Analytics | Collect and query operational/security-relevant telemetry | Planned |
| Vulnerability assessment workflow | Discover, rank, remediate, and retest weaknesses | Planned |
| Docker + Trivy (local) | Demonstrate container image risk assessment without a cloud cluster | Planned |
| Azure Policy / security recommendations | Assess selected resource configurations against a baseline | Planned |
| PowerShell and Bicep | Automate selected checks and repeatable infrastructure deployment | Planned |

## How the components relate

1. The resource group organizes the lab resources.
2. The VNet provides private address space; subnets separate workload and management functions.
3. NSGs filter network traffic at subnet or network-interface boundaries.
4. A Windows Server VM provides a workload for secure administration, patch review, and log investigation.
5. Entra ID authenticates cloud identities; Azure RBAC determines what those identities can do and at what scope.
6. A Storage Account provides a data resource whose network access, public access, authorization, and encryption settings can be assessed.
7. Azure Monitor and Log Analytics provide visibility into supported platform and workload events.
8. Vulnerability assessment identifies weaknesses; remediation changes are followed by a retest.
9. A local Docker/Trivy exercise extends the assessment workflow to container images without incurring managed Kubernetes costs.
10. Azure Policy and security recommendations support a documented baseline review.

## On-premises relationship

The existing Active Directory home lab demonstrates on-premises identity and Windows administration concepts. This Azure project will compare those concepts with Microsoft Entra ID and Azure RBAC. Unless a separately documented hybrid connection is actually deployed and tested, the project must not be described as an integrated hybrid environment.

## Trust boundaries and design principles

- Separate management and workload network functions.
- Use least privilege for identities and role assignments.
- Restrict administrative network access; never expose RDP or SSH to all internet sources.
- Disable anonymous/public data access when it is not required.
- Prefer platform-native logging and security recommendations where cost-effective.
- Assess, remediate, and retest instead of merely collecting configuration screenshots.
- Keep paid services optional and subject to a cost check.

## Definitions

- **Trust boundary:** A point where access or data-flow rules change.
- **Workload:** An application or service running on infrastructure.
- **Segmentation:** Dividing a network into smaller zones to limit unnecessary communication.
- **Authentication:** Verifying an identity.
- **Authorization:** Determining what an authenticated identity may do.
- **Vulnerability assessment:** Identifying and evaluating security weaknesses.
- **Remediation:** Correcting or reducing an identified weakness.
- **Container image:** A packaged filesystem and configuration used to start a container.

## Status discipline

This architecture describes the intended design. It does not prove that a component is deployed. The deployment log and evidence files must record actual configuration and validation before any component is marked complete.