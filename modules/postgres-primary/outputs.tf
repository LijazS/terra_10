output "server_id" {
  description = "Primary PostgreSQL Flexible Server ID."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "server_name" {
  description = "Primary PostgreSQL Flexible Server name."
  value       = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  description = "Primary PostgreSQL Flexible Server FQDN."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  description = "Database name created on the primary server."
  value       = azurerm_postgresql_flexible_server_database.this.name
}
