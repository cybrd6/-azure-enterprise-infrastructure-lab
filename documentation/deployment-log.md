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
- **Identity:** System-assigned managed identity and Microsoft Entra ID VM login left disabled during initial deployment; revisit when implementing IAM.
- **Tags:** Environment=Lab; Project=EnterpriseCloud; Owner=CloudEngineering; ManagedBy=Jay
- **Power state at end of session:** Stopped (deallocated), confirmed in Azure portal
- **Private IP observed:** `10.10.2.4`
- **Public IP observed:** None
- **Azure VM Agent:** Portal displayed “VM agent status is not ready” after deployment. Investigate after starting the VM; do not claim agent health is validated.
- **Outbound connectivity:** Not yet tested. No public IP or NAT Gateway was configured; verify the intended outbound connectivity method before Windows Update or agent-dependent operations.
- **Cost estimate shown during sizing:** Approximately USD $133.59/month for the selected VM size at continuous operation (portal estimate; not a statement of actual charges). Managed disk storage and any other billable resources may incur separate charges.

**Definitions — Trusted Launch:** Azure VM security features that support Secure Boot and a virtual TPM.  
**Definition — Accelerated networking:** A VM networking capability that reduces host processing overhead and can improve network performance.  
**Definition — Deallocated:** The VM has released its compute allocation; attached managed disks can continue to incur storage charges.

### Deployment validation

- [x] Confirm VM deployment completed and resource overview is accessible.
- [x] Confirm VM is stopped (deallocated) after deployment.
- [x] Confirm no public IP is assigned.
- [x] Confirm private IP `10.10.2.4` and selected VM size from the Azure portal overview.
- [x] Confirm the VM overview shows the expected resource group, region, subnet, and project tags.
- [ ] Start VM and investigate Azure VM Agent readiness warning.
- [ ] Establish and test secure administrative access without broad public exposure.
- [ ] Verify outbound connectivity and Windows Update behavior.
- [ ] Review Windows security baseline, patch state, and event logs.
- [ ] Review resource group and Cost Analysis for any unexpected billable resources; cost data may be delayed.
- [ ] Capture sanitized screenshots for portfolio evidence.

### Operational and cost notes

- The VM was manually stopped through Azure and the portal confirmed **Stopped (deallocated)**. This stops VM compute billing while deallocated; it does not stop managed disk storage billing or any charges from other separately billable resources.
- Auto-shutdown is configured for 2:00 AM Central Time as a fallback. Manual verification of the deallocated power state was performed; auto-shutdown itself was not tested.
- No public IP, public inbound ports, NAT Gateway, or load balancer was configured for this VM.
- Do not assume outbound internet connectivity is available. Validate the actual network behavior before relying on Windows Update or VM-agent-dependent actions.
- Do not treat a zero or incomplete Cost Analysis view immediately after deployment as proof of zero charges; Azure cost data can be delayed.


## Next-session checkpoint — Terraform adoption preparation

- **Decision:** Continue the existing Azure lab with Terraform rather than rebuilding the environment.
- **Repository preparation:** Added `documentation/terraform-adoption-plan.md` and updated the README and role-alignment roadmap.
- **Terraform status:** Not installed or initialized as part of this project yet. No Terraform state exists in the repository, and no Azure resources have been imported or modified by Terraform.
- **Next action:** Install/verify Terraform and Azure CLI on the workstation, authenticate to the intended Azure subscription, then inventory the live resource IDs and configuration.
- **Preservation requirement:** Import the existing resource group, VNet, subnets, NSGs, and VM-related resources into Terraform only after matching configuration has been authored. Do not recreate resources.
- **Safety gate:** Run and inspect `terraform plan`; do not apply any plan that proposes unexpected replacement, deletion, or disruptive changes.
- **VM state:** Last confirmed stopped (deallocated). Keep it deallocated while preparing Terraform unless a later validation task requires it.
