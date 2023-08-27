# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure API Management in Azure Partner Landing Zone
DESCRIPTION: The following components will be options in this deployment
              * Azure API Management
              * Azure API Management Subnet
              * Private Endpoint
              * Private DNS Zone
              * Key Vault
              * Application Insights
              * Redis Cache
              * User Identity
AUTHOR/S: jspinella, jscott
*/

module "mod_apim" {
  source  = "azurenoops/overlays-api-management/azurerm"
  version = "~> 1.0"

  depends_on = [module.mod_workload_network, module.mod_app_service_environment, module.mod_app_service]

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_maps_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  existing_resource_group_name = module.mod_workload_network.resource_group_name
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  environment                  = var.required.environment
  workload_name                = "${var.wl_name}-api"

  # API Management configuration
  enable_user_identity = var.enable_user_identity
  publisher_email      = var.publisher_email
  publisher_name       = var.publisher_name
  min_api_version      = var.min_api_version

  # SKU configuration
  sku_tier     = var.sku_tier
  sku_capacity = var.sku_capacity

  # Redis configuration
  enable_redis_cache              = var.enable_redis_cache
  existing_redis_private_dns_zone = module.mod_workload_network.private_dns_zone_names[2]

  # Key Vault configuration
  create_apim_keyvault               = true
  existing_keyvault_private_dns_zone = module.mod_workload_network.private_dns_zone_names[3]

  # Virtual network configuration
  virtual_network_name = module.mod_workload_network.virtual_network_name
  apim_subnet_name     = "ampe-eus-gsa-prod-apim-snet" # This is the subnet where APIM will be deployed. 
  existing_nsg_name    = "ampe-eus-gsa-prod-apim-nsg"  # This is the NSG that will be associated with the APIM subnet.

  # Private endpoint configuration
  # Key Vault and Redis are deployed by default.
  # So we need to make sure that the subnet is configured for private endpoints.
  existing_private_subnet_name = "ampe-eus-gsa-prod-pe-snet"

  # This is to enable resource locks for apim. 
  enable_resource_locks = false

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
