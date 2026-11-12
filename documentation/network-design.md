# Network Design

## Objective

Create a virtual network with separate application and management subnets. Apply subnet-specific network security groups (NSGs) to establish distinct traffic-control boundaries.

## Address plan

| Network | CIDR range | Purpose | Status |
|---|---|---|---|
| VNet | `10.10.0.0/16` | Overall private address space | Created |
| `sn-app` | `10.10.1.0/24` | Application/workload resources | Created |
| `sn-mgmt` | `10.10.2.0/24` | Administrative/management resources | Created |

## Network security groups

| NSG | Associated subnet | Status |
|---|---|---|
| `nsg-app` | `sn-app` | Created and associated |
| `nsg-mgmt` | `sn-mgmt` | Created and associated |

The user confirmed that both NSGs are associated with their matching subnets. Custom security rules have not yet been added or tested.

## Configuration decisions

- **Region:** Central US, matching the lab resource group.
- **Address space:** `10.10.0.0/16`.
- **Subnet size:** `/24` for each subnet.
- **NAT Gateway:** None planned, to avoid adding a paid networking service to this small lab.
- **IPv6:** Not enabled for the initial build.
- **Administrative access:** Do not expose RDP (TCP 3389) or SSH (TCP 22) to all internet addresses.

## Definitions

- **IPv4:** Internet Protocol version 4; an addressing system using 32-bit addresses.
- **Private IP address:** An address used inside private networks rather than directly routed across the public internet.
- **CIDR:** Classless Inter-Domain Routing notation; the suffix such as `/16` indicates how many leading bits identify the network.
- **Address space:** The full IP range assigned to a network.
- **Subnet:** A smaller network range within the VNet.
- **`/16`:** A network prefix with 65,536 total IPv4 addresses.
- **`/24`:** A network prefix with 256 total IPv4 addresses; Azure reserves five addresses in each IPv4 subnet.
- **NAT Gateway:** A managed service that provides outbound internet connectivity using network address translation.
- **NSG:** Network Security Group; a stateful traffic filter that evaluates inbound and outbound rules for associated network interfaces or subnets.
- **Priority:** A rule-order value; lower numbers are evaluated before higher numbers.

## Validation checklist

- [x] Confirm VNet address space is `10.10.0.0/16`.
- [x] Create `sn-app` with `10.10.1.0/24`.
- [x] Create `sn-mgmt` with `10.10.2.0/24`.
- [x] Confirm both subnets exist in the VNet (user-confirmed).
- [x] Create `nsg-app` and associate it with `sn-app` (user-confirmed).
- [x] Create `nsg-mgmt` and associate it with `sn-mgmt` (user-confirmed).
- [ ] Review default and custom NSG rules.
- [ ] Validate intended traffic behavior after a workload is deployed.
- [ ] Capture sanitized screenshots of the VNet, subnet, and NSG association pages.

## Security and cost considerations

Subnet separation creates boundaries for applying different network rules, but subnets alone do not automatically provide complete isolation. NSG rules must be designed and tested against the workload's actual communication requirements.

No NAT Gateway is planned for this initial lab. Review Azure's current pricing and outbound-connectivity behavior before deploying workloads; do not assume every networking feature is free.
