# East Region
# backed-end storage account
resource_group_name  = "sccmtestrg78"
storage_account_name = "testrgdiag99"
container_name       = "ravitest"
region_east          = "eastus2"
base_rg_name_east    = "wss-eastus2-prod-infra-rg012"


# virtual machine

windows_vms_east = {
  vm1 = {
    type                             = "VMWSSEAST" #(Mandatory) suffix of the vm
    name                             = "VMWSSEAST" #(Mandatory) name of the vm
    id                               = "1"         #(Mandatory) Id of the VM
    location                         = "eastus2"
    source_image_reference_offer     = "WindowsServer"                 #(Mandatory)
    source_image_reference_publisher = "MicrosoftWindowsServer"        #(Mandatory)
    source_image_reference_sku       = "2012-R2-Datacenter"            #(Mandatory)
    source_image_reference_version   = "Latest"                        #(Mandatory)
    subnet_name                      = "djoin-eastus2-prod-infra-snet" #(Mandatory) Id of the Subnet
    vm_size                          = "Standard_DS1_v2"               #(Mandatory)
    managed_disk_type                = "Premium_LRS"                   #(Mandatory)
    internal_lb_iteration            = "0"
    assign_identity                  = true
    storage_os_disk_caching          = "ReadWrite"
    zones                            = "1"
    disk_size_gb                     = null
    write_accelerator_enabled        = null
    disk_encryption_set_id           = null
    internal_dns_name_label          = null
    enable_ip_forwarding             = null
    enable_accelerated_networking    = null
    dns_servers                      = null
    static_ip                        = null
    enable_cmk_disk_encryption       = false
  }
}

sccm = {
  count                            = 2
  region                           = ["eastus2", "westus2"]
  vm_prefix                        = "WSS-VM"
  vm_resource_group_name           = "VM-RG"
  subnet_name                      = ["djoin-eastus2-prod-infra-snet", "djoin-westus2-prod-infra-snet"]
  source_image_reference_offer     = "WindowsServer"          #(Mandatory)
  source_image_reference_publisher = "MicrosoftWindowsServer" #(Mandatory)
  source_image_reference_sku       = "2012-R2-Datacenter"     #(Mandatory)
  source_image_reference_version   = "Latest"                 #(Mandatory)
  vm_size                          = "Standard_DS1_v2"        #(Mandatory)
  managed_disk_type                = "Premium_LRS"            #(Mandatory)
  internal_lb_iteration            = "0"
  assign_identity                  = true
  storage_os_disk_caching          = "ReadWrite"
  zones                            = "1"
  disk_size_gb                     = null
  write_accelerator_enabled        = null
  disk_encryption_set_id           = null
  internal_dns_name_label          = null
  enable_ip_forwarding             = null
  enable_accelerated_networking    = null
  dns_servers                      = null
  static_ip                        = null
  enable_cmk_disk_encryption       = false
  count_data_disk = 2
  data_disk_size = 1
  data_disk_write_accelerator_enabled = null
  data_disk_enable_cmk_disk_encryption = false
  data_disk_type = "Standard_LRS"
}

windows_vms_West = {
  vm2 = {
    type                             = "VMWSSWEST"                     #(Mandatory) suffix of the vm
    name                             = "VMWSSWEST"                     #(Mandatory) name of the vm
    id                               = "2"                             #(Mandatory) Id of the VM
    source_image_reference_offer     = "WindowsServer"                 #(Mandatory)
    source_image_reference_publisher = "MicrosoftWindowsServer"        #(Mandatory)
    source_image_reference_sku       = "2012-R2-Datacenter"            #(Mandatory)
    source_image_reference_version   = "Latest"                        #(Mandatory)
    subnet_name                      = "djoin-westus2-prod-infra-snet" #(Mandatory) Id of the Subnet
    vm_size                          = "Standard_DS1_v2"               #(Mandatory)
    managed_disk_type                = "Premium_LRS"                   #(Mandatory)
    internal_lb_iteration            = "0"
    assign_identity                  = true
    storage_os_disk_caching          = "ReadWrite"
    zones                            = "1"
    disk_size_gb                     = null
    write_accelerator_enabled        = null
    disk_encryption_set_id           = null
    internal_dns_name_label          = null
    enable_ip_forwarding             = null
    enable_accelerated_networking    = null
    dns_servers                      = null
    static_ip                        = null
    enable_cmk_disk_encryption       = false
  }
}



managed_data_disks_east = {
  disk1 = {
    disk_name                  = "Disk01"
    vm_name                    = "VMWSSEAST"
    lun                        = "0"
    storage_account_type       = "Standard_LRS"
    disk_encryption_set_id     = null
    disk_size                  = 1
    caching                    = "ReadWrite"
    write_accelerator_enabled  = null
    enable_cmk_disk_encryption = false
  }
}


# Base Infra
virtual_networks_east = {
  wss-eastus2-prod-infra-vnet = {
    name              = "wss-eastus2-prod-infra-vnet"
    address_space     = ["135.170.44.0/24", "135.170.45.0/26", "172.29.34.0/25"]
    private_dns_zones = []
    dns_servers       = null
  }
}

subnets_east = {
  dc-eastus2-prod-inra-snet = {
    vnet_key          = "wss-eastus2-prod-infra-vnet" #(Mandatory)
    name              = "dc-eastus2-prod-infra-snet"  #(Mandatory)
    address_prefix    = "135.170.44.0/28"             #(Mandatory)
    nsg_key           = "network_security1"
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  sccm-eastus2-prod-infra-snet = {
    vnet_key          = "wss-eastus2-prod-infra-vnet"  #(Mandatory)
    name              = "sccm-eastus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.44.16/28"             #(Mandatory)
    nsg_key           = "network_security1"
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  scom-eastus2-prod-infra-snet = {
    vnet_key          = "wss-eastus2-prod-infra-vnet"  #(Mandatory)
    name              = "scom-eastus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.44.32/28"             #(Mandatory)
    nsg_key           = "network_security1"
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  djoin-eastus2-prod-infra-snet = {
    vnet_key          = "wss-eastus2-prod-infra-vnet"   #(Mandatory)
    name              = "djoin-eastus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.44.64/29"              #(Mandatory)
    nsg_key           = null
    rt_key            = null
    pe_enable         = false
    service_endpoints = ["Microsoft.KeyVault"]
    delegation        = []
  },
  GatewaySubnet = {
    vnet_key          = "wss-eastus2-prod-infra-vnet" #(Mandatory)
    name              = "GatewaySubnet"               #(Mandatory)
    address_prefix    = "172.29.34.64/27"             #(Mandatory)
    nsg_key           = null
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  PrivateLink = {
    vnet_key          = "wss-eastus2-prod-infra-vnet" #(Mandatory)
    name              = "privateLink"                 #(Mandatory)
    address_prefix    = "172.29.34.0/26"              #(Mandatory)
    pe_enable         = true
    nsg_key           = null
    rt_key            = null
    service_endpoints = null
    delegation        = []
  },
  ATZAE-DC = {
    vnet_key          = "wss-eastus2-prod-infra-vnet"      #(Mandatory)
    name              = "atzae-dc-eastus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.45.0/27"                  #(Mandatory)
    nsg_key           = null
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  ATZAE-PAW = {
    vnet_key          = "wss-eastus2-prod-infra-vnet"       #(Mandatory)
    name              = "atzae-paw-eastus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.45.32/27"                  #(Mandatory)
    pe_enable         = false
    nsg_key           = null
    rt_key            = null
    service_endpoints = null
    delegation        = []
  }
}
  base_infra_storage_accounts = {
    sa1 = {
      name = "wsstfstatesa2east011"
      sku = "Standard_LRS"
      account_kind = null
      access_tier = null
      assign_identity = true
      cmk_enable = true
      network_rules = null
      sa_pe_is_manual_connection = false
      sa_pe_subnet_name = "privateLink"
      sa_pe_vnet_name = "wss-eastus2-prod-infra-vnet"
      sa_pe_enabled_services = [
        "blob"]
      sa_pe_dns_zone_name = null
      sa_pe_zone_exists = true
      sa_pe_zone_to_vnet_link_exists = true
    }
  }

  public_ip = {
    pip_vnet_gateway = {
      pip_name = "pip_vnet_gateway"
      #(Mandatory)
      pip_allocation_method = "Dynamic"
      #(Mandatory)
    }
  }

  #  West Region

  # backed-end storage account
  region_west = "westus2"
  base_rg_name_west = "wss-westus2-prod-infra-rg0011"

  location_west = "westus2"

  # Base Infra
  virtual_networks_west = {
    wss-westus2-prod-infra-vnet = {
      name = "wss-westus2-prod-infra-vnet"
      address_space = [
        "135.170.48.0/24",
        "135.170.49.0/26",
        "172.29.35.0/25"]
      private_dns_zones = []
      dns_servers = null
    }
  }




  //managed_data_disks_west = {
  //  disk1 = {
  //    disk_name                  = "Disk01"
  //    vm_name                    = "VMWSSWEST"
  //    lun                        = "0"
  //    storage_account_type       = "Standard_LRS"
  //    disk_encryption_set_id     = null
  //    disk_size                  = 1
  //    caching                    = "ReadWrite"
  //    write_accelerator_enabled  = null
  //    enable_cmk_disk_encryption = false
  //  }
  //}
subnets_west = {
  dc-westus2-prod-inra-snet = {
    vnet_key          = "wss-westus2-prod-infra-vnet" #(Mandatory)
    name              = "dc-westus2-prod-infra-snet"  #(Mandatory)
    address_prefix    = "135.170.48.0/28"             #(Mandatory)
    nsg_key           = "network_security1"
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  sccm-westus2-prod-infra-snet = {
    vnet_key          = "wss-westus2-prod-infra-vnet"  #(Mandatory)
    name              = "sccm-westus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.48.16/28"             #(Mandatory)
    nsg_key           = "network_security1"
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  scom-westus2-prod-infra-snet = {
    vnet_key          = "wss-westus2-prod-infra-vnet"  #(Mandatory)
    name              = "scom-westus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.48.32/27"             #(Mandatory)
    nsg_key           = "network_security1"
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  djoin-westus2-prod-infra-snet = {
    vnet_key          = "wss-westus2-prod-infra-vnet"   #(Mandatory)
    name              = "djoin-westus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.48.64/29"              #(Mandatory)
    nsg_key           = null
    rt_key            = null
    pe_enable         = false
    service_endpoints = ["Microsoft.KeyVault"]
    delegation        = []
  },
  GatewaySubnet = {
    vnet_key          = "wss-westus2-prod-infra-vnet" #(Mandatory)
    name              = "GatewaySubnet"               #(Mandatory)
    address_prefix    = "172.29.35.64/27"             #(Mandatory)
    nsg_key           = null
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  PrivateLink = {
    vnet_key          = "wss-westus2-prod-infra-vnet" #(Mandatory)
    name              = "privateLink"                 #(Mandatory)
    address_prefix    = "172.29.35.0/26"              #(Mandatory)
    pe_enable         = true
    nsg_key           = null
    rt_key            = null
    service_endpoints = null
    delegation        = []
  },
  ATZAE-DC = {
    vnet_key          = "wss-westus2-prod-infra-vnet"      #(Mandatory)
    name              = "atzae-dc-westus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.49.0/27"                  #(Mandatory)
    nsg_key           = null
    rt_key            = null
    pe_enable         = false
    service_endpoints = null
    delegation        = []
  },
  ATZAE-PAW = {
    vnet_key          = "wss-westus2-prod-infra-vnet"       #(Mandatory)
    name              = "atzae-paw-westus2-prod-infra-snet" #(Mandatory)
    address_prefix    = "135.170.49.32/27"                  #(Mandatory)
    pe_enable         = false
    nsg_key           = null
    rt_key            = null
    service_endpoints = null
    delegation        = []
  }
}

    base_infra_storage_accounts_west = {
      sa1 = {
        name = "basewssinfrasa2west0010"
        sku = "Standard_LRS"
        account_kind = null
        access_tier = null
        assign_identity = true
        cmk_enable = true
        network_rules = null
        sa_pe_is_manual_connection = false
        sa_pe_subnet_name = "privateLink"
        sa_pe_vnet_name = "wss-westus2-prod-infra-vnet"
        sa_pe_enabled_services = [
          "blob"]
        sa_pe_dns_zone_name = null
        sa_pe_zone_exists = true
        sa_pe_zone_to_vnet_link_exists = true
      }
    }

    public_ip_west = {
      pip_vnet_gateway = {
        pip_name = "pip_vnet_gateway"
        #(Mandatory)
        pip_allocation_method = "Dynamic"
        #(Mandatory)
      }


    }

