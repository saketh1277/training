
# -
# - Create Resource Group
# -
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# -
# - Virtual Network
# -
resource "azurerm_virtual_network" "this" {
  for_each = var.virtual_networks
  name = each.value["name"]
  location = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space = each.value["address_space"]
  dns_servers = lookup(each.value, "dns_servers", null)

}
# -
# - Subnet
# -
resource "azurerm_subnet" "this" {
  for_each                                       = var.subnets
  name                                           = each.value["name"]
  resource_group_name                            = azurerm_resource_group.this.name
  address_prefix                                 = each.value["address_prefix"]
  service_endpoints                              = lookup(each.value, "pe_enable", false) == false ? lookup(each.value, "service_endpoints", null) : null
  enforce_private_link_endpoint_network_policies = lookup(each.value, "pe_enable", false)
  enforce_private_link_service_network_policies  = lookup(each.value, "pe_enable", false)
  virtual_network_name                           = lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }

  depends_on = [azurerm_virtual_network.this]
}

# - Network Security Group
# -
resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups
  name                = "nsg${each.value["id"]}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", null)
    content {
      description                  = lookup(security_rule.value, "description", null)
      direction                    = lookup(security_rule.value, "direction", null)
      name                         = lookup(security_rule.value, "name", null)
      access                       = lookup(security_rule.value, "access", null)
      priority                     = lookup(security_rule.value, "priority", null)
      source_address_prefix        = contains(security_rule.value["source_address_prefixes"], "*") ? "*" : null
      source_address_prefixes      = contains(security_rule.value["source_address_prefixes"], "*") ? null : security_rule.value["source_address_prefixes"]
      destination_address_prefix   = contains(security_rule.value["destination_address_prefixes"], "*") ? "*" : null
      destination_address_prefixes = contains(security_rule.value["destination_address_prefixes"], "*") ? null : security_rule.value["destination_address_prefixes"]
      destination_port_range       = contains(security_rule.value["destination_port_ranges"], "*") ? "*" : null
      destination_port_ranges      = contains(security_rule.value["destination_port_ranges"], "*") ? null : security_rule.value["destination_port_ranges"]
      protocol                     = lookup(security_rule.value, "protocol", null)
      source_port_range            = contains(security_rule.value["source_port_ranges"], "*") ? "*" : null
      source_port_ranges           = contains(security_rule.value["source_port_ranges"], "*") ? null : security_rule.value["source_port_ranges"]
    }
  }

}
# - virtual_network_gateway
# -
resource "azurerm_public_ip" "pip" {
  for_each            = var.public_ip
  name                = each.value["pip_name"]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  allocation_method = each.value["pip_allocation_method"]
}

