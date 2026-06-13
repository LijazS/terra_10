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
  description = "Replica region for the PostgreSQL Flexible Server."
  type        = string
}

variable "delegated_subnet_id" {
  description = "Delegated subnet ID for the replica."
  type        = string
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID used by the replica."
  type        = string
}

variable "source_server_id" {
  description = "Primary PostgreSQL Flexible Server ID."
  type        = string
}

variable "sku_name" {
  description = "Replica PostgreSQL SKU."
  type        = string
}

variable "storage_mb" {
  description = "Replica allocated storage in MB."
  type        = number
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

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID."
  type        = string
}

variable "tags" {
  description = "Tags applied to the PostgreSQL resources."
  type        = map(string)
  default     = {}
}
