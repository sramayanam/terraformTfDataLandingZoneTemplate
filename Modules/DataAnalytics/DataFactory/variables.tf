variable "location" {
    description = "Azure region from https://azure.microsoft.com/en-us/global-infrastructure/geographies/#geographies"
    type = string
    default = "centralus"
}

variable "resource_group_name" {
    description = "Azure Resource Group"
    type = string
}

variable "storage_account" {
  description = "name of the storage account to be used"
  type        = string
}

variable "managed_virtual_network_enabled" {
  description = "managed vnet for synapse"
  type        = bool
  default     = false
}

variable "principalname" {
  description = "Service Principal"
  type        = string
}

variable "adfname" {
  description = "adfname"
  type        = string
}

variable "tags" {
    description = "Key - Value Map of tags to associate with created resources."
    type = map
}