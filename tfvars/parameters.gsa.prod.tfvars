# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License. 

# This is a sample configuration file for the MPE Landing Zone Workload Spoke
# This file is used to configure the MPE Landing Zone Workload Spoke.  
# It is used to set the default values for the variables used in the MPE Landing Zone Workload Spoke.  The values in this file can be overridden by setting the same variable in the terraform.tfvars file.

###########################
## Global Configuration  ##
###########################

required = {
  org_name           = "ampe"   # This Prefix will be used on most deployed resources.  10 Characters max.
  deploy_environment = "prod"    # dev | test | prod
  environment        = "public" # public | usgovernment
}

# The default region to deploy to
location = "eastus"

# Enable locks on resources
enable_resource_locks = false

# Hub Subscription Information
hub_rg_name     = "ampe-eus-hub-core-prod-rg"
hub_log_rg_name = "ampe-eus-ops-logging-core-prod-rg"
hub_vnet_name   = "ampe-eus-hub-core-prod-vnet"
hub_fw_name     = "ampe-eus-hub-core-prod-fw"
hub_log_name    = "ampe-eus-ops-logging-core-prod-log"
hub_log_st_name = "ampeeus264794eccaafa2f0"

###############################
# Workload Virtual Network  ###
###############################

# The name of the workload for the spoke
wl_name = "gsa"

# Is the spoke deployed to a hub subscription
deployed_to_hub_subscription = false

# Vnet Address Space
wl_vnet_address_space = ["10.0.126.0/23"]

wl_vnet_subnets = {
  "default" = {
    name             = "default"
    address_prefixes = ["10.0.127.0/27"]
    service_endpoints = [
      "Microsoft.Storage",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false

    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from Spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.0.120.0/26", "10.0.115.0/26", "10.0.100.0/24"],
        destination_address_prefix = "10.0.126.0/23"
      }
    ]
  },
  "vm" = {
    name             = "vm"
    address_prefixes = ["10.0.127.96/27"]
    service_endpoints = [
      "Microsoft.Storage",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
  },
  "apim" = {
    name             = "apim"
    address_prefixes = ["10.0.127.32/27"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
      "Microsoft.EventHub",
      "Microsoft.ServiceBus",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
  },
  "pe" = {
    name             = "pe"
    address_prefixes = ["10.0.127.64/27"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false

  },
  "app" = {
    name             = "app"
    address_prefixes = ["10.0.126.0/24"]
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
        name    = "Microsoft.Web/hostingEnvironments"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
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

wl_private_dns_zones = ["privatelink.vaultcore.azure.net", "privatelink.azurecr.io", "privatelink.blob.core.windows.net", "privatelink.redis.cache.windows.net"]


#############################
## Peering Configuration  ###
#############################

use_source_remote_spoke_gateway = false

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

# Bastion VM Configuration
windows_distribution_name = "windows2019dc"
virtual_machine_size      = "Standard_B1s"

# This module support multiple Pre-Defined windows and Windows Distributions.
# Check the README.md file for more pre-defined images for Ubuntu, Centos, RedHat.
# Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
# Specify `disable_password_authentication = false` to create random admin password
# Specify a valid password with `admin_password` argument to use your own password .  
vm_admin_username = "mpeazureuser"
instances_count   = 1

# Network Seurity group port definitions for each Virtual Machine 
# NSG association for all network interfaces to be added automatically.
nsg_inbound_rules = [
  {
    name                   = "RDC"
    destination_port_range = "3376"
    source_address_prefix  = "*"
  },
]

# Attach a managed data disk to a Windows/windows virtual machine. 
# Storage account types include: #'Standard_LRS', #'StandardSSD_ZRS', #'Premium_LRS', #'Premium_ZRS', #'StandardSSD_LRS', #'UltraSSD_LRS' (UltraSSD_LRS is only accessible in regions that support availability zones).
# Create a new data drive - connect to the VM and execute diskmanagemnet or fdisk.
data_disks = [
  {
    name                 = "disk1"
    disk_size_gb         = 100
    storage_account_type = "StandardSSD_LRS"
  },
  {
    name                 = "disk2"
    disk_size_gb         = 200
    storage_account_type = "Standard_LRS"
  }
]

# Deploy log analytics agents on a virtual machine. 
# Customer id and primary shared key for Log Analytics workspace are required.
deploy_log_analytics_agent       = true
enable_proximity_placement_group = false
enable_vm_availability_set       = false
enable_public_ip_address         = false
enable_boot_diagnostics          = false

#########################
## SQL Configuration  ###
#########################

# SQL Server Configuration
sql_databases = [
  {
    name        = "CastrumDB"
    max_size_gb = 5
  }
]

# Private Endpoint Configuration
enable_private_endpoint = true

################################
## Azure Maps Configuration  ###
################################

maps_sku           = "G2"
maps_storage_units = 1

############################
## Azure API Management  ###
############################

# API Management Configuration
publisher_email              = "gsa_admins@missionpartners.us"
publisher_name               = "afmpe-gsa"
sku_tier                     = "Developer"
min_api_version              = "2019-12-01"
sku_capacity                 = 1
enable_user_identity         = true

#########################
## Azure App Service  ###
#########################

app_service_apps = {
  "access-decision-service-subsystem" = {
    # App Service Configuration
    workload_name                 = "adss"
    create_app_service_plan       = true
    app_service_name              = "access-decision-service-subsystem"
    app_service_plan_sku_name     = "I1v2"
    app_service_resource_type     = "App"
    app_service_plan_os_type      = "Windows"
    deployment_slot_count         = 1
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1

    # ACR Configuration
    create_app_container_registry = false
    enable_acr_private_endpoint   = false

    # Key Vault Configuration
    create_app_keyvault = true

    # App Service Site Configuration
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
  },
  "directus-subsystem" = {
    # App Service Configuration
    workload_name                 = "dus"
    create_app_service_plan       = true
    app_service_name              = "directus-subsystem"
    app_service_plan_sku_name     = "I1v2"
    app_service_resource_type     = "App"
    app_service_plan_os_type      = "Linux"
    deployment_slot_count         = 2
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1

    # ACR Configuration
    create_app_container_registry = true
    enable_acr_private_endpoint   = true

    # Key Vault Configuration
    create_app_keyvault = true

    # App Service Site Configuration
    site_config = {
      always_on = true
      application_stack = {
        docker_image     = "directus/directus"
        docker_image_tag = "9.23.1"
        dotnet_version   = "6.0"
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
  },
  "high-throughput-api-subsystem" = {
    # App Service Configuration
    workload_name                 = "htas"
    create_app_service_plan       = true
    app_service_name              = "high-throughput-api-subsystem"
    app_service_plan_sku_name     = "I1v2"
    app_service_resource_type     = "FunctionApp"
    app_service_plan_os_type      = "Windows"
    deployment_slot_count         = 1
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1

    # ACR Configuration
    create_app_container_registry = false
    enable_acr_private_endpoint   = false

    # Key Vault Configuration
    create_app_keyvault = true

    # App Service Site Configuration
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
  },
  "symbology-api-subsystem" = {
    # App Service Configuration
    workload_name                 = "symas"
    create_app_service_plan       = true
    app_service_name              = "symbology-api-subsystem"
    app_service_plan_sku_name     = "I1v2"
    app_service_resource_type     = "FunctionApp"
    app_service_plan_os_type      = "Windows"
    deployment_slot_count         = 2
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1

    # ACR Configuration
    create_app_container_registry = false
    enable_acr_private_endpoint   = false

    # Key Vault Configuration
    create_app_keyvault = true

    # App Service Site Configuration
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
  },
  "timer-subsystem" = {
    # App Service Configuration
    workload_name                 = "ts"
    create_app_service_plan       = true
    app_service_name              = "timer-subsystem"
    app_service_plan_sku_name     = "I1v2"
    app_service_resource_type     = "FunctionApp"
    app_service_plan_os_type      = "Windows"
    deployment_slot_count         = 2
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1

    # ACR Configuration
    create_app_container_registry = false
    enable_acr_private_endpoint   = false

    # Key Vault Configuration
    create_app_keyvault = true

    # App Service Site Configuration
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

  },
  "web-client-subsystem" = {
    # App Service Configuration
    workload_name                 = "wcs"
    create_app_service_plan       = true
    app_service_name              = "web-client-subsystem"
    app_service_plan_sku_name     = "I1v2"
    app_service_resource_type     = "App"
    app_service_plan_os_type      = "Windows"
    deployment_slot_count         = 2
    website_run_from_package      = "1"
    app_service_plan_worker_count = 1

    # ACR Configuration
    create_app_container_registry = false
    enable_acr_private_endpoint   = false

    # Key Vault Configuration
    create_app_keyvault = true

    # App Service Site Configuration
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

  },
}

