terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

/*
module "naming" {
  source = "../../modules/naming"

  company     = "contoso"
  environment = "prod"
  location    = "Australia East"
  workload    = "payments"
}

resource "azurerm_resource_group" "this" {
  name     = module.naming.names.resource_group     # rg-contoso-payments-prd-aue
  location = module.naming.location
  tags     = module.naming.tags
}

resource "azurerm_storage_account" "this" {
  name                     = module.naming.names.storage_account  # e.g. stcontosopaymeprdaue1a2b (shortened to fit 24 chars)
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "names" {
  value = module.naming.names
}

*/