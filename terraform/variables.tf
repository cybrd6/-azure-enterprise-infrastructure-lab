variable "admin_password" {
  description = "Administrator password for the management VM"
  type        = string
  sensitive   = true
}

variable "operator_object_id" {
  description = "Microsoft Entra object ID of the lab operator who manages test Key Vault secrets"
  type        = string
}
