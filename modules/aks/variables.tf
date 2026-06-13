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
  description = "Azure region for the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Optional Kubernetes version."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "AKS SKU tier."
  type        = string
}

variable "authorized_ip_ranges" {
  description = "Public CIDR ranges allowed to reach the AKS API server."
  type        = list(string)
}

variable "node_pool_name" {
  description = "Default node pool name."
  type        = string
}

variable "node_vm_size" {
  description = "VM size for the system node pool."
  type        = string
}

variable "node_min_count" {
  description = "Minimum node count."
  type        = number
}

variable "node_max_count" {
  description = "Maximum node count."
  type        = number
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
}

variable "aks_subnet_id" {
  description = "Subnet ID used by AKS nodes."
  type        = string
}

variable "service_cidr" {
  description = "Kubernetes service CIDR."
  type        = string
}

variable "dns_service_ip" {
  description = "DNS service IP."
  type        = string
}

variable "pod_cidr" {
  description = "Pod CIDR for Azure CNI Overlay."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Container Insights."
  type        = string
}

variable "tags" {
  description = "Tags applied to the AKS cluster."
  type        = map(string)
  default     = {}
}
