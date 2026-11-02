module "ip_addresses" {
  source                        = "Azure/avm-utl-network-ip-addresses/azurerm"
  version                       = "0.1.0"
  address_space                 = var.address_space
  address_prefixes              = { for key, value in local.subnet_info : key => value.size }
  address_prefix_efficient_mode = false
}