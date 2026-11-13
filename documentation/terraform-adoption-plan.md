# Terraform Adoption — Completed

## Objective

Bring the Azure resources already created for this lab under Terraform management without rebuilding, replacing, or deleting them.

<badge>Complete</badge> The existing resources have been imported into local Terraform state, the configuration has been reconciled, and the final plan is clean.

## Environment

- **Resource group:** `rg-contoso-cloud-lab`
- **Region:** Central US
- **VNet:** `vnet-contoso-prod` — `10.10.0.0/16`
- **Application subnet:** `sn-app` — `10.10.1.0/24`
- **Management subnet:** `sn-mgmt` — `10.10.2.0/24`
- **NSGs:** `nsg-app` and `nsg-mgmt`, each associated with its matching subnet
- **Management NIC:** `vm-mgmt-01787`
- **VM:** `vm-mgmt-01` — Windows Server 2025 Datacenter: Azure Edition, `Standard_D2as_v7`
- **VM network placement:** `sn-mgmt`; no public IP and no public inbound ports
- **Last confirmed VM power state:** Stopped (deallocated)

## Workstation and provider

- Terraform CLI v1.17.2 on Windows AMD64.
- Azure CLI installed and authenticated to the intended Azure subscription.
- AzureRM provider source: `hashicorp/azurerm`.
- Provider version constraint: `~> 4.0`.
- Authentication uses the Azure CLI session; credentials are not embedded in provider configuration.

## Imported resources

| Azure resource | Terraform address | Status |
|---|---|---|
| Resource group | `azurerm_resource_group.contoso` | Imported |
| Virtual network | `azurerm_virtual_network.contoso` | Imported |
| Application subnet | `azurerm_subnet.app` | Imported |
| Management subnet | `azurerm_subnet.mgmt` | Imported |
| Application NSG | `azurerm_network_security_group.app` | Imported |
| Management NSG | `azurerm_network_security_group.mgmt` | Imported |
| Application subnet NSG association | `azurerm_subnet_network_security_group_association.app` | Imported |
| Management subnet NSG association | `azurerm_subnet_network_security_group_association.mgmt` | Imported |
| Management NIC | `azurerm_network_interface.mgmt` | Present in Terraform state |
| Windows management VM | `azurerm_windows_virtual_machine.mgmt` | Imported |

## Configuration and validation performed

- Created and maintained Terraform configuration in the local `terraform/` directory.
- Initialized the AzureRM provider with `terraform init`.
- Formatted configuration with `terraform fmt`.
- Declared the VM administrator password as a sensitive input variable in `variables.tf`.
- Stored the actual administrator password in local `terraform.tfvars`; the real file is excluded from Git.
- Ran `terraform validate` successfully.
- Imported the existing VM after the supporting network resources were tracked.
- Reconciled the VM configuration with the imported Azure resource, including reboot setting, additional capabilities, and boot diagnostics.
- Ran a final `terraform plan`.

### Final plan result

```text
Plan: 0 to add, 0 to change, 0 to destroy.
```

**No `terraform apply` was run.** This phase was an import and reconciliation exercise. Because the final plan contained no changes, an apply was unnecessary.

## State and secret protection

- Terraform state is local to the user's workstation at this stage.
- Treat state files and backups as sensitive; they can contain infrastructure metadata and secret values.
- The actual `terraform.tfvars` file must not be committed.
- The Terraform `.gitignore` excludes `.terraform/`, state files, saved plans, and real `.tfvars` files.
- Do not commit passwords, access tokens, private keys, state files, or unredacted subscription/tenant identifiers.
- No remote backend or additional Azure storage resource was created as part of this phase.

## Scope boundaries — not yet completed

A clean Terraform plan confirms that the declared resources match the imported infrastructure. It does **not** establish that the workload is fully secure or operational.

The following work remains for later phases:

- Design least-privilege inbound and outbound NSG rules.
- Validate allowed and denied traffic between subnets and to/from the VM.
- Investigate the previously observed Azure VM Agent readiness warning.
- Verify outbound connectivity and Windows Update behavior.
- Establish and test secure administrative access.
- Configure monitoring, logging, identity controls, and subsequent security assessments.

## Completion checklist

- [x] Terraform and Azure CLI installed and verified.
- [x] Azure CLI authenticated to the intended subscription.
- [x] Existing Azure resources inventoried.
- [x] Terraform configuration authored for existing resources.
- [x] Existing resources imported into Terraform state.
- [x] Sensitive password input kept out of version control.
- [x] `terraform fmt` completed.
- [x] `terraform validate` succeeded.
- [x] Final plan reviewed: 0 add, 0 change, 0 destroy.
- [x] No unintended apply, replacement, or destruction performed.

**Next section:** Network security hardening — design and test NSG rules for the application and management subnets.
