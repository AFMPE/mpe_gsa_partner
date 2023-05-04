# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
# App Service Configuration        ##
#####################################

variable "ase_subnet_name" {
  description = "The name of the subnet to deploy the app service environment."
  type        = string
  default     = null
}


variable "app_service_apps" {
  description = "A list of apps to add to the app service environment."
  type = map(object({
    workload_name                = string
    app_service_name             = string
    app_service_plan_sku_name    = string
    enable_private_endpoint      = optional(bool)
    existing_private_dns_zone    = optional(string)
    create_app_service_plan      = bool
    health_check_path            = string
    application_stack            = string
    dotnet_version               = string
    private_endpoint_subnet_name = string
    deployment_slot_count        = number
    app_service_resource_type    = string
    app_service_plan_os_type     = string
  }))
  default = {}
}

