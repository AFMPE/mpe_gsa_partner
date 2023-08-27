# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a Azure App Service Environment in Azure Partner Landing Zone
DESCRIPTION: The following components will be options in this deployment
             * App Service Environment
             * App Service              
AUTHOR/S: jspinella, jscott
*/

module "mod_app_service_environment" {
  source  = "azurenoops/overlays-app-service-environment/azurerm"
  version = "~> 1.0"

  depends_on = [module.mod_workload_network]

  existing_resource_group_name = module.mod_workload_network.resource_group_name
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  environment                  = var.required.environment
  workload_name                = var.wl_name

  ase_subnet_name      = "ampe-eus-gsa-prod-app-snet"
  virtual_network_name = module.mod_workload_network.virtual_network_name
  existing_nsg_name    = "ampe-eus-gsa-prod-app-nsg"

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}

# 
module "mod_app_service" {
  source  = "azurenoops/overlays-app-service/azurerm"
  version = "~> 2.0"

  depends_on = [module.mod_workload_network, module.mod_app_service_environment]

  for_each = var.app_service_apps

  # Global Variables
  existing_resource_group_name = module.mod_workload_network.resource_group_name
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  environment                  = var.required.environment
  workload_name                = each.value.workload_name

  # ASE Configuration
  enable_app_service_environment = true
  app_service_environment_name   = module.mod_app_service_environment.ase_name

  # Private Endpoint Configuration
  virtual_network_name         = module.mod_workload_network.virtual_network_name
  private_endpoint_subnet_name = "ampe-eus-gsa-prod-pe-snet"

  # App Service Configuration
  create_app_service_plan       = each.value.create_app_service_plan
  app_service_plan_sku_name     = each.value.app_service_plan_sku_name
  app_service_plan_os_type      = each.value.app_service_plan_os_type
  app_service_resource_type     = each.value.app_service_resource_type
  app_service_plan_worker_count = each.value.app_service_plan_worker_count
  website_run_from_package      = each.value.website_run_from_package
  deployment_slot_count         = each.value.deployment_slot_count

  # App Service Plan Site Config
  windows_app_site_config          = each.value.app_service_plan_os_type == "Windows" && each.value.app_service_resource_type == "App" ? each.value.site_config : null
  windows_function_app_site_config = each.value.app_service_plan_os_type == "Windows" && each.value.app_service_resource_type == "FunctionApp" ? each.value.site_config : null
  linux_app_site_config            = each.value.app_service_plan_os_type == "Linux" && each.value.app_service_resource_type == "App" ? each.value.site_config : null
  linux_function_app_site_config   = each.value.app_service_plan_os_type == "Linux" && each.value.app_service_resource_type == "FunctionApp" ? each.value.site_config : null

  # ACR Configuration
  create_app_container_registry = each.value.create_app_container_registry != null ? each.value.create_app_container_registry : false
  enable_acr_private_endpoint   = each.value.enable_acr_private_endpoint
  existing_acr_private_dns_zone = each.value.enable_acr_private_endpoint ? module.mod_workload_network.private_dns_zone_names[0] : null

  # Key Vault Configuration
  create_app_keyvault                = each.value.create_app_keyvault ? each.value.create_app_keyvault : false
  existing_keyvault_private_dns_zone = each.value.create_app_keyvault ? module.mod_workload_network.private_dns_zone_names[3] : null

  # Storage Configuration
  existing_storage_private_dns_zone = each.value.app_service_resource_type == "FunctionApp" ? module.mod_workload_network.private_dns_zone_names[1] : null

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
