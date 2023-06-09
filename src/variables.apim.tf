# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
# API Management Configuration     ##
#####################################

variable "sku_tier" {
  description = "The tier of the API Management instance. Possible values are Developer, Basic, Standard, Premium, Consumption."
  type        = string
  default     = "Developer"
}
variable "sku_capacity" {
  description = "The capacity of the API Management instance. Possible values are positive integers from 1-12, except for Consumption tier where it is 0."
  type        = number
  default     = 1
}
variable "virtual_network_type" {
  description = "The type of the virtual network. Possible values are External, Internal, None."
  type        = string
  default     = "Internal"
}

variable "publisher_email" {
  description = "The email address of the publisher."
  type        = string
}

variable "publisher_name" {
  description = "The name of the publisher."
  type        = string
}

variable "enable_redis_cache" {
  description = "Enables a Redis Cache to be used with the API Management instance."
  type        = bool
  default     = false
}

variable "enable_user_identity" {
  description = "Enables a User Identity to be used with the API Management instance."
  type        = bool
  default     = false
}

variable "enable_app_insights" {
  description = "Enables an Application Insights instance to be used with the API Management instance."
  type        = bool
  default     = false
}

#####################################
# Networking Configuration         ## 
#####################################

variable "apim_subnet_name" {
  description = "Name of the subnet for the API Management"
  type        = string
}

variable "private_endpoint_subnet_prefix" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = []
}

variable "private_endpoint_subnet_name" {
  description = "Name of the subnet for the private endpoint"
  type        = string
}
