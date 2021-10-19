
locals {
  resource_group = var.resource_group_name
  managed_resource_group_name = "mg-rg-dw-${var.environment_name}"
}


# Get the storage account for Synapse
data "azurerm_storage_account" "this" {
  name                = var.storage_account
  resource_group_name = local.resource_group
}

# Create the container
resource "azurerm_storage_data_lake_gen2_filesystem" "st" {
  name               = "${var.environment_name}-container"
  storage_account_id = data.azurerm_storage_account.this.id
}



# Create Synapse workspace
resource "azurerm_synapse_workspace" "ws" {
  name                                 = var.syn_ws_name
  resource_group_name                  = local.resource_group
  managed_resource_group_name          = local.managed_resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.st.id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = random_password.sql_administrator.result
  tags                                 = var.tags
  sql_identity_control_enabled         = true
  managed_virtual_network_enabled      = var.managed_virtual_network_enabled  

    aad_admin  {
                login     = var.aad_admin.login
                object_id = var.aad_admin.object_id
                tenant_id = var.aad_admin.tenant_id
            }      
}


resource "azurerm_synapse_firewall_rule" "this" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.ws.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}


resource "random_password" "sql_administrator" {
  length      = 32
  upper       = true
  min_upper   = 1
  lower       = true
  min_lower   = 1
  number      = true
  min_numeric = 1
  special     = false
  min_special = 0

  keepers = {
    change-me = var.psql_administrator_password_keeper
  }
}


resource "azurerm_synapse_managed_private_endpoint" "this" {
  count = var.managed_virtual_network_enabled ?1:0
  name                 = "${var.storage_account}-endpoint"
  synapse_workspace_id = azurerm_synapse_workspace.ws.id
  target_resource_id   = data.azurerm_storage_account.this.id
  subresource_name     = "blob"

  depends_on = [azurerm_synapse_firewall_rule.this]
}
