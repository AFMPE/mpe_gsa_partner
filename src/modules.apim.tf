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
  version = "~> 2.0"

  depends_on = [module.mod_workload_network]

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
  workload_name                = var.wl_name

  # API Management configuration
  enable_user_identity = true
  publisher_email      = "apim_admins@microsoft.com"
  publisher_name       = "apim"
  min_api_version      = "2019-12-01"

  # SKU configuration
  sku_tier     = "Developer"
  sku_capacity = 1

  # Virtual network configuration
  virtual_network_name = module.mod_workload_network.virtual_network_name
  apim_subnet_name     = var.apim_subnet_name # This is the subnet where APIM will be deployed. 

  # Private endpoint configuration
  # Key Vault and Redis are deployed by default.
  # So we need to make sure that the subnet is configured for private endpoints.
  existing_private_subnet_name = var.private_endpoint_subnet_name

  # This is to enable resource locks for the key vault. 
  enable_resource_locks = false

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
