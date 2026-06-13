variable "project_name" {
  description = "Short project identifier used in resource names."
  type        = string
}

variable "environment" {
  description = "Deployment environment, for example dev, test, or prod."
  type        = string
}

variable "primary_location" {
  description = "Azure region for the primary deployment."
  type        = string
}

variable "replica_location" {
  description = "Azure region for the PostgreSQL read replica deployment."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all supported resources."
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Optional explicit resource group name. Leave null to let Terraform derive one."
  type        = string
  default     = null
}

variable "primary_vnet_cidr" {
  description = "Address space for the primary region virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "primary_aks_subnet_cidr" {
  description = "CIDR block for the AKS subnet in the primary region."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "primary_postgres_subnet_cidr" {
  description = "CIDR block for the delegated PostgreSQL subnet in the primary region."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "primary_private_endpoints_subnet_cidr" {
  description = "Reserved subnet for future private endpoints or shared platform services in the primary region."
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "replica_vnet_cidr" {
  description = "Address space for the replica region virtual network."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "replica_postgres_subnet_cidr" {
  description = "CIDR block for the delegated PostgreSQL subnet in the replica region."
  type        = list(string)
  default     = ["10.1.2.0/24"]
}

variable "replica_private_endpoints_subnet_cidr" {
  description = "Reserved subnet for future private endpoints or DR helper services in the replica region."
  type        = list(string)
  default     = ["10.1.3.0/24"]
}

variable "aks_kubernetes_version" {
  description = "Optional AKS Kubernetes version. Leave null for Azure to choose the default supported version."
  type        = string
  default     = null
}

variable "aks_node_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_node_pool_name" {
  description = "System node pool name."
  type        = string
  default     = "system"
}

variable "aks_node_min_count" {
  description = "Minimum node count for the AKS system node pool."
  type        = number
  default     = 1
}

variable "aks_node_max_count" {
  description = "Maximum node count for the AKS system node pool."
  type        = number
  default     = 3
}

variable "aks_os_disk_size_gb" {
  description = "OS disk size in GB for AKS system nodes."
  type        = number
  default     = 128
}

variable "aks_sku_tier" {
  description = "AKS control plane SKU tier."
  type        = string
  default     = "Free"
}

variable "aks_authorized_ip_ranges" {
  description = "Public CIDR ranges allowed to reach the AKS API server. If empty, the public API is reachable from any public IP."
  type        = list(string)
  default     = []
}

variable "aks_service_cidr" {
  description = "CIDR used by Kubernetes services."
  type        = string
  default     = "172.16.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "Cluster DNS service IP. Must fall within aks_service_cidr."
  type        = string
  default     = "172.16.0.10"
}

variable "aks_pod_cidr" {
  description = "Pod CIDR for Azure CNI Overlay."
  type        = string
  default     = "192.168.0.0/16"
}

variable "postgres_version" {
  description = "PostgreSQL major version."
  type        = string
  default     = "16"
}

variable "postgres_admin_username" {
  description = "Administrator username for the PostgreSQL Flexible Server primary."
  type        = string
}

variable "postgres_admin_password" {
  description = "Administrator password for the PostgreSQL Flexible Server primary."
  type        = string
  sensitive   = true
}

variable "postgres_database_name" {
  description = "Application database created on the primary server."
  type        = string
  default     = "appdb"
}

variable "postgres_sku_name" {
  description = "PostgreSQL Flexible Server SKU."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "Allocated storage for PostgreSQL Flexible Server in MB."
  type        = number
  default     = 32768
}

variable "postgres_backup_retention_days" {
  description = "Backup retention window in days."
  type        = number
  default     = 7
}

variable "postgres_geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backups on the primary when supported in the selected region and SKU."
  type        = bool
  default     = false
}

variable "postgres_zone" {
  description = "Optional availability zone for the primary PostgreSQL server."
  type        = string
  default     = null
}

variable "postgres_replica_zone" {
  description = "Optional availability zone for the replica PostgreSQL server."
  type        = string
  default     = null
}

variable "postgres_storage_autogrow_enabled" {
  description = "Enable storage autogrow for the primary and replica."
  type        = bool
  default     = true
}

variable "postgres_ha_enabled" {
  description = "Enable zone-redundant HA on the primary server. Disabled by default to keep dev costs down."
  type        = bool
  default     = false
}

variable "postgres_ha_standby_availability_zone" {
  description = "Standby availability zone to use when postgres_ha_enabled is true."
  type        = string
  default     = null
}

variable "log_analytics_sku" {
  description = "Log Analytics workspace SKU."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_days" {
  description = "Log Analytics workspace retention in days."
  type        = number
  default     = 30
}
