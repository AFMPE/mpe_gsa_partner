# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*  
SUMMARY:  Module to deploy a Bastion Jumpbox
DESCRIPTION: This module deploys a Bastion Jumpbox to the Hub Network
AUTHOR/S: jspinella
*/

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

resource "azurerm_network_interface" "bastion_jumpbox_nic" {
  name                = "ampe-gsa-eus-dev-bas-nic"
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = "ampe-gsa-eus-dev-rg" #module.mod_workload_network.0.resource_group_name

  ip_configuration {
    name                          = "bastion-jumpbox-ipconfig"
    subnet_id                     = "/subscriptions/65798e1e-c177-4373-ac3b-921f11f737c8/resourceGroups/ampe-gsa-eus-dev-rg/providers/Microsoft.Network/virtualNetworks/ampe-gsa-eus-dev-vnet/subnets/ampe-gsa-eus-dev-snet"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "bastion_jumpbox_vm" {
  name                = "ampe-gsa-eus-dev-bas-vm"
  resource_group_name = "ampe-gsa-eus-dev-rg" #module.mod_workload_network.0.resource_group_name
  location            = module.mod_azure_region_lookup.location_cli
  computer_name       = "mpegsadevbasvm"
  size                = var.bastion_vm_size
  admin_username      = var.bastion_admin_username
  admin_password      = var.bastion_admin_password

  network_interface_ids = [
    azurerm_network_interface.bastion_jumpbox_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_schedule" {
  virtual_machine_id    = azurerm_windows_virtual_machine.bastion_jumpbox_vm.id
  location              = module.mod_azure_region_lookup.location_cli
  enabled               = true
  daily_recurrence_time = "2000"
  timezone              = "SA Eastern Standard Time"
  notification_settings {
    enabled = false
  }
}
