# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_resource_group" "hub_rg" {
  provider = azurerm.hub_network
  name     = var.hub_rg_name
}

data "azurerm_virtual_network" "hub_vnet" {
  provider            = azurerm.hub_network
  name                = var.hub_vnet_name
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_firewall" "hub_fw" {
  provider            = azurerm.hub_network
  name                = var.hub_fw_name
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}
