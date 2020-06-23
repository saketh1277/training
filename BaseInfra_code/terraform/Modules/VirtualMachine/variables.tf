variable "resource_group_name" {
  type        = list(string)
  description = "Specifies the name of the Resource Group in which the Virtual Machine should exist"
}
# - Linux VM's
# -

variable "subnet_ids" {
  type        = map(string)
  description = "Map of network interfaces subnets"
  default     = {}
}

variable "vm_additional_tags" {
  default = ""
}

variable "administrator_user_name" {
  type        = string
  description = "Specifies the name of the local administrator account"
}

variable "administrator_login_password" {
  type        = string
  description = "Specifies the password associated with the local administrator account"
}


# - Managed Disks
# -
variable "managed_data_disks" {
  type = map(object({
    disk_name                  = string
    vm_name                    = string
    lun                        = string
    storage_account_type       = string
    disk_size                  = number
    caching                    = string
    write_accelerator_enabled  = bool
    enable_cmk_disk_encryption = bool
  }))
  description = "Map containing storage data disk configurations"
  default     = {}
}

# -
# - Windows VM's
# -
variable "windows_vms" {
  type = object({
    count                            = number
    vm_prefix                        = string
    region                           = list(string)
    vm_resource_group_name           = string
    subnet_name                      = list(string)
    source_image_reference_offer     = string
    source_image_reference_publisher = string
    source_image_reference_sku       = string #(Mandatory)
    source_image_reference_version   = string #(Mandatory)
    vm_size                          = string #(Mandatory)
    managed_disk_type                = string #(Mandatory)
    internal_lb_iteration            = number
    assign_identity                  = bool
    storage_os_disk_caching          = string
    zones                            = string
    disk_size_gb                     = number
    write_accelerator_enabled        = bool
    disk_encryption_set_id           = string
    internal_dns_name_label          = string
    enable_ip_forwarding             = bool
    enable_accelerated_networking    = bool
    dns_servers                      = list(string)
    static_ip                        = string
    enable_cmk_disk_encryption       = bool
    count_data_disk = number
    data_disk_size = number
    data_disk_write_accelerator_enabled = bool
    data_disk_enable_cmk_disk_encryption = bool
    data_disk_type = string
  })
  description = "Map containing windows vm's"
}

variable "windows_image_id" {
  type        = string
  description = "Specifies the Id of the image which this Virtual Machine should be created from"
  default     = null
}