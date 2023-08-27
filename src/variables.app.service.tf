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
    workload_name                 = string
    create_app_service_plan       = bool
    app_service_name              = string
    app_service_plan_sku_name     = string
    app_service_resource_type     = string
    app_service_plan_os_type      = string
    deployment_slot_count         = number
    website_run_from_package      = optional(string)
    app_service_plan_worker_count = optional(number)
    create_app_keyvault           = optional(bool)
    site_config = object({
      always_on = optional(bool)
      application_stack = optional(object({
        current_stack                = optional(string)
        docker_container_name        = optional(string)
        docker_container_registry    = optional(string)
        docker_container_tag         = optional(string)
        dotnet_version               = optional(string)
        dotnet_core_version          = optional(string)
        tomcat_version               = optional(string)
        java_embedded_server_enabled = optional(bool)
        java_version                 = optional(string)
        node_version                 = optional(string)
        php_version                  = optional(string)
        python                       = optional(bool)
      }))
      container_registry_use_managed_identity = optional(bool)
      ftps_state                              = optional(string)
      health_check_path                       = optional(string)
      health_check_eviction_time_in_min       = optional(number)
      http2_enabled                           = optional(bool)
      minimum_tls_version                     = optional(string)
      remote_debugging_enabled                = optional(bool)
      remote_debugging_version                = optional(string)
      net_framework_version                   = optional(string)
      php_version                             = optional(string)
      python_version                          = optional(string)
      use_32_bit_worker                       = optional(bool)
      websockets_enabled                      = optional(bool)
    })
    create_app_container_registry = optional(bool)
    enable_acr_private_endpoint   = optional(bool)
  }))
  default = null
}

