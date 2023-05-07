# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a Azure App Service Environment in Azure Partner Landing Zone
DESCRIPTION: The following components will be options in this deployment
             * App Service Environment
             * App Service Environment Subnet              
AUTHOR/S: jspinella, jscott
*/

module "mod_app_service_environment" {
  source  = "azurenoops/overlays-app-service-environment/azurerm"
  version = ">= 1.0.0"

  existing_resource_group_name = module.mod_workload_network.resource_group_name
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  environment                  = var.required.environment
  workload_name                = "gsa"

  ase_subnet_name      = var.ase_subnet_name
  virtual_network_name = module.mod_workload_network.virtual_network_name

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}

# 
module "mod_app_service" {
  source  = "azurenoops/overlays-app-service/azurerm"
  version = ">= 1.0.0"

  for_each = var.app_service_apps

  existing_resource_group_name = module.mod_workload_network.resource_group_name
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  environment                  = var.required.environment
  workload_name                = each.value.workload_name

  app_service_environment          = module.mod_app_service_environment.ase_name
  enable_private_endpoint          = each.value.enable_private_endpoint
  existing_private_dns_zone        = each.value.existing_private_dns_zone
  app_service_name                 = each.value.app_service_name
  virtual_network_name             = module.mod_workload_network.virtual_network_name
  private_endpoint_subnet_name     = each.value.private_endpoint_subnet_name
  app_service_plan_sku_name        = each.value.app_service_plan_sku_name
  create_app_service_plan          = each.value.create_app_service_plan
  create_app_container_registry    = each.value.create_app_container_registry != null ? each.value.create_app_container_registry : false
  deployment_slot_count            = each.value.deployment_slot_count
  app_service_plan_os_type         = each.value.app_service_plan_os_type
  app_service_resource_type        = each.value.app_service_resource_type
  windows_app_site_config          = each.value.app_service_plan_os_type == "Windows" && each.value.app_service_resource_type == "App" ? each.value.site_config : null
  windows_function_app_site_config = each.value.app_service_plan_os_type == "Windows" && each.value.app_service_resource_type == "FunctionApp" ? each.value.site_config : null
  linux_app_site_config            = each.value.app_service_plan_os_type == "Linux" && each.value.app_service_resource_type == "App" ? each.value.site_config : null
  linux_function_app_site_config   = each.value.app_service_plan_os_type == "Linux" && each.value.app_service_resource_type == "FunctionApp" ? each.value.site_config : null
  website_run_from_package         = each.value.website_run_from_package
  app_service_plan_worker_count    = each.value.app_service_plan_worker_count

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
