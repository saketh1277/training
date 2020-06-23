data "azurerm_resource_group" "this" {
  count = length(var.resource_group_name)
  name = var.resource_group_name[count.index]
}

# -
# - Storage Account Data Source for diagnostic logs
# -
resource "azurerm_resource_group" "vm_rg" {
  count    = length(lookup(var.windows_vms, "region"))
  location = lookup(var.windows_vms, "region")[count.index]
  //  resource_group_name= lookup(var.windows_vms,"region") [count.index]
  name = format("%s0%d", lookup(var.windows_vms, "vm_resource_group_name"), count.index)
}



# - Windows Virtual Machine

##########VM_ID############

locals {
  vm_idss = [for y in azurerm_windows_virtual_machine.windows_vms : y.id]
  tags    = merge(var.vm_additional_tags, data.azurerm_resource_group.this.0.tags)
}

# -
# - Generate Private/Public SSH Key for Windows Virtual Machine
# -

#########################################################
# Windows VM Managed Disk and VM & Managed Disk Attachment
#########################################################
locals {
  windows_vm_ids = {
    for vm in azurerm_windows_virtual_machine.windows_vms :
    vm.name => vm.id
  }
}

# -
resource "azurerm_windows_virtual_machine" "windows_vms" {
  count               = lookup(var.windows_vms, "count")
  name                = format("%s00%d", lookup(var.windows_vms, "vm_prefix"), count.index)
  location            = lookup(var.windows_vms, "region")[count.index]
  resource_group_name = azurerm_resource_group.vm_rg[count.index].name

  network_interface_ids = [azurerm_network_interface.windows_nics[count.index].id]
  size                  = lookup(var.windows_vms, "vm_size", "Standard_F2")
  #zone                  = lookup(each.value, "zone", null)s

  admin_username = var.administrator_user_name
  admin_password = var.administrator_login_password

  # dynamic "admin_ssh_key" {
  #   for_each = lookup(each.value, "disable_password_authentication", true) == true ? [var.administrator_user_name] : []
  #   content {
  #     username   = var.administrator_user_name
  #     public_key = lookup(tls_private_key.this, each.key)["public_key_openssh"]
  #   }
  #}

  os_disk {
    name                      = format("%s00%d-osdisk", lookup(var.windows_vms, "vm_prefix"), count.index)
    caching                   = lookup(var.windows_vms, "storage_os_disk_caching", "ReadWrite")
    storage_account_type      = lookup(var.windows_vms, "managed_disk_type", "Standard_LRS")
    disk_size_gb              = lookup(var.windows_vms, "disk_size_gb", null)
    write_accelerator_enabled = lookup(var.windows_vms, "write_accelerator_enabled", null)
  }

  dynamic "source_image_reference" {
    for_each = var.windows_image_id == null ? (lookup(var.windows_vms, "source_image_reference_publisher", null) == null ? [] : [
    lookup(var.windows_vms, "source_image_reference_publisher", null)]) : []
    content {
      publisher = lookup(var.windows_vms, "source_image_reference_publisher", null)
      offer     = lookup(var.windows_vms, "source_image_reference_offer", null)
      sku       = lookup(var.windows_vms, "source_image_reference_sku", null)
      version   = lookup(var.windows_vms, "source_image_reference_version", null)
    }
  }
  computer_name   = format("%s00%d", lookup(var.windows_vms, "vm_prefix"), count.index)
  source_image_id = var.windows_image_id


  dynamic "identity" {
    for_each = lookup(var.windows_vms, "assign_identity", false) == false ? [] : list(lookup(var.windows_vms, "assign_identity", false))
    content {
      type = "SystemAssigned"
    }
  }

  tags = local.tags
}
# -
# - Windows Network Interfaces
# -
resource "azurerm_network_interface" "windows_nics" {
  count                         = lookup(var.windows_vms, "count")
  name                          = format("%s00%d-nic", lookup(var.windows_vms, "vm_prefix"), count.index)
  location                      = lookup(var.windows_vms, "region")[count.index]
  resource_group_name           = azurerm_resource_group.vm_rg[count.index].name
  internal_dns_name_label       = lookup(var.windows_vms, "internal_dns_name_label", null)
  enable_ip_forwarding          = lookup(var.windows_vms, "enable_ip_forwarding", null)
  enable_accelerated_networking = lookup(var.windows_vms, "enable_accelerated_networking", null)
  dns_servers                   = lookup(var.windows_vms, "dns_servers", null)

  ip_configuration {
    name                          = format("%s00%d-ip", lookup(var.windows_vms, "vm_prefix"), count.index)
    subnet_id                     = lookup(var.subnet_ids, lookup(var.windows_vms, "subnet_name")[count.index])
    private_ip_address_allocation = lookup(var.windows_vms, "static_ip", null) == null ? "dynamic" : "static"
    private_ip_address            = lookup(var.windows_vms, "static_ip", null)
  }

  tags = local.tags
}

resource "azurerm_managed_disk" "this_windows" {
  count               = lookup(var.windows_vms, "count_data_disk" )
  name                = format("%s00%d-datadisk",lookup(var.windows_vms,"vm_prefix"),count.index)
  location            = azurerm_resource_group.vm_rg[count.index].location
  resource_group_name = azurerm_resource_group.vm_rg[count.index].name

  #zones                  = list(lookup(local.linux_vm_zones, each.value["vm_name"], null))
  storage_account_type   = lookup(var.windows_vms, "data_disk_type", "Standard_LRS")
  disk_size_gb           = lookup(var.windows_vms, "data_disk_size", 1)
  create_option          = "Empty"
  os_type                = "Windows"
}

# - Windows VM - Managed Disk Attachment
resource "azurerm_virtual_machine_data_disk_attachment" "this_windows" {
  count                     = lookup(var.windows_vms,"count_data_disk" )
  managed_disk_id           = azurerm_managed_disk.this_windows[count.index].id
  virtual_machine_id        = azurerm_windows_virtual_machine.windows_vms[count.index].id
  lun                       = count.index
  caching                   = "ReadWrite"
  write_accelerator_enabled = lookup(var.windows_vms, "data_disk_write_accelerator_enabled", null)
}



