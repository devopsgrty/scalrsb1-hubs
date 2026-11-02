# Azure naming module

Generates consistent Azure resource names from `company`, `environment` and `location` (plus an optional `workload`).

## Usage

```hcl
module "naming" {
  source      = "./modules/naming"
  company     = "contoso"
  environment = "prod"          # dev | test | uat | staging | prod | dr | sandbox
  location    = "Australia East" # or "australiaeast"
  workload    = "payments"      # optional but recommended
}

resource "azurerm_resource_group" "this" {
  name     = module.naming.names.resource_group
  location = module.naming.location
  tags     = module.naming.tags
}
```

## Name pattern

`<type>-<company>-<workload>-<env>-<region>` (e.g. `rg-contoso-payments-prd-aue`).
Names that must be globally unique (key vault, storage account, container registry, web/function app, SQL server) get a deterministic 4-character suffix.
Storage accounts and container registries have no hyphens.

## Notes
- If a name would exceed Azure's limit, the company/workload part is shortened; the type, environment, region and suffix are always kept.
- To add a resource type, add a line to `local.resource_types` in `locals.tf`. To add a region, add it to `local.location_short` and the validation list in `variables.tf`.
- Changing company, workload, environment or location changes the names (and the suffix), which forces resource replacement.
- The suffix reduces but cannot guarantee global uniqueness. Apply will fail if someone else already holds the name.
