# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#########################
## SQL Configuration  ###
#########################

variable "sql_admin_login" {
  description = "The admin username to use for the SQL Server."
  type        = string
  default     = "admingsa"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "The admin password to use for the SQL Server."
  type        = string
  default     = "P@ssw0rd1234!"
  sensitive   = true
}

variable "ad_admin_login_name" {
  description = "The admin password to use for the SQL Server."
  type        = string
  default     = "gsa_admins@missionpartners.us"
  sensitive   = true
}

variable "sql_databases" {
  description = "List of databases to create."
  default     = []
}

variable "enable_threat_detection_policy" {
  description = "Enable Azure Defender for SQL Server"
  type        = bool
  default     = false
}

variable "create_databases_users" {
  description = "Create database users"
  type        = bool
  default     = false
}

variable "enable_firewall_rules" {
  description = "Enable Firewall Rules"
  type        = bool
  default     = false
}

variable "enable_elastic_pool" {
  description = "Enable Elastic Pool"
  type        = bool
  default     = false
}

variable "enable_sql_vulnerability_assessment" {
  description = "Enable SQL Vulnerability Assessment"
  type        = bool
  default     = false
}

variable "enable_failover_group" {
  description = "Enable SQL Failover Group"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable Private Endpoint"
  type        = bool
  default     = false
}

variable "enable_log_monitoring" {
  description = "Enable Azure Monitoring for Azure SQL database including audit logs"
  type        = bool
  default     = false
}




  