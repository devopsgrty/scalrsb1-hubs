variable "company" {
  description = "Short company or organisation name used in every resource name (lowercase letters and numbers, 2-4 chars)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,4}$", var.company))
    error_message = "company must be 2-4 characters, lowercase letters and numbers only."
  }
}

variable "environment" {
  description = "Environment name. One of: dev, test, uat, staging, prod, dr, sandbox."
  type        = string

  validation {
    condition     = contains(["dev", "test", "uat", "staging", "prod", "dr", "sandbox"], var.environment)
    error_message = "environment must be one of: dev, test, uat, staging, prod, dr, sandbox."
  }
}

variable "location" {
  description = "Azure region, e.g. \"australiaeast\" or \"Australia East\"."
  type        = string

  validation {
    condition = contains(
      [
        "australiacentral", "australiacentral2", "australiaeast", "australiasoutheast", "austriaeast", "belgiumcentral",
        "brazilsouth", "brazilsoutheast", "canadacentral", "canadaeast", "centralindia", "centralus",
        "centraluseuap", "chilecentral", "denmarkeast", "eastasia", "eastus", "eastus2",
        "eastus2euap", "eastus3", "francecentral", "francesouth", "germanynorth", "germanywestcentral",
        "indiasouthcentral", "indonesiacentral", "israelcentral", "israelnorthwest", "italynorth", "japaneast",
        "japanwest", "jioindiacentral", "jioindiawest", "koreacentral", "koreasouth", "malaysiasouth",
        "malaysiawest", "mexicocentral", "newzealandnorth", "northcentralus", "northeastus5", "northeurope",
        "norwayeast", "norwaywest", "polandcentral", "qatarcentral", "southafricanorth", "southafricawest",
        "southcentralus", "southcentralus2", "southeastasia", "southeastus", "southeastus3", "southeastus5",
        "southindia", "southwestus", "spaincentral", "swedencentral", "swedensouth", "switzerlandnorth",
        "switzerlandwest", "taiwannorth", "taiwannorthwest", "uaecentral", "uaenorth", "uksouth",
        "ukwest", "westcentralus", "westeurope", "westindia", "westus", "westus2",
        "westus3"
      ],
      lower(replace(var.location, " ", ""))
    )
    error_message = "location is not in this module's region list. Add it to local.location_short in locals.tf."
  }
}

variable "workload" {
  description = "Optional workload or application name (lowercase letters and numbers, up to 12 chars). Strongly recommended to avoid name clashes."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9]{0,12}$", var.workload))
    error_message = "workload must be up to 12 characters, lowercase letters and numbers only."
  }
}
