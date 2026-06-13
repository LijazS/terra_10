locals {
  name_prefix = substr(replace(lower("${var.project_name}-${var.environment}"), "/[^0-9a-z-]/", ""), 0, 40)
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${local.name_prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}
