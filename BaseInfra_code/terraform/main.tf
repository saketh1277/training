
module "BaseInfrastructure" {
  source              = "./Modules/BaseInfrastructure"
  resource_group_name = var.base_rg_name_east
  location            = var.region_east
  #net_prefix              = "windowssharedservics"
  virtual_networks        = var.virtual_networks_east
  subnets                 = var.subnets_east
  network_security_groups = var.network_security_groups_east
  public_ip               = var.public_ip

}
module "BaseInfrastructurewest" {
  source              = "./Modules/BaseInfrastructure"
  resource_group_name = var.base_rg_name_west
  location            = var.region_west
  #net_prefix              = "windowssharedservics"
  virtual_networks        = var.virtual_networks_west
  subnets                 = var.subnets_west
  network_security_groups = var.network_security_groups_west
  public_ip               = var.public_ip_west

}

module "sccm" {
  source                       = "./Modules/VirtualMachine"
  resource_group_name          = [module.BaseInfrastructure.resource_group_name, module.BaseInfrastructurewest.resource_group_name]
  windows_vms                  = var.sccm
  windows_image_id             = var.windows_image_id
  administrator_user_name      = var.admin_user_name
  administrator_login_password = var.administrator_login_password
  subnet_ids                   = merge(module.BaseInfrastructure.map_subnet_ids, module.BaseInfrastructurewest.map_subnet_ids)
  managed_data_disks           = var.managed_data_disks_east
}
