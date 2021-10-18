#specify the backend
terraform {
  backend "azurerm" {
    storage_account_name = "storagephswmdag"
    container_name       = "terraformstate"
    key                  = "prod.terraform.tfstate"
    access_key           = ${{secrets.TF_ARM_ACCESS_KEY_SECRET}}
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


