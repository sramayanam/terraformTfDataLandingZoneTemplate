data "azurerm_storage_account" "this" {
  name                = var.storage_account
  resource_group_name = var.resource_group_name
}

resource "azurerm_data_factory" "this" {
  name                            = var.adfname
  location                        = var.location
  resource_group_name             = var.resource_group_name
  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  tags                            = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "data_lake_contributor_adf" {
  scope                = data.azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "contributor" {
  scope                = azurerm_data_factory.this.id
  role_definition_name = "Contributor"
  principal_id         = var.principalname
}

resource "azurerm_role_assignment" "reader" {
  scope                = azurerm_data_factory.this.id
  role_definition_name = "Reader"
  principal_id         = var.principalname
}

resource "azurerm_role_assignment" "rg_data_factory_contributor" {
  scope                = azurerm_data_factory.this.id
  role_definition_name = "Data Factory Contributor"
  principal_id         = var.principalname
}

