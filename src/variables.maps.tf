# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
# Azure Maps Configuration         ##
#####################################

variable "maps_sku" {
  description = "The SKU of the Azure Maps account."
  type        = string
  default     = "S0"
}

variable "maps_storage_units" {
  description = "The number of storage units for the Azure Maps account."
  type        = number
  default     = 1
}
