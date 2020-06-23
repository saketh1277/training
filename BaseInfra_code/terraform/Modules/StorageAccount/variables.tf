variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}

variable "sa_additional_tags" {
  type        = map(string)
  description = "Tags of the SA in addition to the resource group tag."
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "he ID of the Key Vault from which all Secrets should be sourced"
}

variable "subnet_ids" {
  description = "A map of subnet id's"
  type        = map(string)
}

variable "vnet_ids" {
  description = "A map of vnet id's"
  type        = map(string)
}

############################
# Storage Account
############################
variable "storage_accounts" {
  type = map(object({
    name            = string
    sku             = string
    account_kind    = string
    access_tier     = string
    assign_identity = bool
    cmk_enable      = bool
    network_rules = object({
      bypass                     = list(string) # (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.
      default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
      ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
      virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
    })
    sa_pe_is_manual_connection     = bool
    sa_pe_subnet_name              = string
    sa_pe_vnet_name                = string
    sa_pe_enabled_services         = list(string) # ["blob", "table", "queue"]
    sa_pe_dns_zone_name            = string
    sa_pe_zone_exists              = bool
    sa_pe_zone_to_vnet_link_exists = bool
  }))
  description = "Map of storage accouts which needs to be created in a resource group"
  default     = {}
}

############################
# Container
############################ 
variable "containers" {
  type = map(object({
    name                  = string
    storage_account_name  = string
    container_access_type = string
  }))
  description = "Map of Storage Containers"
  default     = {}
}

############################
# Bolb
############################ 
variable "blobs" {
  type = map(object({
    name                   = string
    storage_account_name   = string
    storage_container_name = string
    type                   = string
    size                   = number
    content_type           = string
    source_uri             = string
    metadata               = map(any)
  }))
  description = "Map of Storage Blobs"
  default     = {}
}

############################
# Queue
############################ 
variable "queues" {
  type = map(object({
    name                 = string
    storage_account_name = string
  }))
  description = "Map of Storages Queues"
  default     = {}
}

############################
# File Share
############################ 
variable "file_shares" {
  type = map(object({
    name                 = string
    storage_account_name = string
    quota                = number
  }))
  description = "Map of Storages File Shares"
  default     = {}
}

############################
# Table
############################ 
variable "tables" {
  type = map(object({
    name                 = string
    storage_account_name = string
  }))
  description = "Map of Storage Tables"
  default     = {}
}
