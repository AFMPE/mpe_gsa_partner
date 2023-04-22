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

subscription_id = "65798e1e-c177-4373-ac3b-921f11f737c8"

###############################
# Workload Virtual Network  ###
###############################

deployed_to_hub_subscription = false
deny_all_inbound             = false
hub_virtual_network_id       = "/subscriptions/7eb60145-02f2-4fc1-80d2-e25d2ce9e45d/resourceGroups/ampe-eus-hub-core-prod-rg/providers/Microsoft.Network/virtualNetworks/ampe-eus-hub-core-prod-vnet"
firewall_private_ip          = "10.0.100.4"

wl_vnet_address_space           = ["10.0.125.0/24"]
wl_vnet_subnet_address_prefixes = ["10.0.125.0/27"]
wl_vnet_subnet_service_endpoints = [
  "Microsoft.KeyVault",
  "Microsoft.Sql",
  "Microsoft.Storage",
]

enable_forced_tunneling_on_route_table = true

wl_nsg_rules = [
  {
    name                       = "Allow-Traffic-From-Spokes"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "3389"]
    source_address_prefixes    = ["10.0.120.0/26", "10.0.115.0/26"]
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
