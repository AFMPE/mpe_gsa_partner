# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a workload spoke virtual network in Azure Partner Landing Zone
DESCRIPTION: The following components will be options in this deployment
             * Virtual Network
             * Subnets
             * Network Security Groups
             * Network Security Group Rules
             * Service Endpoints
             * Private Endpoints
             * Private Link Services
             * Resource Locks
AUTHOR/S: jspinella
*/

######################################
### Workload Spoke Configuration   ###
######################################

// Resources for the Operations Spoke
module "mod_workload_network" {
  source  = "azurenoops/overlays-workload-spoke/azurerm"
  version = "~> 3.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = module.mod_azure_region_lookup.location_cli
  deploy_environment    = var.required.deploy_environment
  org_name              = var.required.org_name
  environment           = var.required.environment
  workload_name         = var.wl_name

  # Collect Spoke Virtual Network Parameters
  # Spoke network details to create peering and other setup
  hub_virtual_network_id          = data.azurerm_virtual_network.hub_vnet.id
  hub_firewall_private_ip_address = data.azurerm_firewall.hub_fw.ip_configuration.0.private_ip_address
  hub_storage_account_id          = data.azurerm_storage_account.hub_st.id

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Spoke module
  # Possible values range between 30 and 730
  log_analytics_workspace_id           = data.azurerm_log_analytics_workspace.hub_log.id
  log_analytics_customer_id            = data.azurerm_log_analytics_workspace.hub_log.workspace_id
  log_analytics_logs_retention_in_days = 30

  ##################################################
  ## GSA Spoke Configuration   (Default)  ###
  ##################################################

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = var.wl_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Specify if you are deploying the spoke VNet using the same hub Azure subscription
  is_spoke_deployed_to_same_hub_subscription = var.deployed_to_hub_subscription

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  spoke_subnets = var.wl_vnet_subnets

  # Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_route_table

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create addtional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.wl_private_dns_zones

  # Add additional routes to the route table
  route_table_routes = var.wl_route_table_routes

  #############################
  ## Peering Configuration  ###
  #############################

  # Peering
  # By default, Azure NoOps will create peering between Hub and Spoke.
  # Since is using a gateway, set the argument to `use_source_remote_spoke_gateway = true`, to enable gateway traffic.   
  use_source_remote_spoke_gateway = var.use_source_remote_spoke_gateway

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
