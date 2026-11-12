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

- **VNet:** `vnet-contoso-prod`
- **Address space:** `10.10.0.0/16`
- **Application subnet:** `sn-app`, `10.10.1.0/24`.
- **Management subnet:** `sn-mgmt`, `10.10.2.0/24`.
- **Result:** User confirmed both subnets are created.

**Definition — Virtual network:** An isolated private network in Azure.  
**Definition — Subnet:** A smaller IP range inside a virtual network.

### Step 3: Network security groups

- **Application NSG:** `nsg-app`, associated with `sn-app`.
- **Management NSG:** `nsg-mgmt`, associated with `sn-mgmt`.
- **Result:** User confirmed both NSGs are associated with their matching subnets.
- **Custom rules:** Not yet configured or tested.
- **Administrative access:** No public RDP/SSH allow rule has been intentionally added.

**Definition — Network Security Group (NSG):** A stateful Azure traffic filter that allows or denies network traffic using prioritized rules.

### Phase 2 validation still required

- [x] Create both subnets with the planned address ranges (user-confirmed).
- [x] Create and associate both NSGs with the matching subnets (user-confirmed).
- [ ] Review default NSG rules and confirm no unsafe custom inbound rules exist.
- [ ] Design only the minimum required traffic rules for the workload.
- [ ] Test intended and denied traffic after workload deployment.
- [ ] Capture sanitized screenshots for portfolio evidence.

