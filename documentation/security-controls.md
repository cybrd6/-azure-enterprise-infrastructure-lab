# Security Controls

## Security objectives

- Limit access to Azure resources using role-based permissions.
- Segment application and management network functions.
- Restrict inbound network access to only what the lab requires.
- Protect stored data against unintended public exposure.
- Collect logs that support troubleshooting and security investigation.
- Identify, prioritize, remediate, and retest vulnerabilities.
- Assess selected configurations against a documented security baseline.

## Control implementation and evidence plan

| Control area | Intended control | Validation evidence | Status |
|---|---|---|---|
| Resource organization | Resource group and consistent tags | Resource overview and tag review | Resource group created |
| Network segmentation | Separate workload and management subnets | VNet/subnet configuration | In progress |
| Network filtering | Minimal NSG allow rules and default-deny review | NSG rule export and connectivity tests | Planned |
| Administrative access | Restrict RDP/SSH to a narrow source or use supported non-public management | Inbound rule review | Planned |
| Identity | Entra ID identities and appropriate authentication settings | Identity configuration evidence | Planned |
| Authorization | Least-privilege Azure RBAC at the narrowest practical scope | Role assignment review and access test | Planned |
| Storage | Disable anonymous blob access; review network access, authorization, and encryption | Storage configuration review | Planned |
| Logging | Enable only relevant diagnostic sources and review activity logs | Log Analytics query results | Planned |
| Vulnerability management | Scan, triage, remediate, and rescan | Before/after findings record | Planned |
| Container security | Scan a local image and rebuild/update to address findings | Trivy reports before and after remediation | Planned |
| Baseline assessment | Evaluate selected settings against Azure Policy/security recommendations | Assessment matrix and findings | Planned |
| Secrets | Keep credentials out of source control and screenshots | Repository and evidence review | Ongoing requirement |

## Network rule principles

- Do not expose RDP (TCP 3389) or SSH (TCP 22) to the entire internet.
- Prefer a narrowly scoped administrative source when remote access is necessary.
- Use explicit, minimal allow rules and retain appropriate deny behavior.
- Review rule priority; lower numeric values are evaluated before higher values.
- Test expected allowed and denied paths.
- Remove temporary access rules when they are no longer required.

## Identity and access principles

- Use built-in roles where they meet the requirement; avoid custom roles unless the exercise requires one.
- Assign permissions at the smallest practical scope.
- Avoid using Owner or Contributor for routine tasks when a narrower role is sufficient.
- Record the principal, role, scope, reason, and validation result for each assignment.
- Test both an allowed action and an action that should be denied where practical.
- Do not create unnecessary privileged accounts or leave temporary permissions assigned.

## Storage principles

- Disable anonymous/public blob access unless a documented requirement justifies it.
- Prefer Microsoft Entra ID authorization and narrowly scoped data roles over shared keys where practical.
- Review storage firewall/network access settings.
- Confirm encryption at rest is enabled using the platform configuration.
- Do not upload real personal, financial, or confidential data to the lab.

## Vulnerability management principles

- Record the scanner, target, scan date, and scope.
- Distinguish confirmed findings from informational results and false positives.
- Prioritize using severity, exploitability, exposure, and asset importance—not severity alone.
- Remediate through updates, configuration changes, or removal of unnecessary components.
- Run a follow-up scan and record whether the finding was resolved, reduced, or remains open.
- Do not claim a system is vulnerability-free based on one scan.

## Logging and investigation principles

- Collect only the logs needed for the exercise to control cost and data volume.
- Use KQL queries that answer a specific investigation question.
- Record the time window, query, result, and interpretation.
- Treat absence of an event as inconclusive if the relevant data source was not enabled or ingested.

## Definitions

- **Security control:** A safeguard that reduces risk.
- **Least privilege:** Giving an identity only the permissions needed for its task.
- **RBAC:** Assigning permissions through roles at a defined scope.
- **Inbound traffic:** Network traffic entering a resource or network boundary.
- **Outbound traffic:** Network traffic leaving a resource or network boundary.
- **NSG:** Network security group; Azure rules that filter traffic by source, destination, protocol, port, and priority.
- **Scope:** The level at which a permission applies, such as a subscription, resource group, or individual resource.
- **Vulnerability:** A weakness that could be exploited to affect confidentiality, integrity, or availability.
- **False positive:** A reported finding that does not represent a valid issue in the assessed context.
- **Retest:** A follow-up check to determine whether remediation worked.
- **Baseline:** A documented minimum set of security settings used for comparison.

## Credential handling

Never store credentials, private keys, access tokens, connection strings, or secrets in this public repository. Use sanitized screenshots and example values only.