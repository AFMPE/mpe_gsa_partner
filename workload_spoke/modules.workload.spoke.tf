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
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-spoke"
  version = ">= 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = module.mod_azure_region_lookup.location_cli
  deploy_environment = var.required.deploy_environment
  org_name           = var.required.org_name
  environment        = var.required.environment
  workload_name      = var.wl_name

  ##################################################
  ## Operations Spoke Configuration   (Default)  ###
  ##################################################

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = var.deployed_to_hub_subscription

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = var.wl_vnet_address_space

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix                         = var.wl_vnet_subnet_address_prefixes
  spoke_subnet_service_endpoints                      = var.wl_vnet_subnet_service_endpoints
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Provide additional subnets to be added to the spoke virtual network
  add_subnets = var.wl_vnet_subnets

  # Hub Virtual Network ID
  hub_virtual_network_id = data.azurerm_virtual_network.hub_vnet.id
  #"/subscriptions/7eb60145-02f2-4fc1-80d2-e25d2ce9e45d/resourceGroups/ampe-eus-hub-core-prod-rg/providers/Microsoft.Network/virtualNetworks/ampe-eus-hub-core-prod-vnet" #data.terraform_remote_state.mpe_landing_zone.outputs.hub_virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = data.azurerm_firewall.hub_fw.ip_configuration.0.private_ip_address
  #"10.0.100.4" #data.terraform_remote_state.mpe_landing_zone.outputs.firewall_private_ip

  # (Optional) Operations Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = var.deny_all_inbound

  # Network Security Group Rules to apply to the Operatioms Virtual Network
  nsg_additional_rules = var.wl_nsg_rules

  # Enable forced tunneling on the route table
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_route_table

  # Add additional routes to the route table
  route_table_routes = var.wl_route_table_routes

  #############################
  ## Peering Configuration  ###
  #############################

  allow_virtual_spoke_network_access = var.allow_virtual_spoke_network_access
  allow_forwarded_spoke_traffic      = var.allow_forwarded_spoke_traffic
  allow_gateway_spoke_transit        = var.allow_gateway_spoke_transit
  use_remote_spoke_gateway           = var.use_remote_spoke_gateway

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
