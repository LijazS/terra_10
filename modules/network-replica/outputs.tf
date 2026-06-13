output "vnet_id" {
  description = "Replica VNet resource ID."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Replica VNet name."
  value       = azurerm_virtual_network.this.name
}

output "postgres_subnet_id" {
  description = "Replica PostgreSQL delegated subnet resource ID."
  value       = azurerm_subnet.postgres.id
}

output "private_endpoints_subnet_id" {
  description = "Reserved private endpoints subnet resource ID."
  value       = azurerm_subnet.private_endpoints.id
}
