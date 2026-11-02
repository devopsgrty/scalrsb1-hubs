/*output "resource_names" {
  description = "resource names"
  value       = local.resource_names
}
*/

output "resource_names" {
  description = "updateME"
  value = {
    resource_group = module.resource_group.name
    //log_analytics_workspace = module.log_analytics_workspace.name
    virtual_network        = module.virtual_network.name
    network_security_group = module.network_security_group.name
    //nat_gateway             = module.nat_gateway.name
    //nat_gateway_public_ip   = module.nat_gateway.public_ip_resource["default"].name
    storage_account = module.naming.names.storage_account
  }
}

output "resource_ids" {
  description = "ResourceIDs for, rg, vnet, nsg"
  value = {
    resource_group = module.resource_group.resource_id
    //log_analytics_workspace = module.log_analytics_workspace.resource_id
    virtual_network        = module.virtual_network.resource_id
    network_security_group = module.network_security_group.resource_id
    //nat_gateway             = module.nat_gateway.resource_id
    //nat_gateway_public_ip   = module.nat_gateway.public_ip_resource["default"].id
  }
}
/*
#Infoblox Vlans
output "infoblox_static" {
  description = "Show InfoBlox static IP block"
  value       = resource.infoblox_ipv4_network.static_net.cidr
}
output "infoblox_dynamic" {
  description = "Show InfoBlox dynamic IP block"
  value       = resource.infoblox_ipv4_network.dynamic_net.cidr
}


output "nameing_nodule_resource_names" {
  description = "Display Names for all resource types"
  value = {
    virtual_network         = module.naming.names.virtual_network
    subnet                  = module.naming.names.subnet
    network_security_group  = module.naming.names.network_security_group
    route_table             = module.naming.names.route_table
    public_ip               = module.naming.names.public_ip
    nat_gateway             = module.naming.names.nat_gateway
    network_interface       = module.naming.names.network_interface
    private_endpoint        = module.naming.names.private_endpoint
    user_assigned_identity  = module.naming.names.user_assigned_identity
    log_analytics_workspace = module.naming.names.log_analytics_workspace
    application_insights    = module.naming.names.application_insights
    app_service_plan        = module.naming.names.app_service_plan
    kubernetes_cluster      = module.naming.names.kubernetes_cluster
    managed_disk            = module.naming.names.managed_disk
    key_vault               = module.naming.names.key_vault
    web_app                 = module.naming.names.web_app
    function_app            = module.naming.names.function_app
    mssql_server            = module.naming.names.mssql_server
    storage_account         = module.naming.names.storage_account
    container_registry      = module.naming.names.container_registry
    virtaul_machine         = module.naming.names.virtaul_machine
    palo_alto               = module.naming.names.palo_alto
    zscaler_private         = module.naming.names.zscaler_private
    zscaler_cloudconnect    = module.naming.names.zscaler_cloudconnect
  }
}
*/