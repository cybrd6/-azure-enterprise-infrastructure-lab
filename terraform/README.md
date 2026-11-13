# Terraform — Azure Enterprise Infrastructure Lab

This directory contains the Terraform configuration for the existing Azure lab and the resources added during identity, secrets-management, and monitoring implementation.

## Files

- `main.tf` — resource group, network, NSGs, management VM, managed identity, RBAC assignments, Key Vault, deletion lock, Log Analytics workspace, and Key Vault diagnostic settings. Resources include short comments describing their purpose and security significance.
- `variables.tf` — sensitive `admin_password` input.
- `providers.tf` — AzureRM provider configuration; authentication uses the Azure CLI session.
- `versions.tf` — Terraform and AzureRM provider version constraints.

## Commands

Run from this directory in PowerShell:

```powershell
az login
az account show
terraform init
terraform fmt
terraform validate
terraform plan
```

Review the entire plan before applying. Do not proceed if Terraform proposes unexpected replacement or destruction.

## Secret and state handling

- Keep the actual `terraform.tfvars` local and out of Git.
- Never commit `terraform.tfstate`, state backups, `.terraform/`, saved plans, credentials, or access tokens.
- Terraform state is local at this stage and should be backed up securely.
- Do not publish unredacted subscription/tenant identifiers or passwords.

## Important implementation notes

- The VM's system-assigned managed identity has Reader at the resource-group scope and Key Vault Secrets User at the Key Vault scope.
- The lab operator's Entra user has Key Vault Secrets Officer scoped to the Key Vault for creating and managing test secrets.
- Key Vault uses RBAC, 7-day soft delete, purge protection, and a CanNotDelete management lock.
- Key Vault public network access is enabled at present. RBAC controls authorization, but network isolation has not been implemented.
- Key Vault diagnostic settings route AuditEvent logs and AllMetrics to Log Analytics. The workspace is deployed; successful ingestion/query validation is still pending.

## Current validation status

Terraform resources were applied successfully during the guided lab. Key Vault role assignments, deletion lock, workspace settings, and diagnostic-setting configuration were verified. A test secret was created and retrieved. The first Log Analytics query returned no audit records; ingestion delay or configuration still needs investigation.

Never run `terraform destroy` for this project. Preserve existing resources and inspect every plan before applying.
