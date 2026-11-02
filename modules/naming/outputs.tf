output "names" {
  description = "Map of resource type => generated name, e.g. module.naming.names.resource_group."
  value       = local.names
}

output "location" {
  description = "Normalised Azure region (e.g. australiaeast), safe to pass to resources."
  value       = local.location_normalised
}

output "location_short" {
  description = "Short region code (e.g. aue)."
  value       = local.loc_code
}

output "environment_short" {
  description = "Short environment code (e.g. prd)."
  value       = local.env_code
}

output "tags" {
  description = "Baseline tags to merge into your resources (empty values are omitted)."
  value = {
    for k, v in {
      company     = var.company
      environment = var.environment
      workload    = var.workload
    } : k => v if v != ""
  }
}
