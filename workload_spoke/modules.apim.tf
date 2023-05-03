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
  depends_on = [
    module.mod_workload_network
  ]
  source  = "azurenoops/overlays-api-management/azurerm"
  version = ">= 1.0.0"

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
  workload_name                = "gsa"

  publisher_email = var.publisher_email
  publisher_name  = var.publisher_name

  sku_tier                       = var.sku_tier
  sku_capacity                   = var.sku_capacity
  enable_redis_cache             = var.enable_redis_cache
  enable_user_identity           = var.enable_user_identity
  enable_application_insights    = var.enable_app_insights
  virtual_network_type           = var.virtual_network_type
  apim_subnet_name               = var.apim_subnet_name
  private_endpoint_subnet_name   = var.private_endpoint_subnet_name
  private_endpoint_subnet_prefix = var.private_endpoint_subnet_prefix
  enable_resource_locks          = var.enable_resource_locks
  virtual_network_name           = module.mod_workload_network.virtual_network_name
  min_api_version                = "2019-12-01"

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
