output "server_id" {
  description = "Replica PostgreSQL Flexible Server ID."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "server_name" {
  description = "Replica PostgreSQL Flexible Server name."
  value       = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  description = "Replica PostgreSQL Flexible Server FQDN."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}
