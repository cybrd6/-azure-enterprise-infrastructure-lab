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
- [x] Review both NSGs; user confirmed only Azure default rules were present and no custom rules had been added.
- [ ] Design only the minimum required traffic rules for the workload.
- [ ] Test intended and denied traffic after workload deployment.
- [ ] Capture sanitized screenshots for portfolio evidence.

## Day 2 — Windows Server workload deployment

### Step 4: Windows Server 2025 virtual machine

- **VM:** `vm-mgmt-01`
- **Resource group:** `rg-contoso-cloud-lab`
- **Region:** Central US
- **Image:** Windows Server 2025 Datacenter: Azure Edition
- **Size:** `Standard_D2as_v7` — 2 vCPUs, 8 GiB RAM
- **OS disk:** Standard SSD
- **Security:** Trusted Launch; Secure Boot and vTPM enabled
- **Network:** `vnet-contoso-prod` / `sn-mgmt` (`10.10.2.0/24`)
- **Network security:** Existing `nsg-mgmt` associated with the management subnet and selected for the VM NIC
- **Public IP:** None
- **Public inbound ports:** None
- **Accelerated networking:** Enabled (required by selected VM size)
- **Load balancing:** None
- **Auto-shutdown:** Enabled for 2:00 AM Central Time
- **Guest updates:** Hotpatch enabled; Azure-orchestrated patching; reboot if required
- **Monitoring:** Recommended alert rules disabled; optional monitoring services deferred for the planned monitoring phase
- **Tags:** Environment=Lab; Project=EnterpriseCloud; Owner=CloudEngineering; ManagedBy=Jay
- **Power state at end of session:** Stopped (deallocated), confirmed in Azure portal
- **Private IP observed:** `10.10.2.4`
- **Public IP observed:** None
- **Azure VM Agent:** Portal displayed “VM agent status is not ready” after deployment. Investigate after starting the VM; do not claim agent health is validated.
- **Outbound connectivity:** Not yet tested. No public IP or NAT Gateway was configured; verify the intended outbound connectivity method before Windows Update or agent-dependent operations.

**Definitions — Trusted Launch:** Azure VM security features that support Secure Boot and a virtual TPM.  
**Definition — Accelerated networking:** A VM networking capability that reduces host processing overhead and can improve network performance.  
**Definition — Deallocated:** The VM has released its compute allocation; attached managed disks can continue to incur storage charges.

### Deployment validation still required

- [x] Confirm VM deployment completed and resource overview is accessible.
- [x] Confirm VM is stopped (deallocated) after deployment.
- [x] Confirm no public IP is assigned.
- [ ] Start VM and investigate Azure VM Agent readiness warning.
- [ ] Establish and test secure administrative access without broad public exposure.
- [ ] Verify outbound connectivity and Windows Update behavior.
- [ ] Review Windows security baseline, patch state, and event logs.
- [ ] Capture sanitized screenshots for portfolio evidence.

