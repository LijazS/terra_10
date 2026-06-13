output "resource_group_name" {
  description = "Resource group containing the platform resources."
  value       = module.resource_group.name
}

output "primary_vnet_name" {
  description = "Primary region virtual network name."
  value       = module.network_primary.vnet_name
}

output "replica_vnet_name" {
  description = "Replica region virtual network name."
  value       = module.network_replica.vnet_name
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = module.aks.cluster_name
}

output "aks_public_api_server_fqdn" {
  description = "AKS public API server FQDN."
  value       = module.aks.fqdn
}

output "aks_kubeconfig_command" {
  description = "Command to merge AKS credentials into the local kubeconfig."
  value       = "az aks get-credentials --resource-group ${module.resource_group.name} --name ${module.aks.cluster_name} --overwrite-existing"
}

output "postgres_primary_server_name" {
  description = "Primary PostgreSQL Flexible Server name."
  value       = module.postgres_primary.server_name
}

output "postgres_primary_private_fqdn" {
  description = "Primary PostgreSQL Flexible Server private FQDN."
  value       = module.postgres_primary.fqdn
}

output "postgres_replica_server_name" {
  description = "Replica PostgreSQL Flexible Server name."
  value       = module.postgres_replica.server_name
}

output "postgres_replica_private_fqdn" {
  description = "Replica PostgreSQL Flexible Server private FQDN."
  value       = module.postgres_replica.fqdn
}

output "postgres_database_name" {
  description = "Application database created on the primary server."
  value       = module.postgres_primary.database_name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID."
  value       = module.monitoring.log_analytics_workspace_id
}

output "aks_api_server_exposure_note" {
  description = "Security reminder for AKS API server exposure."
  value       = length(var.aks_authorized_ip_ranges) == 0 ? "AKS API server is publicly reachable from any public IP because aks_authorized_ip_ranges is empty." : "AKS API server is restricted to the configured aks_authorized_ip_ranges."
}
