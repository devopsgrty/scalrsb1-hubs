# Define Subnet Name and Sizes
locals {
  subnet_info = {
    Pa-Mgmt = {
      size                       = 28
      has_nat_gateway            = false
      has_network_security_group = false
    }
    Stunet2 = {
      size                       = 28
      has_nat_gateway            = false
      has_network_security_group = true
    }
    Subnet3 = {
      size                       = 24
      has_nat_gateway            = true
      has_network_security_group = false
    }
  }
}


# Calculate the CIDR for the subnets
locals {
  subnets = { for key, value in local.subnet_info : key => {
    name             = key
    address_prefixes = [module.ip_addresses.address_prefixes[key]]
    network_security_group = value.has_network_security_group ? {
      id = module.network_security_group.resource_id
    } : null
    //nat_gateway = value.has_nat_gateway ? {
    //  id = module.nat_gateway.resource_id
    //} : null
    }
  }
}
