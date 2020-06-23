# Base Infrastructure tfvars examples
Base Infrastructure will create the standard resources required for all applications.
This includes one or many:
- Virtual networks
- Subnets
- Private endpoints

One of:
- Resource Group
- KeyVault used for storing of application secrets.  If multiple KeyVaults are required, they can be deployed as part of the application kit.  This can either be used for specific application requirements or a separate can KeyVault can be deployed.
- Storage Account used for diagnostics.  If multiple Storage Accounts are required, they can be deployed as part of the application kit.  This can either be used for specific application requirements or a separate Storage Account can be deployed
- Private link Service.  The application's PLS for connectivity to the bastion vnet
- Log Analytics Workspace.  The workspace ID is used for other modules to reference as a mandatory parameter for sending diagnostic information

## Virtual Network(s)
`
virtual_networks = {
  virtualnetwork1 = {
    id            = "1"
    vnetname        = "jstart5949"
    address_space = ["10.0.128.0/24", "198.18.2.0/24"] # Optional multiple address spaces
    dns_servers = ["8.8.8.8"]                          # Optional
  }
}
`
## Subnet(s)
`
subnets = {
  snet1 = {
    vnet_key          = "vnet1"                                                           #(Mandatory) 
    name              = "demo1"                                                           #(Mandatory) 
    address_prefix    = "10.0.128.0/28"                                                   #(Mandatory) 
    service_endpoints = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.AzureCosmosDB"] #(Optional) delete this line for no Service Endpoints
    nsg_key           = "nsg1"                                                            #(Optional) delete this line for no NSG
    rt_key            = "rt2"                                                             #(Optional) delete this line for no Route Table
  },
  snet2 = {
    vnet_key       = "vnet1"          #(Mandatory) 
    name           = "demo2"          #(Mandatory) 
    address_prefix = "10.0.128.16/28" #(Mandatory) 
    pe_enable      = true             #(Optional) Private endpoint enabled
    nsg_key        = "nsg1"           #(Optional) delete this line for no NSG
    rt_key         = "rt2"            #(Optional) delete this line for no Route Table
  },
  snet3 = {
    vnet_key          = "vnet1"                                                           #(Mandatory) 
    name              = "AppSrvSM"                                                        #(Mandatory) 
    address_prefix    = "198.18.2.0/24"                                                   #(Mandatory) 
    service_endpoints = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.AzureCosmosDB"] #(Optional) delete this line for no Service Endpoints
  }
}
`

## Route table(s) (Optional)
`
route_tables = {
  rt1 = {
    id     = "1"
    routes = []
  }
  rt2 = {
    id = "2"
    routes = [
      {
        name           = "route1"
        address_prefix = "10.1.0.0/16"
        next_hop_type  = "vnetlocal"
      },
    ]
  }
}
`

## Network Security Group(s) (Optional)
`
network_security_groups = {
  nsg1 = {
    id = "1"
    security_rules = [
      {
        name                       = "test1"
        description                = "My Test 1"
        priority                   = 101
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                         = "test2"
        description                  = "My Test 2"
        priority                     = 102
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        destination_port_range       = "*"
        source_address_prefix        = "*"
        destination_address_prefixes = ["192.168.1.5", "192.168.1.6"]
      },
      {
        name                         = "test3"
        description                  = "My Test 3"
        priority                     = 103
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        destination_port_ranges      = ["22", "3389"]
        source_address_prefix        = "*"
        destination_address_prefixes = ["192.168.1.5", "192.168.1.6"]
      },
    ]
  }
}
`

## Log Analytics Workspace for Base Infrastructure only
`
sku                     = "PerGB2018"
retention_in_days       = 30
log_analytics_workspace = null
`
## Storage Account for Base Infrastructure only
`
container_name = ["container1", "container2"]
`
## Key Vault for Base Infrastructure Only
`
network_acls = {
  bypass                     = "AzureServices"
  default_action             = "allow"
  ip_rules                   = ["0.0.0.0/0"]
  virtual_network_subnet_ids = []
}
`
## Private Endpoint(s)
`
private_endpoints = {
  pe1 = {
    id                       = "1"
    type              = "pe"
    subnet_iteration         = "0"
    approval_required        = "no"
    resource_type            = "blob"
    dnszonename              = "blob.core.windows.net"
    zone_exists              = false
    zone_to_vnet_link_exists = false
  }
    pe2 = {
    id                       = "2"
    type              = "pe"
    subnet_iteration         = "0"
    approval_required        = "no"
    resource_type            = "sqlserver"
    dnszonename              = "privatelink.database.windows.net"
    zone_exists              = false
    zone_to_vnet_link_exists = false
  }
}
`