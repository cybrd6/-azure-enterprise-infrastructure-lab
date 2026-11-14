variable "admin_password" {
  description = "Administrator password for the management VM"
  type        = string
  sensitive   = true
}

variable "operator_object_id" {
  description = "Microsoft Entra object ID of the lab operator who manages test Key Vault secrets"
  type        = string
}

variable "operator_public_ip" {
  description = "Public IPv4 address allowed to access the lab Key Vault and Storage account"
  type        = string
}

variable "alert_email" {
  description = "Email address that receives Azure Monitor lab alerts"
  type        = string
}
