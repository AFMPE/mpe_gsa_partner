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

##############################################
## Prod Remote Storage State Configuration  ##
##############################################

# Deployment state storage information
state_sa_name           = "afmpetfmgtprodh8dc4qua"
state_sa_rg             = "afmpe-network-artifacts-rg"
state_sa_container_name = "core-mgt-prod-tfstate"

###############################
# Workload Virtual Network  ###
###############################

deployed_to_hub_subscription = false
deny_all_inbound             = false
firewall_private_ip          = "10.0.100.4" # This is the private IP of the firewall in the hub vnet. Have to update outputs in hub vnet to get this value.

wl_vnet_address_space           = ["10.0.124.0/23"]
wl_vnet_subnet_address_prefixes = ["10.0.125.0/27"]
wl_vnet_subnet_service_endpoints = [
  "Microsoft.KeyVault",
  "Microsoft.Sql",
  "Microsoft.Storage",
]

wl_vnet_subnets = {
  "apim_snet" = {
    name             = "apim"
    address_prefixes = ["10.0.125.32/27"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
  }
  "pe_snet" = {
    name             = "pe"
    address_prefixes = ["10.0.125.64/27"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
  }
  "app_snet" = {
    name             = "app"
    address_prefixes = ["10.0.124.0/24"]
    service_endpoints = [
      "Microsoft.KeyVault",
      "Microsoft.Sql",
      "Microsoft.Storage",
    ]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = false
  }
}

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

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

virtual_machine_admins = []
virtual_machine_users  = []
bastion_vm_size        = "Standard_D2s_v3"
bastion_admin_username = "mpeadminuser"
bastion_admin_password = "Password1234!"
