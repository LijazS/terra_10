output "cluster_name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_id" {
  description = "AKS cluster ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "fqdn" {
  description = "AKS API server public FQDN."
  value       = azurerm_kubernetes_cluster.this.fqdn
}
