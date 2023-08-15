# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a Azure Maps in Azure Partner Landing Zone
DESCRIPTION: The following components will be options in this deployment
             * Azure Maps Account
AUTHOR/S: jspinella
*/

module "mod_az_maps" {
  source  = "azurenoops/overlays-azmaps/azurerm"
  version = ">= 1.0.0"

  depends_on = [ module.mod_workload_network ]

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

  sku           = var.maps_sku
  storage_units = var.maps_storage_units

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
