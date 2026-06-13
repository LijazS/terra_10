locals {
  name_prefix = substr(replace(lower("${var.project_name}-${var.environment}"), "/[^0-9a-z-]/", ""), 0, 40)
}

resource "azurerm_virtual_network" "this" {
  name                = "${local.name_prefix}-vnet-replica"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "postgres" {
  name                 = "${local.name_prefix}-snet-pg-replica"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.postgres_subnet_address_prefix

  delegation {
    name = "postgres-flexible-server"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "${local.name_prefix}-snet-private-replica"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.private_endpoints_subnet_cidr

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_virtual_network_peering" "primary_to_replica" {
  name                         = "${local.name_prefix}-peer-primary-to-replica"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.primary_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "replica_to_primary" {
  name                         = "${local.name_prefix}-peer-replica-to-primary"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = var.primary_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
