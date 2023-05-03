# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################
# Global Configuration
#######################

variable "required" {
  description = "A map of required variables for the deployment"
  default     = null
}

variable "default_tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}

variable "subscription_id" {
  description = "The Azure Subscription ID where the resources in this module should be deployed."
  type        = string
}

variable "hub_subscription_id" {
  description = "The Azure Subscription ID where the hub resources are deployed."
  type        = string
}

variable "hub_rg_name" {
  description = "The name of the resource group in which the hub resources are deployed."
  type        = string
}

variable "hub_vnet_name" {
  description = "The name of the hub virtual network."
  type        = string
}

variable "hub_fw_name" {
  description = "The name of the hub firewall."
  type        = string
}

variable "location" {
  type        = string
  description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
  default     = null
}

variable "backend_key" {
  description = "The key to use for the backend state."
  type        = string
  default     = null
}

variable "disable_telemetry" {
  description = "If set to true, will disable the telemetry sent as part of the module."
  type        = string
  default     = false
}

#################################
# Resource Lock Configuration
#################################

variable "enable_resource_locks" {
  type        = bool
  description = "If set to true, will enable resource locks for all resources deployed by this module where supported."
  default     = null
}

variable "lock_level" {
  description = "The level of lock to apply to the resources. Valid values are CanNotDelete, ReadOnly, or NotSpecified."
  type        = string
  default     = "CanNotDelete"
}




