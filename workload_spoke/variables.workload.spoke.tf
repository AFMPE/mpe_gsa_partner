# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################
# Workload Spoke ###
####################

variable "wl_name" {
  description = "A name for the workload. It defaults to wl-core."
  type        = string
  default     = null
}

variable "wl_vnet_address_space" {
  description = "The address space of the workload virtual network."
  type        = list(string)
  default     = null
}

variable "wl_vnet_subnet_address_prefixes" {
  description = "The address prefixes of the workload virtual network subnets."
  type        = list(string)
  default     = null
}

variable "wl_vnet_subnets" {
  description = "A list of subnets to add to the workload virtual network"
  type = map(object({
    name                                       = string
    address_prefixes                           = list(string)
    service_endpoints                          = list(string)
    private_endpoint_network_policies_enabled  = bool
    private_endpoint_service_endpoints_enabled = bool
  }))
  default = {
    /*  "wl-vnet-subnet-01" = {
      name                                       = "wl-vnet-subnet-01"
      address_prefixes                           = ["10.0.125.32/27"]
      service_endpoints                          = ["Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = true
      private_endpoint_service_endpoints_enabled = true
    } */
  }
}

variable "wl_vnet_subnet_service_endpoints" {
  description = "The service endpoints of the workload virtual network subnets."
  type        = list(string)
  default     = null
}

variable "wl_nsg_rules" {
  description = "A list of network security group rules to add to the workload virtual network subnets."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_ranges    = list(string)
    source_address_prefixes    = list(string)
    destination_address_prefix = string
  }))
  default = null
}

variable "deployed_to_hub_subscription" {
  description = "If set to true, will deploy the workload to the hub subscription."
  type        = bool
  default     = null
}

variable "deny_all_inbound" {
  description = "If set to true, will deny all inbound traffic to the workload."
  type        = bool
  default     = null
}

variable "enable_forced_tunneling_on_route_table" {
  description = "If set to true, will enable forced tunneling on the route tables."
  type        = bool
  default     = null
}

#############################
## Peering Configuration  ###
#############################

variable "allow_virtual_spoke_network_access" {
  description = "If set to true, will allow the virtual spoke network to access the workload."
  type        = bool
  default     = null
}

variable "allow_forwarded_spoke_traffic" {
  description = "Option allow_forwarded_traffic for the spoke vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = null
}

variable "allow_gateway_spoke_transit" {
  description = "Option allow_gateway_transit for the spoke vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = null
}

variable "use_remote_spoke_gateway" {
  description = "Option use_remote_gateway for the spoke vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = null
}