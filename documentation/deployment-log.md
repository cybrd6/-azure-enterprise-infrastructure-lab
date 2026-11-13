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

## Day 3 — Terraform adoption preparation and initial import

### Workstation setup

- **Terraform CLI:** v1.17.2 on Windows AMD64; version command succeeded.
- **Azure CLI:** Installed through Windows Package Manager (winget); CLI command verified using its installed `az.cmd` path. The CLI directory was added to the current PowerShell PATH and then to the user's persistent PATH.
- **Authentication:** `az login` completed successfully. The user has one Azure subscription and selected the default subscription.
- **Subscription verification:** `az account show` confirmed the selected subscription was correct and enabled. Subscription identifiers are intentionally not recorded here.
- **Resource inventory:** `az resource list` returned the expected resources in `rg-contoso-cloud-lab`. Resource group location and tags were inspected.
- **Resource group ID:** Retrieved directly from Azure CLI; the full subscription-specific ID is intentionally not stored in this public log.

### Local Terraform configuration

Inside the repository's local `terraform/` directory:

- `versions.tf` — declares Terraform minimum version and AzureRM provider source/version constraint (`hashicorp/azurerm`, `~> 4.0`).
- `providers.tf` — configures the AzureRM provider with its required `features {}` block; authentication uses the Azure CLI session.
- `main.tf` — declares `azurerm_resource_group.contoso` for the existing `rg-contoso-cloud-lab` resource in Central US.
- **Initialization:** `terraform init` succeeded and downloaded/initialized the AzureRM provider.
- **Formatting:** `terraform fmt` succeeded.
- **Validation:** `terraform validate` succeeded with a valid configuration result.

### Resource group import — successful

The following import command was initiated:

```powershell
terraform import azurerm_resource_group.contoso "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/rg-contoso-cloud-lab"
```

- **Target Terraform address:** `azurerm_resource_group.contoso`.
- **Target Azure resource:** Existing `rg-contoso-cloud-lab`.
- **Status:** Import completed successfully. The user confirmed `terraform state list` returned `azurerm_resource_group.contoso`.
- **Infrastructure changes:** No `terraform apply` has been run. Import is intended to read/adopt the existing resource into Terraform state; do not describe it as a deployment.
- **Next action:** Inspect the imported resource with `terraform state show`, then run a read-only `terraform plan` to compare configuration with Azure.

### State and repository safety

- Terraform state is local at this stage and may contain sensitive infrastructure metadata.
- Do not commit `terraform.tfstate`, backup state, `.terraform/`, saved plan files, credentials, or real secret-bearing variable files.
- Add and verify a Terraform-specific `.gitignore` before committing local Terraform work.
- No remote backend or additional Azure storage resource has been created.
- Keep the VM deallocated while adoption work continues.


## Day 4 — Terraform import and reconciliation completed

### Existing Azure resources adopted into Terraform

The Terraform configuration was expanded to represent the existing Azure infrastructure, and each resource was imported into the matching Terraform address. The following resources are now tracked in local Terraform state:

| Azure resource | Terraform address | Result |
|---|---|---|
| Resource group `rg-contoso-cloud-lab` | `azurerm_resource_group.contoso` | Imported |
| VNet `vnet-contoso-prod` | `azurerm_virtual_network.contoso` | Imported |
| Subnet `sn-app` | `azurerm_subnet.app` | Imported |
| Subnet `sn-mgmt` | `azurerm_subnet.mgmt` | Imported |
| NSG `nsg-app` | `azurerm_network_security_group.app` | Imported |
| NSG `nsg-mgmt` | `azurerm_network_security_group.mgmt` | Imported |
| App subnet / NSG association | `azurerm_subnet_network_security_group_association.app` | Imported |
| Management subnet / NSG association | `azurerm_subnet_network_security_group_association.mgmt` | Imported |
| Management NIC `vm-mgmt-01787` | `azurerm_network_interface.mgmt` | Already present in Terraform state; retained |
| VM `vm-mgmt-01` | `azurerm_windows_virtual_machine.mgmt` | Imported |

### Configuration and validation

- **Terraform CLI:** v1.17.2 on Windows AMD64.
- **AzureRM provider:** `hashicorp/azurerm`, version constraint `~> 4.0`.
- **Authentication:** Azure CLI session; no credentials or subscription identifiers are recorded in this log.
- **VM administrator input:** `admin_password` is declared as a sensitive Terraform variable in `variables.tf`. The actual password is held in the local `terraform.tfvars` file and must not be committed.
- **Validation:** `terraform validate` succeeded after adding the variable declaration.
- **Reconciliation:** The initial VM plans exposed configuration drift for reboot setting, additional capabilities, and boot diagnostics. The configuration was updated to match the existing VM.
- **Final plan:** Terraform reported **0 to add, 0 to change, 0 to destroy**.
- **Apply:** No `terraform apply` was run or needed. The purpose of this phase was to import and reconcile existing infrastructure, not modify or recreate it.
- **VM power state:** The VM was deallocated after the password reset workflow; keep it deallocated when not actively required.

### Terraform state and secret handling

- The successful import and clean plan were performed against local Terraform state on the user's workstation.
- The actual `terraform.tfvars` file contains the administrator password and must remain local.
- The Terraform-specific `.gitignore` excludes `.terraform/`, state files, saved plans, and real `.tfvars` files while allowing example variable files.
- Do not publish the state file, backup state, real `.tfvars`, passwords, access tokens, or unredacted subscription/tenant identifiers.
- A clean plan is evidence that the current HCL matches the imported resources; it does not prove network traffic, guest OS health, VM agent readiness, or administrative access have been tested.

### Terraform adoption completion checklist

- [x] Terraform CLI installed and verified.
- [x] Azure CLI authenticated to the intended subscription.
- [x] Existing resource inventory completed.
- [x] Terraform configuration authored for the existing resources.
- [x] Existing resources imported into Terraform state.
- [x] Sensitive administrator password kept outside version-controlled configuration.
- [x] `terraform validate` succeeded.
- [x] Final `terraform plan` returned 0 add, 0 change, 0 destroy.
- [x] No unnecessary apply or resource recreation performed.
- [ ] Verify that local Terraform state is backed up securely before any workstation changes.
- [ ] Continue with NSG custom-rule design and network traffic validation.

**Phase result: Complete.** Terraform now tracks the existing lab infrastructure. The next project section is network security hardening: design least-privilege NSG rules, then validate allowed and denied traffic. Do not describe custom NSG hardening or traffic validation as complete yet.
