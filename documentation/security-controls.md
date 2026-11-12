# Security Controls

## Security objectives

- Limit access to Azure resources using role-based permissions.
- Segment application and management network functions.
- Restrict inbound network access to only what the lab requires.
- Avoid exposing remote administration ports broadly to the internet.
- Collect logs that can support troubleshooting and security investigation.

## Planned controls

| Control | Intended use | Status |
|---|---|---|
| Resource-group organization | Keep lab resources grouped and manageable | Created |
| Subnet separation | Separate workload and management traffic | In progress |
| Network security groups | Allow or deny traffic using explicit rules | Planned |
| Least-privilege RBAC | Grant only required Azure permissions | Planned |
| Monitoring and logs | Support operational review and investigations | Planned |

## Definitions

- **Security control:** A safeguard that reduces risk.
- **Least privilege:** Giving an identity only the permissions needed to perform its task.
- **RBAC (role-based access control):** Assigning permissions through roles at a defined scope.
- **Inbound traffic:** Network traffic entering a resource or network boundary.
- **Outbound traffic:** Network traffic leaving a resource or network boundary.
- **NSG (network security group):** Azure network rules that filter traffic by attributes such as source, destination, protocol, port, and priority.
- **Scope:** The level at which a permission applies, such as a subscription, resource group, or individual resource.

## Planned network rule principles

- Do not expose RDP (TCP 3389) or SSH (TCP 22) to the entire internet.
- Prefer a narrowly scoped administrative source when remote access is necessary.
- Use explicit, minimal allow rules and retain appropriate deny behavior.
- Review rule priority; lower numeric values are evaluated before higher values.
- Remove temporary access rules when they are no longer required.

## Credential handling

Never store credentials, private keys, access tokens, or secrets in this public repository. Use sanitized screenshots and example values only.

