# Architecture

## Purpose

Build a small, segmented Azure environment to demonstrate foundational cloud infrastructure, identity, monitoring, and security operations.

## Current design

The lab is organized inside one resource group:

- **Resource group:** `rg-contoso-cloud-lab`
- **Region:** Central US
- **Virtual network:** `vnet-contoso-prod` (lab resource)
- **Address space:** `10.10.0.0/16`

The planned network separates application workloads from administrative access:

- **Application subnet:** `sn-app` — `10.10.1.0/24`
- **Management subnet:** `sn-mgmt` — `10.10.2.0/24`

These are planned network roles; deployment and validation status is tracked in [network-design.md](network-design.md).

## Planned components

| Component | Purpose | Status |
|---|---|---|
| Resource group | Organize related lab resources | Created |
| Virtual network | Provide private network address space | Configuration in progress |
| Subnets | Separate workload and management traffic | In progress |
| Network security groups | Filter inbound and outbound traffic | Planned |
| Windows Server VM | Provide a manageable server workload | Planned |
| Entra ID and RBAC | Demonstrate cloud identity and authorization | Planned |
| Azure Monitor / Log Analytics | Collect and query operational data | Planned |

## How the pieces fit together

The VNet provides the network boundary. Subnets divide that network into smaller segments. NSGs apply traffic rules to network interfaces or subnets. A virtual machine will be placed into an appropriate subnet. Identity and RBAC govern who can manage Azure resources, while monitoring services provide operational visibility.

## Definitions

- **Architecture:** A high-level description of system components and how they relate.
- **Workload:** An application or service running on infrastructure.
- **Segmentation:** Dividing a network into smaller zones to limit unnecessary communication.
- **Authorization:** Deciding what an authenticated identity is allowed to do.

## Design principles

- Use private address space for the VNet.
- Separate application and management functions.
- Apply least privilege and narrowly scoped network rules.
- Avoid unnecessary paid services within the trial-credit constraint.
- Validate each deployment stage before moving forward.

