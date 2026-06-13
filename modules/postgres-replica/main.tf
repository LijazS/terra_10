locals {
  name_prefix = substr(replace(lower("${var.project_name}-${var.environment}"), "/[^0-9a-z-]/", ""), 0, 40)
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                          = "${local.name_prefix}-pg-replica"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  create_mode                   = "Replica"
  source_server_id              = var.source_server_id
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  zone                          = var.zone
  sku_name                      = var.sku_name
  storage_mb                    = var.storage_mb
  storage_tier                  = "P4"
  public_network_access_enabled = false

  # Azure PostgreSQL Flexible Server replicas are asynchronous and read-only.
  # Promotion is a separate operation; after promotion, replication stops and the
  # promoted server becomes an independent read-write server.
  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_configuration" "storage_autogrow" {
  name      = "storage_autogrow"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = var.storage_autogrow_enabled ? "on" : "off"
}

data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = azurerm_postgresql_flexible_server.this.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = "${local.name_prefix}-pg-replica-diag"
  target_resource_id             = azurerm_postgresql_flexible_server.this.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.log_category_types)

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.metrics)

    content {
      category = metric.value
      enabled  = true
    }
  }
}
