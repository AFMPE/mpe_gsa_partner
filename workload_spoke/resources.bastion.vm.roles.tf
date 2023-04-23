resource "azurerm_role_assignment" "virtual_machine_admins" {
  for_each             = toset(local.virtual_machine_admins)
  scope                = module.mod_workload_network.spoke_resource_group_name
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "virtual_machine_users" {
  for_each             = toset(var.virtual_machine_users)
  scope                = module.mod_workload_network.spoke_resource_group_name
  role_definition_name = "Virtual Machine User Login"
  principal_id         = data.azurerm_client_config.current.object_id
}