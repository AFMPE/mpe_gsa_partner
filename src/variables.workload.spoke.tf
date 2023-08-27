# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################
# Hub Configuration ###
#######################

variable "hub_virtual_network_id" {
  description = "The ID of the hub virtual network."
  type        = string
  default     = null
}

variable "hub_firewall_private_ip_address" {
  description = "The private IP address of the hub firewall."
  type        = string
  default     = null
}

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

variable "wl_vnet_subnets" {
  description = "A list of subnets to add to the workload virtual network"
  default = {}
}

variable "wl_route_table_routes" {
  description = "A list of routes to add to the workload virtual network route tables."
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = null
}

variable "wl_private_dns_zones" {
  description = "The private DNS zones of the workload virtual network."
  type        = list(string)
  default     = []
}

variable "deployed_to_hub_subscription" {
  description = "If set to true, will deploy the workload to the hub subscription."
  type        = bool
  default     = null
}

variable "enable_forced_tunneling_on_route_table" {
  description = "If set to true, will enable forced tunneling on the route tables."
  type        = bool
  default     = null
}

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for NSG Flow Logs"
  type        = bool
  default     = false
}

#############################
## Peering Configuration  ###
#############################

variable "use_source_remote_spoke_gateway" {
  description = "Option use_remote_gateway for the spoke vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = null
}
