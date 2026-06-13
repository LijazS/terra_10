locals {
  name_prefix = substr(replace(lower("${var.project_name}-${var.environment}"), "/[^0-9a-z-]/", ""), 0, 40)

  common_tags = merge(
    {
      project     = var.project_name
      environment = var.environment
      managed_by  = "terraform"
    },
    var.tags
  )

  resource_group_name = coalesce(var.resource_group_name, "${local.name_prefix}-rg")
}

module "resource_group" {
  source = "./modules/resource-group"

  name     = local.resource_group_name
  location = var.primary_location
  tags     = local.common_tags
}

module "network_primary" {
  source = "./modules/network-primary"

  project_name                   = var.project_name
  environment                    = var.environment
  resource_group_name            = module.resource_group.name
  location                       = var.primary_location
  vnet_address_space             = var.primary_vnet_cidr
  aks_subnet_address_prefixes    = var.primary_aks_subnet_cidr
  postgres_subnet_address_prefix = var.primary_postgres_subnet_cidr
  private_endpoints_subnet_cidr  = var.primary_private_endpoints_subnet_cidr
  replica_postgres_subnet_cidr   = var.replica_postgres_subnet_cidr[0]
  tags                           = local.common_tags
}

module "network_replica" {
  source = "./modules/network-replica"

  project_name                   = var.project_name
  environment                    = var.environment
  resource_group_name            = module.resource_group.name
  location                       = var.replica_location
  vnet_address_space             = var.replica_vnet_cidr
  postgres_subnet_address_prefix = var.replica_postgres_subnet_cidr
  private_endpoints_subnet_cidr  = var.replica_private_endpoints_subnet_cidr
  primary_vnet_id                = module.network_primary.vnet_id
  primary_vnet_name              = module.network_primary.vnet_name
  primary_vnet_address_space     = var.primary_vnet_cidr
  tags                           = local.common_tags
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = "${local.name_prefix}.postgres.database.azure.com"
  resource_group_name = module.resource_group.name
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "primary" {
  name                  = "${local.name_prefix}-primary-link"
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.network_primary.vnet_id
  tags                  = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "replica" {
  name                  = "${local.name_prefix}-replica-link"
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.network_replica.vnet_id
  tags                  = local.common_tags
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name        = var.project_name
  environment         = var.environment
  resource_group_name = module.resource_group.name
  location            = var.primary_location
  log_analytics_sku   = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days
  tags                = local.common_tags
}

module "aks" {
  source = "./modules/aks"

  project_name               = var.project_name
  environment                = var.environment
  resource_group_name        = module.resource_group.name
  location                   = var.primary_location
  kubernetes_version         = var.aks_kubernetes_version
  sku_tier                   = var.aks_sku_tier
  authorized_ip_ranges       = var.aks_authorized_ip_ranges
  node_pool_name             = var.aks_node_pool_name
  node_vm_size               = var.aks_node_vm_size
  node_min_count             = var.aks_node_min_count
  node_max_count             = var.aks_node_max_count
  os_disk_size_gb            = var.aks_os_disk_size_gb
  aks_subnet_id              = module.network_primary.aks_subnet_id
  service_cidr               = var.aks_service_cidr
  dns_service_ip             = var.aks_dns_service_ip
  pod_cidr                   = var.aks_pod_cidr
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  tags                       = local.common_tags
}

module "postgres_primary" {
  source = "./modules/postgres-primary"

  project_name                   = var.project_name
  environment                    = var.environment
  resource_group_name            = module.resource_group.name
  location                       = var.primary_location
  delegated_subnet_id            = module.network_primary.postgres_subnet_id
  private_dns_zone_id            = azurerm_private_dns_zone.postgres.id
  admin_username                 = var.postgres_admin_username
  admin_password                 = var.postgres_admin_password
  database_name                  = var.postgres_database_name
  postgres_version               = var.postgres_version
  sku_name                       = var.postgres_sku_name
  storage_mb                     = var.postgres_storage_mb
  backup_retention_days          = var.postgres_backup_retention_days
  geo_redundant_backup_enabled   = var.postgres_geo_redundant_backup_enabled
  zone                           = var.postgres_zone
  storage_autogrow_enabled       = var.postgres_storage_autogrow_enabled
  high_availability_enabled      = var.postgres_ha_enabled
  high_availability_standby_zone = var.postgres_ha_standby_availability_zone
  log_analytics_workspace_id     = module.monitoring.log_analytics_workspace_id
  tags                           = local.common_tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.primary
  ]
}

module "postgres_replica" {
  source = "./modules/postgres-replica"

  project_name               = var.project_name
  environment                = var.environment
  resource_group_name        = module.resource_group.name
  location                   = var.replica_location
  delegated_subnet_id        = module.network_replica.postgres_subnet_id
  private_dns_zone_id        = azurerm_private_dns_zone.postgres.id
  source_server_id           = module.postgres_primary.server_id
  sku_name                   = var.postgres_sku_name
  storage_mb                 = var.postgres_storage_mb
  zone                       = var.postgres_replica_zone
  storage_autogrow_enabled   = var.postgres_storage_autogrow_enabled
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  tags                       = local.common_tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.replica,
    module.postgres_primary
  ]
}
