locals {
  name_prefix = substr(replace(lower("${var.project_name}-${var.environment}"), "/[^0-9a-z-]/", ""), 0, 40)
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                          = "${local.name_prefix}-pg-primary"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.postgres_version
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  administrator_login           = var.admin_username
  administrator_password        = var.admin_password
  zone                          = var.zone
  storage_mb                    = var.storage_mb
  auto_grow_enabled             = var.storage_autogrow_enabled
  sku_name                      = var.sku_name
  backup_retention_days         = var.backup_retention_days
  geo_redundant_backup_enabled  = var.geo_redundant_backup_enabled
  public_network_access_enabled = false
  storage_tier                  = "P4"

  # HA is intentionally off by default to keep the dev footprint small.
  # For production, set postgres_ha_enabled = true and provide a standby zone.
  dynamic "high_availability" {
    for_each = var.high_availability_enabled ? [1] : []

    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = var.high_availability_standby_zone
    }
  }

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = azurerm_postgresql_flexible_server.this.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = "${local.name_prefix}-pg-primary-diag"
  target_resource_id             = azurerm_postgresql_flexible_server.this.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.log_category_types)

    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.metrics)

    content {
      category = enabled_metric.value
    }
  }
}
