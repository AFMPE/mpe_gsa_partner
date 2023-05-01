
# Single Database
module "mod_gsa_sql" {
  depends_on = [
    module.mod_workload_network
  ]
  source  = "azurenoops/overlays-azsql/azurerm"
  version = "~> 0.2.3"

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_sql_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  existing_resource_group_name = "ampe-gsa-eus-dev-rg"
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  environment                  = var.required.environment
  workload_name                = "gsa"

  # The admin of the SQL Server. If you do not provide a password,
  # the module will generate a password for you.
  # The password must be at least 8 characters long and contain
  # characters from three of the following categories: English uppercase letters,
  # English lowercase letters, numbers (0-9), and non-alphanumeric characters (!, $, #, %, etc.).
  administrator_login = var.sql_admin_login

  # SQL server extended auditing policy defaults to `true`. 
  # To turn off set enable_sql_server_extended_auditing_policy to `false`  
  # DB extended auditing policy defaults to `false`. 
  # to tun on set the variable `enable_database_extended_auditing_policy` to `true` 
  # To enable Azure Defender for database set `enable_threat_detection_policy` to true 
  enable_threat_detection_policy = var.enable_threat_detection_policy

  # To create a database users set `create_databases_users` to `true`
  create_databases_users = var.create_databases_users

  # Firewall Rules to allow azure and external clients and specific Ip address/ranges. 
  enable_firewall_rules = var.enable_firewall_rules

  # Create a Elastic Pool. 
  # To create a database in the elastic pool set `enable_elastic_pool` to `true`
  enable_elastic_pool = var.enable_elastic_pool

  # schedule scan notifications to the subscription administrators
  # Manage Vulnerability Assessment set `enable_sql_vulnerability_assessment` to `true`
  enable_sql_vulnerability_assessment = var.enable_sql_vulnerability_assessment

  # Sql failover group creation. required secondary locaiton input. 
  enable_failover_group = var.enable_failover_group

  # Create a database.
  databases = var.sql_databases

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.sql.io` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  enable_private_endpoint = var.enable_private_endpoint
  existing_vnet_id        = module.mod_workload_network.virtual_network_id
  existing_subnet_id      = "/subscriptions/65798e1e-c177-4373-ac3b-921f11f737c8/resourceGroups/ampe-eus-gsa-dev-rg/providers/Microsoft.Network/virtualNetworks/ampe-eus-gsa-dev-vnet/subnets/ampe-eastus-gsa-pe-snet"

  # AD administrator for an Azure SQL server
  # Allows you to set a user or group as the AD administrator for an Azure SQL server
  ad_admin_login_name = var.ad_admin_login_name

  # (Optional) To enable Azure Monitoring for Azure SQL database including audit logs
  # Log Analytic workspace resource id required
  # (Optional) Specify `storage_account_id` to save monitoring logs to storage. 
  enable_log_monitoring = var.enable_log_monitoring

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
