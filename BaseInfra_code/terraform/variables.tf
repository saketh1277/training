# back-end state variables

variable "storage_account_name" {
  type        = string
  description = "storage account name that will hold the Terraform state files"
  default     = ""
}

variable "container_name" {
  type        = string
  description = "storage container name for the Terraform state files"
  default     = ""
}

variable "vm_additional_tags" {
  default = ""
}
variable "managed_data_disks_east" {
  type = map(object({
    disk_name                  = string
    vm_name                    = string
    lun                        = string
    storage_account_type       = string
    disk_encryption_set_id     = string
    disk_size                  = number
    caching                    = string
    write_accelerator_enabled  = bool
    enable_cmk_disk_encryption = bool
  }))
  description = "Map containing storage data disk configurations"
  default     = {}
}

variable "windows_image_id" {
  type        = string
  description = "The ID of an Image which each Virtual Machine in this Scale Set should be based on."
  default     = null
}

variable "windows_vms_West" {
  type = map(object({
    name                             = string
    vm_size                          = string
    zones                            = string
    assign_identity                  = bool
    subnet_name                      = string
    internal_lb_iteration            = number
    source_image_reference_publisher = string
    source_image_reference_offer     = string
    source_image_reference_sku       = string
    source_image_reference_version   = string
    storage_os_disk_caching          = string
    managed_disk_type                = string
    disk_size_gb                     = number
    write_accelerator_enabled        = bool
    disk_encryption_set_id           = string
    internal_dns_name_label          = string
    enable_ip_forwarding             = bool
    enable_accelerated_networking    = bool
    dns_servers                      = list(string)
    static_ip                        = string
    enable_cmk_disk_encryption       = bool
  }))
  description = "Map containing windows vm's"
  default     = {}
}

variable "managed_data_disks_west" {
  type = map(object({
    disk_name                  = string
    vm_name                    = string
    lun                        = string
    storage_account_type       = string
    disk_encryption_set_id     = string
    disk_size                  = number
    caching                    = string
    write_accelerator_enabled  = bool
    enable_cmk_disk_encryption = bool
  }))
  description = "Map containing storage data disk configurations"
  default     = {}
}

variable "admin_user_name" {
  default = "unset"
}

variable "administrator_login_password" {
  default = "attdefault@123"
}

variable "admin_user_name_west" {
  default = "unset"
}

variable "administrator_login_password_west" {
  default = "attdefault@123"
}

# this is the default resource group variable used by azure rm backend
variable "resource_group_name" {
  type        = string
  description = "the resource group name for the azrm backend storage account"
  default     = ""
}

variable "region_east" {
  type        = string
  description = "the default azure region"
  default     = ""
}

# Azure Resource Manager Provider Creds
variable "client_id" {
  type        = string
  description = "app id used by terraform"
  default     = ""
}

variable "client_secret" {
  type        = string
  description = "app secret used by terraform"
  default     = ""
}

variable "tenant_id" {
  type        = string
  description = "azure tenant id"
  default     = ""
}

variable "subscription_id" {
  type        = string
  description = "azure subscription id"
  default     = ""
}

variable "base_rg_name_east" {
  type        = string
  description = "the resource group name for the base infra"
  default     = "windowsSharedService-baseeast-rg"
}

# Networking

variable "virtual_networks_east" {
  type    = any
  default = {}
}

variable "subnets_east" {
  type    = any
  default = {}
}

variable "network_security_groups_east" {
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


variable "public_ip" {
  description = "The public_ip with their properties needed for gateway."
  type        = any
  default     = {}
}


# back-end state variables
variable "storage_account_name_west" {
  type        = string
  description = "storage account name that will hold the Terraform state files"
  default     = ""
}

variable "container_name_west" {
  type        = string
  description = "storage container name for the Terraform state files"
  default     = ""
}

# this is the default resource group variable used by azure rm backend
variable "resource_group_name_west" {
  type        = string
  description = "the resource group name for the azrm backend storage account"
  default     = ""
}

variable "region_west" {
  type        = string
  description = "the default azure region"
  default     = ""
}

# General

variable "base_rg_name_west" {
  type        = string
  description = "the resource group name for the base infra"
  default     = "windowssharedservice-basewest-rg"
}



# Networking

variable "virtual_networks_west" {
  type    = any
  default = {}
}

variable "subnets_west" {
  type    = any
  default = {}
}

variable "network_security_groups_west" {
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


variable "public_ip_west" {
  description = "The public_ip with their properties needed for gateway."
  type        = any
  default     = {}
}

variable "sccm" {
  type = any
}