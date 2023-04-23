# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

variable "virtual_machine_admins" {
  description = "Optional list of Azure Active Directory object IDs to assign the Virtual Machine Administrator Login role."
  type        = list(string)
  default     = []
}

variable "virtual_machine_users" {
  description = "List of Azure Active Directory object IDs to assign the Virtual Machine User Login role."
  type        = list(string)
  default     = []
}

variable "bastion_vm_size" {
  description = "The size of the virtual machine to deploy for the bastion host."
  type        = string
  default     = "Standard_F2"
}

variable "bastion_admin_username" {
  description = "The admin username to use for the bastion host."
  type        = string
  default     = "mpeadminuser"
}

variable "bastion_admin_password" {
  description = "The admin password to use for the bastion host."
  type        = string
  default     = "Mpe@2020"
}