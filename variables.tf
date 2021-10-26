variable "tagEnvironment" {
  type        = string
  description = "the environment description"
  default     = "staging"
}

variable "spinExtra" {
  type        = bool
  description = "The Extra Environment to spin"
  default     = false
}

###################################################
# Environment Specs
###################################################
variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "dev"
}
variable "rg_name" {
  type        = string
  description = "The name of the resource group"
  default     = "MyResourceGroup"
}

###################################################
# Key Vault Components
###################################################

variable "key_vault_name" {
  type        = string
  description = "the name of the main key vault"
  default     = "mykeyvault"
}
variable "key_vault_resource_id" {
  type        = string
  description = "the resource id of the main key vault"
  default     = "/subscriptions/3d60da7d-bacf-4c0f-9333-16143cd9da70/resourceGroups/rgTerraformLabs/providers/Microsoft.KeyVault/vaults/srramkv123"
}
variable "admin_pw_name" {
  type        = string
  description = "the admin password of the vm"
  default     = "admin-pw"
}

###################################################
# Instance Specific
###################################################

variable "vm_name" {
  type        = string
  description = "the name to give the Virtual Machine"
  default     = "vm"
}


