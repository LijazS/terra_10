variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Primary region for the PostgreSQL Flexible Server."
  type        = string
}

variable "delegated_subnet_id" {
  description = "Delegated subnet ID for the PostgreSQL Flexible Server."
  type        = string
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID used by the server."
  type        = string
}

variable "admin_username" {
  description = "Administrator login."
  type        = string
}

variable "admin_password" {
  description = "Administrator password."
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Application database name."
  type        = string
}

variable "postgres_version" {
  description = "PostgreSQL major version."
  type        = string
}

variable "sku_name" {
  description = "PostgreSQL SKU."
  type        = string
}

variable "storage_mb" {
  description = "Allocated storage in MB."
  type        = number
}

variable "backup_retention_days" {
  description = "Backup retention window in days."
  type        = number
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backup."
  type        = bool
}

variable "zone" {
  description = "Optional availability zone."
  type        = string
  default     = null
}

variable "storage_autogrow_enabled" {
  description = "Enable storage autogrow."
  type        = bool
}

variable "high_availability_enabled" {
  description = "Enable HA."
  type        = bool
}

variable "high_availability_standby_zone" {
  description = "Standby zone when HA is enabled."
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID."
  type        = string
}

variable "tags" {
  description = "Tags applied to the PostgreSQL resources."
  type        = map(string)
  default     = {}
}
