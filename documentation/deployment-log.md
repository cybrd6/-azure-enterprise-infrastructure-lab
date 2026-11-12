# Deployment Log

This file records what was actually configured and tested. Update entries after each portal action; do not mark a step complete until it has been validated.

## Day 1 — Foundation and network design

### Step 1: Resource group

- **Resource group:** `rg-contoso-cloud-lab`
- **Region:** Central US
- **Tags:** Environment=Lab; Project=EnterpriseCloud; Owner=CloudEngineering; ManagedBy=Jay
- **Result:** User confirmed the resource group was created and empty.

**Definition — Resource group:** A logical container used to organize and manage related Azure resources.

### Step 2: Virtual network and subnets

- **VNet name selected:** `vnet-contoso-prod`
- **Address space entered:** `10.10.0.0/16`
- **Application subnet entered in the portal:** `sn-app`, starting address `10.10.1.0`, size `/24`.
- **Management subnet:** `sn-mgmt`, `10.10.2.0/24`, planned but not yet confirmed created.
- **Last observed state:** The Azure portal screenshot showed the `sn-app` edit pane open. The “Enable private subnet (no default outbound access)” option was checked at that time. Final saved state is not yet confirmed.

**Definition — Virtual network:** An isolated private network in Azure.  
**Definition — Subnet:** A smaller IP range inside a virtual network.

### Validation still required

- [ ] Save the application subnet.
- [ ] Confirm the outbound-connectivity/private-subnet choice.
- [ ] Create and save the management subnet.
- [ ] Confirm both subnet ranges in the VNet.
- [ ] Record the final VNet deployment result.

