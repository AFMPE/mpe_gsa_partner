# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

variable "windows_distribution_name" {
  description = "The name of the Windows distribution to use for the Bastion VM."
  type        = string
  default     = "windows2019dc"
}

variable "virtual_machine_size" {
  description = "The size of the Bastion VM."
  type        = string
  default     = "Standard_B2s"
}

variable "vm_admin_username" {
  description = "The name of the administrator account for the Bastion VM."
  type        = string
  default     = "mpeazureadmin"
}

variable "vm_admin_password" {
  description = "The password for the administrator account for the Bastion VM."
  type        = string
}

variable "instances_count" {
  description = "The number of Bastion VM instances to deploy."
  type        = number
  default     = 1
}

variable "enable_proximity_placement_group" {
  description = "If set to true, will deploy a proximity placement group for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "enable_vm_availability_set" {
  description = "If set to true, will deploy an availability set for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "enable_public_ip_address" {
  description = "If set to true, will deploy a public IP address for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "existing_network_security_group_name" {
  description = "The name of an existing network security group to associate with the Bastion VM."
  type        = string
  default     = null
}
  
variable "nsg_inbound_rules" {
  description = "A list of inbound rules to associate with the network security group."  
  default = []
}

variable "enable_boot_diagnostics" {
  description = "If set to true, will enable boot diagnostics for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "data_disks" {
  description = "A list of data disks to attach to the Bastion VM."
  default = []
}

variable "deploy_log_analytics_agent" {
  description = "If set to true, will deploy the Log Analytics agent to the Bastion VM. Default is false."
  type        = bool
  default     = false
}

