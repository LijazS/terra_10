output "vnet_id" {
  description = "Primary VNet resource ID."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Primary VNet name."
  value       = azurerm_virtual_network.this.name
}

output "aks_subnet_id" {
  description = "AKS subnet resource ID."
  value       = azurerm_subnet.aks.id
}

output "postgres_subnet_id" {
  description = "Primary PostgreSQL delegated subnet resource ID."
  value       = azurerm_subnet.postgres.id
}

output "private_endpoints_subnet_id" {
  description = "Reserved private endpoints subnet resource ID."
  value       = azurerm_subnet.private_endpoints.id
}
