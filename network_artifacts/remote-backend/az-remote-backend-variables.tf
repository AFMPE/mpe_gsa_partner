# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Organization name
variable "org_name" {
  type        = string
  description = "mpe"
  default     = "afmpe-gsa"
}
# Environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "prod"
}
# Azure region
variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "eastus"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = "<<subid>>"
  sensitive   = true
}
