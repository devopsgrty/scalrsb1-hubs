locals {
  # Normalise "Australia East" -> "australiaeast"
  location_normalised = lower(replace(var.location, " ", ""))

  environment_short = {
    dev     = "dv"
    test    = "ts"
    uat     = "ua"
    staging = "st"
    prod    = "pd"
    dr      = "dr"
    sandbox = "sb"
  }

  # Short region codes
  location_short = {
    australiacentral   = "acl"
    australiacentral2  = "acl2"
    australiaeast      = "ae"
    australiasoutheast = "ase"
    austriaeast        = "aue"
    belgiumcentral     = "bec"
    brazilsouth        = "brs"
    brazilsoutheast    = "bse"
    canadacentral      = "cnc"
    canadaeast         = "cne"
    centralindia       = "inc"
    centralus          = "cus"
    centraluseuap      = "ccy"
    chilecentral       = "clc"
    denmarkeast        = "dke"
    eastasia           = "ea"
    eastus             = "eus"
    eastus2            = "eus2"
    eastus2euap        = "ecy"
    eastus3            = "eus3"
    francecentral      = "frc"
    francesouth        = "frs"
    germanynorth       = "gn"
    germanywestcentral = "gwc"
    indiasouthcentral  = "insc"
    indonesiacentral   = "idc"
    israelcentral      = "ilc"
    israelnorthwest    = "iln"
    italynorth         = "itn"
    japaneast          = "jpe"
    japanwest          = "jpw"
    jioindiacentral    = "jic"
    jioindiawest       = "jiw"
    koreacentral       = "krc"
    koreasouth         = "krs"
    malaysiasouth      = "mys"
    malaysiawest       = "myw"
    mexicocentral      = "mxc"
    newzealandnorth    = "nzn"
    northcentralus     = "ncus"
    northeastus5       = "ne5s"
    northeurope        = "ne"
    norwayeast         = "nwe"
    norwaywest         = "nww"
    polandcentral      = "plc"
    qatarcentral       = "qac"
    southafricanorth   = "san"
    southafricawest    = "saw"
    southcentralus     = "scus"
    southcentralus2    = "usc2"
    southeastasia      = "sea"
    southeastus        = "use"
    southeastus3       = "use3"
    southeastus5       = "use5"
    southindia         = "ins"
    southwestus        = "swus"
    spaincentral       = "spc"
    swedencentral      = "sdc"
    swedensouth        = "sds"
    switzerlandnorth   = "szn"
    switzerlandwest    = "szw"
    taiwannorth        = "twn"
    taiwannorthwest    = "tnw"
    uaecentral         = "uac"
    uaenorth           = "uan"
    uksouth            = "uks"
    ukwest             = "ukw"
    westcentralus      = "wcus"
    westeurope         = "we"
    westindia          = "inw"
    westus             = "wus"
    westus2            = "wus2"
    westus3            = "wus3"
  }

  env_code = local.environment_short[var.environment]
  loc_code = local.location_short[local.location_normalised]

  # Deterministic 4-char suffix for globally unique names (no random provider, so no plan churn)
  unique_suffix = substr(md5(join("-", [var.company, var.workload, local.location_normalised, var.environment])), 0, 4)

  # slug      = resource type abbreviation
  # max       = Azure maximum name length
  # hyphens   = whether the name may contain hyphens
  # unique    = name must be globally unique, so append the suffix
  resource_types = {
    resource_group          = { slug = "rg", max = 90, hyphens = true, unique = false }
    virtual_network         = { slug = "vnet", max = 64, hyphens = true, unique = false }
    subnet                  = { slug = "snet", max = 80, hyphens = true, unique = false }
    network_security_group  = { slug = "nsg", max = 80, hyphens = true, unique = false }
    route_table             = { slug = "rt", max = 80, hyphens = true, unique = false }
    public_ip               = { slug = "pip", max = 80, hyphens = true, unique = false }
    nat_gateway             = { slug = "ntg", max = 80, hyphens = true, unique = false }
    network_interface       = { slug = "nic", max = 80, hyphens = true, unique = false }
    private_endpoint        = { slug = "pep", max = 80, hyphens = true, unique = false }
    user_assigned_identity  = { slug = "id", max = 128, hyphens = true, unique = false }
    log_analytics_workspace = { slug = "log", max = 63, hyphens = true, unique = false }
    application_insights    = { slug = "appi", max = 260, hyphens = true, unique = false }
    app_service_plan        = { slug = "asp", max = 40, hyphens = true, unique = false }
    kubernetes_cluster      = { slug = "aks", max = 63, hyphens = true, unique = false }
    managed_disk            = { slug = "disk", max = 80, hyphens = true, unique = false }
    key_vault               = { slug = "kv", max = 24, hyphens = true, unique = true }
    web_app                 = { slug = "app", max = 60, hyphens = true, unique = true }
    function_app            = { slug = "func", max = 60, hyphens = true, unique = true }
    mssql_server            = { slug = "sql", max = 63, hyphens = true, unique = true }
    storage_account         = { slug = "st", max = 24, hyphens = false, unique = true }
    container_registry      = { slug = "cr", max = 50, hyphens = false, unique = true }
    virtaul_machine         = { slug = "vm", max = 64, hyphens = true, unique = false }
    palo_alto               = { slug = "pa", max = 64, hyphens = true, unique = false }
    zscaler_private         = { slug = "zpa", max = 64, hyphens = true, unique = false }
    zscaler_cloudconnect    = { slug = "zcc", max = 64, hyphens = true, unique = false }
  }

  middle_parts = compact([var.company, var.workload])

  names = {
    for key, rt in local.resource_types : key => (
      format(
        "%s%s%s",
        # head: slug + company + workload, truncated so the tail (region, env suffix) always survives
        replace(
          substr(
            join(rt.hyphens ? "-" : "", concat([rt.slug], local.middle_parts)),
            0,
            max(
              length(rt.slug),
              min(
                length(join(rt.hyphens ? "-" : "", concat([rt.slug], local.middle_parts))),
                rt.max - length(join(rt.hyphens ? "-" : "", concat([local.loc_code, local.env_code], rt.unique ? [local.unique_suffix] : []))) - (rt.hyphens ? 1 : 0)
              )
            )
          ),
          "/-+$/", ""
        ),
        rt.hyphens ? "-" : "",
        join(rt.hyphens ? "-" : "", concat([local.loc_code, local.env_code], rt.unique ? [local.unique_suffix] : []))
      )
    )
  }
}
