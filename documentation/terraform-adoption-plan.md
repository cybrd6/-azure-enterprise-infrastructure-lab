# Terraform Adoption Plan — Existing Azure Infrastructure

## Objective

Bring the Azure resources already created for this lab under Terraform management **without rebuilding, replacing, or deleting them**. This is a safe-adoption exercise, not a fresh deployment.

**Current status:** Planned. Terraform has not yet been installed, initialized, imported, or applied in this project.

## Existing environment to preserve

- Subscription: use the currently selected Azure trial subscription; do not publish its ID.
- Resource group: `rg-contoso-cloud-lab`.
- Region: Central US.
- VNet: `vnet-contoso-prod`, address space `10.10.0.0/16`.
- Subnets: `sn-app` (`10.10.1.0/24`) and `sn-mgmt` (`10.10.2.0/24`).
- NSGs: `nsg-app` associated with `sn-app`; `nsg-mgmt` associated with `sn-mgmt`.
- VM: `vm-mgmt-01`, Windows Server 2025 Datacenter: Azure Edition, `Standard_D2as_v7`, private IP observed as `10.10.2.4`, no public IP, no public inbound ports.
- VM was last confirmed **Stopped (deallocated)**. Keep it deallocated unless a specific validation task requires it.

The exact Azure resource IDs and full configuration must be read from the live subscription before writing import declarations. Do not guess resource IDs, VM/NIC/disk relationships, or provider attributes.

## Planned local project layout

```text
terraform/
├── README.md
├── providers.tf
├── versions.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars.example
└── .gitignore
```

The exact files and module structure may change as the resource configuration is inspected.

## Adoption workflow

### 1. Prepare the workstation

- Install a current stable Terraform CLI and Azure CLI.
- Verify both tools from PowerShell.
- Sign in using `az login`.
- Confirm the active subscription with `az account show`; if needed, select the intended subscription explicitly.
- Never paste access tokens, credentials, or unredacted subscription/tenant details into GitHub or chat.

**Definitions:** Terraform CLI is the command-line tool that reads configuration and manages state. Azure CLI is Microsoft's command-line interface for inspecting and managing Azure resources.

### 2. Inventory the live resources

Use Azure CLI read commands to inspect resource IDs and configuration, including the resource group, VNet, subnets, NSGs, VM, network interface, and OS disk. Capture only the properties required to accurately represent the resources in Terraform.

Read-only inventory examples:

```powershell
az account show --query "{name:name, state:state}" -o table
az resource list --resource-group rg-contoso-cloud-lab --query "[].{name:name,type:type,id:id}" -o table
az vm show --resource-group rg-contoso-cloud-lab --name vm-mgmt-01 -o json
az network vnet show --resource-group rg-contoso-cloud-lab --name vnet-contoso-prod -o json
az network nsg list --resource-group rg-contoso-cloud-lab -o table
```

These commands inspect configuration; they do not deploy or modify resources. Review output locally and redact sensitive identifiers before sharing.

### 3. Write configuration before importing

- Configure the AzureRM provider and pin a tested provider version.
- Define Terraform resource blocks that accurately represent the existing resources.
- Include dependencies and properties such as tags, address spaces, subnet ranges, NSG associations, VM image/size, NIC, OS disk, security profile, patch settings, identity state, and boot diagnostics where applicable.
- Use variables for reusable, non-secret values.
- Do not assume importing a resource automatically generates complete Terraform configuration. Import records the resource in state; matching HCL still needs to be authored and reconciled.

### 4. Protect Terraform state

- Start with local state for this small lab unless there is a clear reason to use a remote backend.
- Treat state as sensitive: it may contain infrastructure details and secret values.
- Never commit `terraform.tfstate`, `terraform.tfstate.backup`, `.terraform/`, saved plan files, credentials, or real `.tfvars` files.
- Commit only reviewed HCL, safe example variable files, and documentation.
- Back up state securely. Do not add a remote backend or extra Azure storage resource without checking its cost and need.

### 5. Import existing resources

- Use each resource's exact Azure resource ID from the inventory.
- Ensure a matching Terraform resource block exists for each import.
- Import resources individually or through carefully reviewed import blocks.
- Include the VM's related NIC and OS disk resources only after understanding how the AzureRM provider models the VM and its dependencies.
- Keep the VM deallocated during configuration and import unless a read-only inspection requires otherwise.

### 6. Reconcile and plan

Run `terraform fmt`, `terraform validate`, and `terraform plan`. Review every proposed change.

**Stop condition:** Do not apply a plan that proposes an unexpected destroy, replacement, recreation, or disruptive modification. In particular, any plan showing `-/+` or resource destruction must be investigated before proceeding. A clean or understood no-change plan is the desired initial adoption milestone.

### 7. Apply only after explicit review

Import and plan are not the same as deployment. Do not run `terraform apply` simply to make the plan disappear. Apply only a fully reviewed, understood plan when a deliberate change is intended. Never use `terraform destroy` for this adoption exercise.

## Security and cost guardrails

- Terraform import and plan are not intended to recreate the Azure resources.
- Do not create Bastion, NAT Gateway, VPN Gateway, AKS, or a remote state storage account just to complete this exercise.
- Keep the VM deallocated when idle; disk storage may continue to incur charges.
- Never commit state, credentials, private keys, tokens, or real secret-bearing variable files.
- Do not make public RDP/SSH exposure part of the Terraform configuration.
- Confirm the Azure subscription context before any command that can change resources.

## Completion criteria

- [ ] Terraform and Azure CLI installed and version-checked.
- [ ] Azure CLI authenticated to the intended trial subscription.
- [ ] Existing Azure resource IDs and relevant properties inventoried.
- [ ] Terraform configuration authored to match existing infrastructure.
- [ ] Existing resources imported without recreation.
- [ ] State protected from Git and stored/backed up safely.
- [ ] `terraform fmt` and `terraform validate` pass.
- [ ] `terraform plan` reviewed with no unintended replacement or destruction.
- [ ] Documentation records the commands, results, limitations, and sanitized evidence.

Do not mark this phase complete until the import and plan have actually been validated.
