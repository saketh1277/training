# -
# - Core object
# -
variable "resource_group_name" {
  type        = string
  description = "The Name which should be used for this Resource Group."
}

variable "location" {
  type        = string
  description = "The Azure Region used for resources such as: key-vault, storage-account, log-analytics and resource group."
}

# - Virtual Network object
# -
  variable "virtual_networks" {
  description = "The virtal networks with their properties."
  type = map(object({
    name          = string
    address_space = list(string)
    dns_servers   = list(string)
  }))
  default = {}
}
# - Subnet object
# -
variable "subnets" {
  description = "The virtal networks subnets with their properties."
  type = map(object({
    name              = string
    vnet_key          = string
    nsg_key           = string
    rt_key            = string
    address_prefix    = string
    pe_enable         = bool
    service_endpoints = list(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  default = {}
}

# - Network Security Group object
# -
variable "network_security_groups" {
  description = "The network security groups with their properties."
  type = map(object({
    id = string
    security_rules = list(object({
      name                         = string
      description                  = string
      direction                    = string
      access                       = string
      priority                     = string
      source_address_prefixes      = list(string)
      destination_address_prefixes = list(string)
      destination_port_ranges      = list(string)
      protocol                     = string
      source_port_ranges           = list(string)
    }))
  }))
  default = {}
}

# - Storage Account
# -
variable "base_infra_storage_accounts" {
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
  description = "Map of Sorage Accounts that will be created as part of Base Infrastructure"
  default     = {}
}

variable "containers" {
  type = map(object({
    name                  = string
    storage_account_name  = string
    container_access_type = string
  }))
  description = "Map of Storage Containers"
  default     = {}
}

variable "public_ip" {
  description = "The public_ip with their properties needed for gateway."
  type        = any
  default     = {}
}

