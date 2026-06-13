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
  description = "Azure region for the replica network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the replica virtual network."
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

variable "primary_vnet_id" {
  description = "Resource ID of the primary virtual network."
  type        = string
}

variable "primary_vnet_name" {
  description = "Name of the primary virtual network."
  type        = string
}

variable "primary_vnet_address_space" {
  description = "Address space of the primary virtual network."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}
