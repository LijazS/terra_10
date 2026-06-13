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
  description = "Azure region for the primary network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the primary virtual network."
  type        = list(string)
}

variable "aks_subnet_address_prefixes" {
  description = "AKS subnet CIDR blocks."
  type        = list(string)
}

variable "postgres_subnet_address_prefix" {
  description = "Delegated PostgreSQL subnet CIDR blocks."
  type        = list(string)
}

variable "private_endpoints_subnet_cidr" {
  description = "Reserved private endpoints subnet CIDR blocks."
  type        = list(string)
}

variable "replica_postgres_subnet_cidr" {
  description = "Replica PostgreSQL subnet CIDR block used in NSG allow rules."
  type        = string
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}
