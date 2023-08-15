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

module "mod_bastion_virtual_machine" {
  source  = "azurenoops/overlays-virtual-machine/azurerm"
  version = ">=1.0.0"

  depends_on = [module.mod_workload_network]

  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = module.mod_workload_network.resource_group_name
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  workload_name                = "gsa-jmp"

  # Shared Services Network Configuration
  virtual_network_name = module.mod_workload_network.virtual_network_name
  subnet_name          = "ampe-eus-gsa-dev-vm-snet"

  # This module support multiple Pre-Defined windows and Windows Distributions.
  # Check the README.md file for more pre-defined images for Ubuntu, Centos, RedHat.
  # Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
  # Specify `disable_password_authentication = false` to create random admin password
  # Specify a valid password with `admin_password` argument to use your own password .  
  os_type                   = "windows"
  windows_distribution_name = var.windows_distribution_name
  virtual_machine_size      = var.virtual_machine_size
  admin_username            = var.vm_admin_username
  admin_password            = var.vm_admin_password
  instances_count           = var.instances_count # Number of VM's to be deployed

  # The proximity placement group, Availability Set, and assigning a public IP address to VMs are all optional.
  # If you don't wish to utilize these arguments, delete them from the module. 
  enable_proximity_placement_group = var.enable_proximity_placement_group
  enable_vm_availability_set       = var.enable_vm_availability_set
  enable_public_ip_address         = var.enable_public_ip_address

  # Network Seurity group port definitions for each Virtual Machine 
  # NSG association for all network interfaces to be added automatically.
  # Using 'existing_network_security_group_name' is supplied then the module will use the existing NSG.
  existing_network_security_group_name = "ampe-eus-gsa-dev-vm-nsg" #var.existing_network_security_group_name
  nsg_inbound_rules                    = var.nsg_inbound_rules

  # Boot diagnostics are used to troubleshoot virtual machines by default. 
  # To use a custom storage account, supply a valid name for'storage_account_name'. 
  # Passing a 'null' value will use a Managed Storage Account to store Boot Diagnostics.
  enable_boot_diagnostics = var.enable_boot_diagnostics

  # Attach a managed data disk to a Windows/windows virtual machine. 
  # Storage account types include: #'Standard_LRS', #'StandardSSD_ZRS', #'Premium_LRS', #'Premium_ZRS', #'StandardSSD_LRS', #'UltraSSD_LRS' (UltraSSD_LRS is only accessible in regions that support availability zones).
  # Create a new data drive - connect to the VM and execute diskmanagemnet or fdisk.
  data_disks = var.data_disks

  # (Optional) To activate Azure Monitoring and install log analytics agents 
  # (Optional) To save monitoring logs to storage, specify'storage_account_name'.    
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.hub_log.id

  # Deploy log analytics agents on a virtual machine. 
  # Customer id and primary shared key for Log Analytics workspace are required.
  deploy_log_analytics_agent                 = var.deploy_log_analytics_agent
  log_analytics_customer_id                  = data.azurerm_log_analytics_workspace.hub_log.workspace_id
  log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.hub_log.primary_shared_key

  # Adding additional TAG's to your Azure resources
  add_tags = {}
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_schedule" {
  virtual_machine_id    = module.mod_bastion_virtual_machine.windows_virtual_machine_ids[0] 
  location              = module.mod_azure_region_lookup.location_cli
  enabled               = true
  daily_recurrence_time = "2000"
  timezone              = "SA Eastern Standard Time"
  notification_settings {
    enabled = false
  }
}
