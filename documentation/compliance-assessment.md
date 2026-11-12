# Cloud Security Baseline Assessment

## Objective

Review a small set of Azure configuration controls against a documented baseline and record evidence, gaps, and remediation. This is a learning assessment, not a formal compliance certification or audit.

## Assessment method

1. Choose a control and explain the risk it addresses.
2. Identify the Azure resource and configuration location.
3. Inspect the actual setting using the portal, Azure Policy, or another appropriate tool.
4. Record the observed result and evidence.
5. Mark the control Pass, Fail, Not Assessed, or Not Applicable.
6. For a failure, document remediation and repeat the check.

## Initial control matrix

| ID | Control objective | Evidence to collect | Result |
|---|---|---|---|
| NET-01 | Administrative ports are not exposed to all internet sources | NSG inbound rules | Not Assessed |
| NET-02 | Workload and management functions are segmented | VNet/subnet and NSG configuration | Not Assessed |
| IAM-01 | Azure role assignments use least privilege | Role, principal, and scope review | Not Assessed |
| IAM-02 | Unnecessary privileged assignments are absent | Subscription/resource-group role review | Not Assessed |
| STO-01 | Anonymous blob access is disabled | Storage Account and container access settings | Not Assessed |
| STO-02 | Storage network access is appropriately restricted | Storage networking configuration | Not Assessed |
| STO-03 | Encryption at rest is enabled | Storage encryption configuration | Not Assessed |
| LOG-01 | Relevant activity/diagnostic logging is available | Diagnostic settings and sample query | Not Assessed |
| VM-01 | Windows Server is patched for the exercise | Update history or patch evidence | Not Assessed |
| SEC-01 | Security findings are tracked through retest | Vulnerability register | Not Assessed |

## Azure Policy and security recommendations

Use available Azure Policy and Microsoft Defender for Cloud recommendations to inspect relevant configurations where possible. Check the plan, feature, and pricing before enabling any paid capability. Prefer audit/read-only assessment effects for this lab; do not apply broad deny policies that could block later learning steps.

## Reporting format

For each control, record:
- Control ID and objective.
- Resource assessed.
- Tool or portal location.
- Actual observed setting.
- Result and evidence link.
- Risk or impact if failed.
- Remediation owner/action (for this individual lab, the owner is the learner).
- Retest result and date.

## Definitions

- **Security baseline:** A documented minimum set of security expectations.
- **Compliance assessment:** A structured check of whether selected controls meet stated requirements.
- **Azure Policy:** A service that evaluates and can enforce rules for Azure resources.
- **Audit effect:** A policy effect that reports non-compliance without blocking deployment.
- **Control evidence:** A record that supports the conclusion about whether a control is implemented.
- **Not Assessed:** No reliable check has yet been performed; it does not mean the control passed.

## Limitations

This exercise covers a deliberately small set of controls in a personal lab. It does not establish compliance with SOC 2, ISO 27001, NIST, or any other framework. Do not claim certification or organizational compliance based on this project.