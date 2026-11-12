# Network Design

## Objective

Create a virtual network with separate application and management subnets. This provides a foundation for controlled communication and later security testing.

## Address plan

| Network | CIDR range | Purpose | Status |
|---|---|---|---|
| VNet | `10.10.0.0/16` | Overall private address space | Entered in portal |
| `sn-app` | `10.10.1.0/24` | Application/workload resources | Shown in portal; verify after save |
| `sn-mgmt` | `10.10.2.0/24` | Administrative/management resources | Planned |

## Configuration decisions

- **Region:** Central US, matching the lab resource group.
- **Address space:** `10.10.0.0/16`.
- **Subnet size:** `/24` for each planned subnet.
- **NAT Gateway:** None planned, to avoid adding a paid networking service to this small lab.
- **IPv6:** Not enabled for the initial build.

## Definitions

- **IPv4:** Internet Protocol version 4; an addressing system using 32-bit addresses.
- **Private IP address:** An address used inside private networks rather than directly routed across the public internet.
- **CIDR:** Classless Inter-Domain Routing notation; the suffix such as `/16` indicates how many leading bits identify the network.
- **Address space:** The full IP range assigned to a network.
- **Subnet:** A smaller network range within the VNet.
- **`/16`:** A network prefix with 65,536 total IPv4 addresses.
- **`/24`:** A network prefix with 256 total IPv4 addresses; Azure reserves five addresses in each IPv4 subnet.
- **NAT Gateway:** A managed service that provides outbound internet connectivity using network address translation.

## Validation checklist

- [ ] Confirm VNet address space is `10.10.0.0/16`.
- [ ] Save `sn-app` with `10.10.1.0/24`.
- [ ] Create `sn-mgmt` with `10.10.2.0/24`.
- [ ] Confirm both subnets appear in the VNet overview.
- [ ] Record the final private-subnet and outbound-connectivity setting.
- [ ] Capture a sanitized screenshot of the address-space page.

## Security and cost considerations

Subnet separation creates boundaries for applying different network rules, but subnets alone do not automatically provide complete isolation. Network security groups will be configured in a later stage.

No NAT Gateway is planned for this initial lab. Review Azure's current pricing and outbound-connectivity behavior before deploying workloads; do not assume that every networking feature is free.

