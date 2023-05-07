# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License. 

# This is a sample configuration file for the MPE Landing Zone Workload Spoke
# This file is used to configure the MPE Landing Zone Workload Spoke.  
# It is used to set the default values for the variables used in the MPE Landing Zone Workload Spoke.  The values in this file can be overridden by setting the same variable in the terraform.tfvars file.

###########################
## Global Configuration  ##
###########################

required = {
  org_name           = "ampe-gsa"             # This Prefix will be used on most deployed resources.  10 Characters max.
  deploy_environment = "dev"                  # dev | test | prod
  environment        = "public"               # public | usgovernment
  metadata_host      = "management.azure.com" # management.azure.com | management.usgovcloudapi.net
}

# The default region to deploy to
location = "eastus"

# Enable locks on resources
enable_resource_locks = false

# Hub Subscription Information
hub_rg_name   = "ampe-eus-hub-core-prod-rg"
hub_vnet_name = "ampe-eus-hub-core-prod-vnet"
hub_fw_name   = "ampe-eus-hub-core-prod-fw"

###############################
# Workload Virtual Network  ###
###############################

deployed_to_hub_subscription = false
deny_all_inbound             = false

wl_vnet_address_space           = ["10.0.124.0/23"]
wl_vnet_subnet_address_prefixes = ["10.0.125.0/27"]
wl_vnet_subnet_service_endpoints = [
  "Microsoft.KeyVault",
  "Microsoft.Sql",
  "Microsoft.Storage",
]

wl_vnet_subnets = {
  "apim_snet" = {
    name             = "apim"
    address_prefixes = ["10.0.125.32/27"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
      "Microsoft.EventHub",
      "Microsoft.ServiceBus",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
  }
  "pe_snet" = {
    name             = "pe"
    address_prefixes = ["10.0.125.64/27"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
  }
  "app_snet" = {
    name             = "app"
    address_prefixes = ["10.0.124.0/24"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
      "Microsoft.EventHub",
      "Microsoft.ServiceBus",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
    delegation = {
      name = "app_service_delegation"
      service_delegation = {
        service_delegation_name = "Microsoft.Web/hostingEnvironments"
      }
    }
  }
}

enable_forced_tunneling_on_route_table = true

wl_route_table_routes = {
  "ASE-SQL-Route" = {
    name                   = "ASE-SQL-Route"
    address_prefix         = "Sql"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.100.4"
  },
  "ASE-EventHub-Route" = {
    name                   = "ASE-EventHub-Route"
    address_prefix         = "EventHub"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.100.4"
  },
  "AppServiceManagementTraffic-Route" = {
    name           = "AppServiceManagementTraffic-Route"
    address_prefix = "AppServiceManagement"
    next_hop_type  = "Internet"
  },
  "ApiManagementTraffic-Route" = {
    name           = "ApiManagementTraffic-Route"
    address_prefix = "ApiManagement"
    next_hop_type  = "Internet"
  }
}

wl_nsg_rules = [
  {
    name                       = "Allow-Traffic-From-Spokes"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "3389"]
    source_address_prefixes    = ["10.0.120.0/26", "10.0.115.0/26", "10.0.100.0/24"]
    destination_address_prefix = "10.0.125.0/24"
  },
]


#############################
## Peering Configuration  ###
#############################

allow_virtual_spoke_network_access = true
allow_forwarded_spoke_traffic      = true
allow_gateway_spoke_transit        = true
use_remote_spoke_gateway           = false

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

virtual_machine_admins = []
virtual_machine_users  = []
bastion_vm_size        = "Standard_D2s_v3"
bastion_admin_username = "mpeadminuser"

#########################
## SQL Configuration  ###
#########################

sql_databases = [
  {
    name        = "CastrumDB"
    max_size_gb = 5
  }
]

enable_private_endpoint = true

################################
## Azure Maps Configuration  ###
################################

maps_sku           = "G2"
maps_storage_units = 1

############################
## Azure API Management  ###
############################

publisher_email                = "gsa_admins@missionpartners.us"
publisher_name                 = "afmpe-gsa"
sku_tier                       = "Developer"
sku_capacity                   = 1
enable_redis_cache             = true
enable_user_identity           = true
enable_app_insights            = true
virtual_network_type           = "Internal"
apim_subnet_name               = "ampe-gsa-eastus-apim-snet"
private_endpoint_subnet_name   = "ampe-gsa-eastus-pe-snet"
private_endpoint_subnet_prefix = ["10.0.125.64/27"]

###############################
## Azure App Service Env  ###
###############################

ase_subnet_name = "ampe-gsa-eastus-app-snet"

#########################
## Azure App Service  ###
#########################

app_service_apps = {
  "access-decision-service-subsystem" = {
    workload_name                = "adss"
    app_service_name             = "access-decision-service-subsystem"
    app_service_plan_sku_name    = "I1v2"
    enable_private_endpoint      = true
    existing_private_dns_zone    = "privatelink.vaultcore.azure.net"
    create_app_service_plan      = true
    private_endpoint_subnet_name = "ampe-gsa-eastus-pe-snet"
    deployment_slot_count        = 1
    app_service_resource_type    = "App"
    app_service_plan_os_type     = "Windows"
    site_config = {
      always_on = true
      application_stack = {
        current_stack  = "dotnet"
        dotnet_version = "v6.0"
      }
      use_32_bit_worker        = false
      health_check_path        = "/health"
      ftps_state               = "Disabled"
      http2_enabled            = true
      http_logging_enabled     = true
      min_tls_version          = "1.2"
      remote_debugging_enabled = true
      websockets_enabled       = false
    }
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1
  },
  "directus-subsystem" = {
    workload_name                = "dus"
    app_service_name             = "directus-subsystem"
    app_service_plan_sku_name    = "I1v2"
    enable_private_endpoint      = true
    existing_private_dns_zone    = "privatelink.vaultcore.azure.net"
    create_app_service_plan      = true
    private_endpoint_subnet_name = "ampe-gsa-eastus-pe-snet"
    deployment_slot_count        = 2
    app_service_resource_type    = "App"
    app_service_plan_os_type     = "Linux"
    site_config = {
      always_on = true
      application_stack = {
        docker_image     = "directus/directus"
        docker_image_tag = "9.23.1"
        dotnet_version = "6.0"
      }
      container_registry_use_managed_identity = true
      health_check_path                       = "/server/health"
      ftps_state                              = "Disabled"
      http2_enabled                           = true
      http_logging_enabled                    = true
      min_tls_version                         = "1.2"
      remote_debugging_enabled                = true
      websockets_enabled                      = false
    }
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1
    create_app_container_registry = true    
  },
  "high-throughput-api-subsystem" = {
    workload_name                = "htas"
    app_service_name             = "high-throughput-api-subsystem"
    app_service_plan_sku_name    = "I1v2"
    enable_private_endpoint      = true
    existing_private_dns_zone    = "privatelink.vaultcore.azure.net"
    create_app_service_plan      = true
    private_endpoint_subnet_name = "ampe-gsa-eastus-pe-snet"
    deployment_slot_count        = 1
    app_service_resource_type    = "FunctionApp"
    app_service_plan_os_type     = "Windows"
    site_config = {
      always_on = true
      application_stack = {
        dotnet_version = "v6.0"
      }
      use_32_bit_worker        = false
      health_check_path        = "/health"
      ftps_state               = "Disabled"
      http2_enabled            = true
      http_logging_enabled     = true
      min_tls_version          = "1.2"
      remote_debugging_enabled = true
      websockets_enabled       = false
    }
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1
  },
  "symbology-api-subsystem" = {
    workload_name                = "symas"
    app_service_name             = "symbology-api-subsystem"
    app_service_plan_sku_name    = "I1v2"
    enable_private_endpoint      = true
    existing_private_dns_zone    = "privatelink.vaultcore.azure.net"
    create_app_service_plan      = true
    private_endpoint_subnet_name = "ampe-gsa-eastus-pe-snet"
    deployment_slot_count        = 2
    app_service_resource_type    = "FunctionApp"
    app_service_plan_os_type     = "Windows"
    site_config = {
      always_on = true
      application_stack = {
        node_version = "~18"
      }
      use_32_bit_worker        = false
      health_check_path        = "/health"
      ftps_state               = "Disabled"
      http2_enabled            = true
      http_logging_enabled     = true
      min_tls_version          = "1.2"
      remote_debugging_enabled = true
      websockets_enabled       = false
    }
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1
  },
  "timer-subsystem" = {
    workload_name                = "ts"
    app_service_name             = "timer-subsystem"
    app_service_plan_sku_name    = "I1v2"
    enable_private_endpoint      = true
    existing_private_dns_zone    = "privatelink.vaultcore.azure.net"
    create_app_service_plan      = true
    create_app_service_plan      = true
    private_endpoint_subnet_name = "ampe-gsa-eastus-pe-snet"
    virtual_network_name         = "ampe-gsa-eus-dev-vnet"
    deployment_slot_count        = 2
    app_service_resource_type    = "FunctionApp"
    app_service_plan_os_type     = "Windows"
    site_config = {
      always_on = true
      application_stack = {
        dotnet_version = "v6.0"
      }
      use_32_bit_worker        = false
      health_check_path        = "/health"
      ftps_state               = "Disabled"
      http2_enabled            = true
      http_logging_enabled     = true
      min_tls_version          = "1.2"
      remote_debugging_enabled = true
      websockets_enabled       = false
    }
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1
  },
  "web-client-subsystem" = {
    workload_name                = "wcs"
    app_service_name             = "web-client-subsystem"
    app_service_plan_sku_name    = "I1v2"
    enable_private_endpoint      = true
    existing_private_dns_zone    = "privatelink.vaultcore.azure.net"
    create_app_service_plan      = true
    private_endpoint_subnet_name = "ampe-gsa-eastus-pe-snet"
    virtual_network_name         = "ampe-gsa-eus-dev-vnet"
    deployment_slot_count        = 2
    app_service_resource_type    = "App"
    app_service_plan_os_type     = "Windows"
    site_config = {
      always_on = true
      application_stack = {
        current_stack  = "dotnet"
        dotnet_version = "v6.0"
      }
      use_32_bit_worker        = false
      health_check_path        = "/health.html"
      ftps_state               = "Disabled"
      http2_enabled            = true
      http_logging_enabled     = true
      min_tls_version          = "1.2"
      remote_debugging_enabled = true
      websockets_enabled       = false
    }
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1
  },
}

###########################
## Azure Functions App  ###
###########################
