# Cloud Infrastructure Security Engineer I — Role Alignment Roadmap

## Purpose

This document maps the lab to the responsibilities in the target Cloud Infrastructure Security Engineer I posting. It is a learning and evidence plan, not a claim of professional production experience.

## Requirement-to-evidence map

| Role requirement | Planned project evidence | Current gap |
|---|---|---|
| Secure cloud environments | Hardened Azure network, VM, identity, storage, and baseline review | Most controls not yet deployed |
| IAM | Entra ID users/groups, Azure RBAC, scope review, access tests | Entra/RBAC exercise pending |
| Vulnerability management | Trivy scan, Azure configuration review, risk register, remediation and retest | No completed scan/remediation evidence yet |
| Container security | Local Docker image scan, findings review, secure rebuild | No container exercise yet |
| Cloud networking | VNet, subnets, NSGs, exposure and connectivity tests | Network build/validation pending |
| Storage security | Storage public-access, network, authorization, and encryption review | Storage exercise pending |
| On-premises systems | Existing Active Directory home lab and documented comparison to Entra ID | No integrated hybrid connection claimed |
| Compliance/security policies | Azure Policy or security recommendation review against a small control baseline | Assessment pending |
| Monitoring and investigation | Activity/diagnostic logs, Log Analytics, KQL investigation | Monitoring exercise pending |

## Execution order

1. Finish the VNet and subnet configuration already in progress.
2. Apply NSGs and validate permitted/blocked traffic.
3. Deploy the smallest practical Windows Server workload; secure administration and patch it.
4. Configure Entra ID and Azure RBAC; validate least privilege.
5. Add a Storage Account and harden access settings.
6. Configure limited logging and perform a small KQL investigation.
7. Perform vulnerability discovery and create a prioritized findings register.
8. Remediate selected findings and repeat the scan.
9. Complete a local Docker/Trivy container security exercise.
10. Review selected Azure settings against a security baseline, then automate and publish the evidence.

## Vulnerability register template

Use one row per finding. Do not include secrets or sensitive environment details.

| ID | Asset | Finding | Severity | Exposure/context | Remediation | Retest result | Status |
|---|---|---|---|---|---|---|---|
| VULN-001 | Example only | Replace with an observed finding | TBD | Explain actual context | Record actual fix | Pending | Open |

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

The project is role-aligned when the repository contains validated evidence for IAM, network security, storage security, vulnerability discovery/remediation, container image assessment, monitoring/investigation, and a documented baseline review. A planned checklist or screenshot of a settings page alone is not sufficient evidence of security effectiveness.