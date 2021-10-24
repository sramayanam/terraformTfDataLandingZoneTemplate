#specify the backend
terraform {
  backend "azurerm" {
    storage_account_name = "storagephswmdag"
    container_name       = "terraformstate"
    key                  = "prod.terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  # Configuration options
  skip_provider_registration = true
  features {

  }
}

#Resource block
data "azurerm_resource_group" "rg_labs" {
  name = "rgTerraformLabs"
}


data "azurerm_storage_account" "str_StateStore" {
  name                = "storagephswmdag"
  resource_group_name = data.azurerm_resource_group.rg_labs.name

  depends_on = [
    data.azurerm_resource_group.rg_labs
  ]

}


data "azurerm_public_ip" "pip" {
  name                = "pipubuntuvm"
  resource_group_name = data.azurerm_resource_group.rg_labs.name

  depends_on = [
    data.azurerm_resource_group.rg_labs
  ]
}

module "vnet" {
  source = "./Modules/Network/VirtualNetwork"
  depends_on = [
    module.nsg
  ]
  location    = var.location
  environment = local.environment
  rg_name     = var.rg_name
  nsg_id      = module.nsg.id_out
}

module "nsg" {
  source      = "./Modules/Network/NetworkSecurityGroup"
  location    = var.location
  environment = var.environment
  rg_name     = var.rg_name
  port        = 22
}

module "vm" {
  source      = "./Modules/Compute/VirtualMachines"
  location    = var.location
  environment = local.environment
  rg_name     = var.rg_name
  vm_name     = var.vm_name
  subnet      = module.vnet.subnet_id
  password    = data.azurerm_key_vault_secret.main.value
  user        = local.vm.user_name
}

locals {
  environment = var.environment
  vm = {
    computer_name = var.vm_name
    user_name     = "admin1234"
  }
}

data "azurerm_key_vault_secret" "main" {
  name         = var.admin_pw_name
  key_vault_id = var.key_vault_resource_id
}

resource "azurerm_eventhub_namespace" "ehnamespace" {
  name                = "srramsampleeh"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg_labs.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventhub" "ehub1" {
  name                = "sourceeventhub"
  namespace_name      = azurerm_eventhub_namespace.ehnamespace.name
  resource_group_name = data.azurerm_resource_group.rg_labs.name
  partition_count     = 8
  message_retention   = 7
}

module "adf" {
  source = "./Modules/DataAnalytics/DataFactory"
  resource_group_name = data.azurerm_resource_group.rg_labs.name
  location = var.location
  storage_account = data.azurerm_storage_account.str_StateStore.name
  managed_virtual_network_enabled = true
  adfname="srramadf1"
  principalname="343cae81-324c-4884-a60d-edf2be058107"
    tags = {
    environment = local.environment
  }
}

module "synapse" {
  source = "./Modules/DataAnalytics/DW"
  environment_name = local.environment
  resource_group_name = data.azurerm_resource_group.rg_labs.name
  location = var.location
  storage_account = data.azurerm_storage_account.str_StateStore.name
  database_pools = { sqlpool1 = { type = "sql", name = "sqlpool1", sku_name = "DW100c", create_mode = "Default" },sparkpool1 = { type = "spark", name = "sparkpool1" }}
  managed_virtual_network_enabled = true
  syn_ws_name = "srramswspc"
  tags = {
    environment = local.environment
  }
  aad_admin = {
        login = "eff3524e-fba8-45c6-ac3d-e502ec6af06e"
        object_id = "df467aeb-68b5-4550-9a82-4979cb3a1abb"
        tenant_id = "50460471-2197-4938-8e96-0708f3384c45"
    }
 }

 resource "azurerm_application_insights" "this" {
  name                = "workspace-example-ai"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg_labs.name
  application_type    = "web"
}

 resource "azurerm_machine_learning_workspace" "this" {
  name                    = "srramml-workspace"
  location                = var.location
  resource_group_name     = data.azurerm_resource_group.rg_labs.name
  application_insights_id = azurerm_application_insights.this.id
  key_vault_id            = var.key_vault_resource_id
  storage_account_id      = data.azurerm_storage_account.str_StateStore.id

  identity {
    type = "SystemAssigned"
  }

}


