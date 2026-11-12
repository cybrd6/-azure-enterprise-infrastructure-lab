# Cloud Infrastructure Security Engineer I — Role Alignment Roadmap

## Purpose

This document maps the lab to the responsibilities in the target Cloud Infrastructure Security Engineer I posting. It is a learning and evidence plan, not a claim of professional production experience.

## Requirement-to-evidence map

| Role requirement | Project evidence planned or in progress | Current gap |
|---|---|---|
| Secure cloud environments | Azure network segmentation, hardened VM, identity, storage, and baseline review | VM hardening and most later controls remain |
| IAM | Entra ID, Azure RBAC, scope review, least-privilege access tests | Exercise pending |
| Vulnerability management | Trivy scan, Azure configuration review, risk register, remediation and retest | No completed scan/remediation evidence yet |
| Container security | Local Docker image scan, findings review, secure rebuild | Exercise pending |
| Cloud networking | VNet, two subnets, subnet-associated NSGs, exposure review and traffic tests | Base configuration exists; traffic validation pending |
| Storage security | Storage public-access, network, authorization, and encryption review | Exercise pending |
| On-premises systems | Existing Active Directory home lab and documented comparison to Entra ID | No integrated hybrid connection claimed |
| Compliance/security policies | Azure Policy or security recommendation review against a small control baseline | Assessment pending |
| Monitoring and investigation | Activity/diagnostic logs, Log Analytics, KQL investigation | Exercise pending |
| Infrastructure as Code | Terraform configuration and import of existing Azure resources | Planned; not yet started |

## Current Azure implementation

The following resources have been created and user-confirmed:

- Resource group: `rg-contoso-cloud-lab`, Central US.
- VNet: `vnet-contoso-prod`, address space `10.10.0.0/16`.
- Application subnet: `sn-app`, `10.10.1.0/24`.
- Management subnet: `sn-mgmt`, `10.10.2.0/24`.
- `nsg-app` associated with `sn-app`; `nsg-mgmt` associated with `sn-mgmt`.
- Windows Server 2025 VM: `vm-mgmt-01`, private IP observed as `10.10.2.4`, no public IP, no public inbound ports.
- VM power state at the end of the last session: stopped (deallocated).

The NSGs were reviewed and had only Azure default rules at that point. No custom traffic rules or successful traffic tests are claimed. The VM showed an Azure VM Agent readiness warning; outbound connectivity is unverified. These are open validation items, not completed controls.

## Next execution sequence

1. **Terraform adoption (Phase 3A):** install Terraform, authenticate with Azure CLI, inspect existing Azure resource IDs/configuration, write matching HCL, import existing resources, and review a read-only plan. Preserve all existing resources.
2. **Finish Phase 3:** investigate VM Agent readiness and outbound connectivity, establish secure administration, and validate patching/hardening.
3. **Phase 2 validation:** define minimum necessary NSG rules and test expected allowed/denied traffic.
4. Configure Entra ID and Azure RBAC; validate least privilege.
5. Add a Storage Account and harden access settings.
6. Configure limited logging and perform a small KQL investigation.
7. Perform vulnerability discovery and create a prioritized findings register.
8. Remediate selected findings and repeat the scan.
9. Complete a local Docker/Trivy container security exercise.
10. Review selected Azure settings against a security baseline, then finalize automation and publish evidence.

## Vulnerability register template

Use one row per observed finding. Do not enter example findings as if they were discovered in the lab.

| ID | Asset | Finding | Severity | Exposure/context | Remediation | Retest result | Status |
|---|---|---|---|---|---|---|---|
| VULN-001 | Example placeholder | Replace with an observed finding | TBD | Explain actual context | Record actual fix | Pending | Template only |

## Evidence standard

For each exercise, preserve:
- Objective and scope.
- Tool and version.
- Configuration or command used.
- Sanitized output or screenshot.
- Finding interpretation and risk rationale.
- Remediation performed.
- Retest result.
- Limitations and unresolved issues.

## Cloud platform breadth

Azure is the hands-on platform for this project. Add a short research-only comparison of equivalent IAM, network, storage, logging, and security posture services in AWS and GCP. Do not create paid AWS/GCP resources merely to claim multi-cloud experience. Clearly label this as conceptual comparison rather than hands-on experience.

## Completion criteria

The project is role-aligned when the repository contains validated evidence for IAM, network security, storage security, vulnerability discovery/remediation, container image assessment, monitoring/investigation, baseline review, and infrastructure-as-code adoption. A planned checklist or screenshot of a settings page alone is not sufficient evidence of security effectiveness.
