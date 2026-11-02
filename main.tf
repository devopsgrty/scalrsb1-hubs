#In-house Naming Module
module "naming" {
  source      = ".//modules/naming"
  company     = var.resource_name_company
  environment = var.resource_name_environment
  location    = var.location
  workload    = var.resource_name_workload
}

module "resource_group" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.0"
  location = var.location
  name     = module.naming.names.resource_group
  tags     = var.tags
}

# Simple Vnet
module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.22.2"

  parent_id     = module.resource_group.resource_id
  subnets       = local.subnets
  address_space = [var.address_space]
  location      = var.location
  name          = module.naming.names.virtual_network
  //diagnostic_settings = local.diagnostic_settings
  tags = var.tags
}

module "network_security_group" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.0"

  resource_group_name = module.resource_group.name
  name                = module.naming.names.network_security_group
  location            = var.location

  security_rules = {
    no_internet = {
      access                     = "Deny"
      direction                  = "Outbound"
      name                       = "block-internet-traffic"
      priority                   = 100
      protocol                   = "*"
      destination_address_prefix = "Internet"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  }

  /*diagnostic_settings = { for k, v in local.diagnostic_settings : k => {
    name                  = v.name
    workspace_resource_id = v.workspace_resource_id
    metric_categories     = []
    }
  }
  */
  tags = var.tags
}

#Doesn't create a resorce just here to trigger changes
resource "terraform_data" "null2" {
  provisioner "local-exec" {
    command = "echo Null Resource run"
  }
}
