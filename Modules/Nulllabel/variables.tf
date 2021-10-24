# Common for all clouds parameters
#

variable "name" {
  type        = string
  default     = "azurelandingzone"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "names" {
  type        = list(string)
  default     = ["tf12","tf24","tf36"]
  description = "Solution names, used to generate labels for multiple objects of the same nature (for_each use)"
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = "dev"
}

variable "stage" {
  type        = string
  default     = "source"
  description = "Stage, meaningfull addition to environment, eg. 'qa-1',  'source', 'build', 'test', 'deploy', 'release'"
}

variable "subscription_name" {
  type        = string
  default     = ""
  description = "Azure subscription name"
}

variable "subscription_name_short" {
  type        = string
  default     = ""
  description = "Shortened Azure subscription name or acronym"
}


variable "location" {
  type        = string
  default     = "southcentralus"
  description = "Location, cloud region or zone"
}

variable "cloud" {
  type        = string
  description = "Clound name or well-know acronym"
  default     = "Azure"
}

variable "cluster_name" {
  type        = string
  default     = "local"
  description = "Name of the cluster"
}

variable "suffixes" {
  type        = list(string)
  description = "List of suffixes to to generate IDs with"
  default     = ["srramnic1","srramds1"]
}


variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  default     = {}
}

variable "generate_tags" {
  type        = map(string)
  description = "Generate additional tags according to the map. Value is the tag name, tag value is the value of the key in context"
  default = {
    name         = "Name"
    environment  = "Environment"
    cluster_name = "ClusterName"
    stage        = "Stage"
  }
}

variable "key_vault_prefix" {
  type        = string
  description = "Prefix keyvault names with this"
  default     = "srramkv1-"
}

variable "storage_account_prefix" {
  type        = string
  description = "Prefix autogenerated storage account names with this"
  default     = "srramst1"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

# Separation and ordering
#

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used when generating names"
}

variable "label_order" {
  type        = list(string)
  description = "The naming order of the id output and Name tag"

  # this value must be the same as the one in deserialization.tf
  default = [
    "environment",
    "stage",
    "name",
    "attributes",
  ]
}

# Context
#
variable "context" {
  type        = string
  description = "A context to append to. Base64 encoded json is expected."
  default     = "eyJkZWxpbWl0ZXIiOiItIiwibmFtZXMiOlsiYSIsImIiLCJjIl0sInN1ZmZpeGVzIjpbImFiYyIsImRlZiIsImVmZyJdfQ==" # base64ecode(jsonencode({}))
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = "Additional tags for appending to each tag map"
}

variable "aux_domain" {
  type        = string
  default     = ""
  description = "Auxilary domain to generate domain names with"
}


variable "hostname_order" {
  type        = list(string)
  default     = []
  description = "order of labels to generate fqdn"
}

