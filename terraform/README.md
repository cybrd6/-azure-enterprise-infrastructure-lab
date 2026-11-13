# Terraform — Existing Azure Infrastructure

This directory contains the Terraform configuration used to adopt the existing Azure lab resources without recreating them.

## Current status

**Terraform adoption complete.** The user imported the existing resource group, VNet, subnets, NSGs, subnet-to-NSG associations, management NIC, and Windows Server VM into local Terraform state. The final `terraform validate` succeeded and the final plan reported:

```text
Plan: 0 to add, 0 to change, 0 to destroy.
```

No `terraform apply` was run because the goal was to reconcile existing infrastructure, not make changes.

## Files

- `versions.tf` — Terraform and AzureRM provider version constraints.
- `providers.tf` — AzureRM provider configuration; authentication uses the Azure CLI session.
- `main.tf` — existing Azure resources represented in Terraform.
- `variables.tf` — sensitive administrator password input declaration.
- `terraform.tfvars.example` — safe template; copy to local `terraform.tfvars` and replace the placeholder.
- `.gitignore` — excludes local state, provider cache, saved plans, and real variable files.

## Local setup

From this directory in PowerShell:

```powershell
az login
az account show
terraform init
terraform fmt
terraform validate
terraform plan
```

The Azure CLI must be authenticated to the intended subscription before running Terraform operations.

## Secret and state handling

- The actual administrator password belongs only in the local `terraform.tfvars`.
- Never commit `terraform.tfvars`, state files, state backups, `.terraform/`, saved plans, credentials, or access tokens.
- Terraform state is local at this stage and should be backed up securely.
- Do not commit subscription or tenant identifiers unnecessarily.

## Safety

A Terraform plan must be reviewed before any apply. Import and plan are not deployment. Do not run `terraform apply` unless a deliberate infrastructure change is intended and its full plan has been reviewed. Never use `terraform destroy` for this lab's adoption workflow.

## Next phase

Network security hardening: design least-privilege NSG rules for the application and management subnets, then test allowed and denied traffic. Do not claim this work is complete until the rules and tests are actually performed.
