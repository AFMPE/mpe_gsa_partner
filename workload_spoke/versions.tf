# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Mission Partner Environment Service Alerts
DESCRIPTION: The following components will be options in this deployment
              * Service Alerts
AUTHOR/S: jspinella
*/



# Configure the minimum required providers supported by this module
terraform {
  # It is recommended to use remote state instead of local
  backend "azurerm" {
    key = "afmpe-workload-spoke"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.36"
    }
  }

  required_version = ">= 1.3"
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "hub_network"
  subscription_id = var.hub_subscription_id
  features {}
}
