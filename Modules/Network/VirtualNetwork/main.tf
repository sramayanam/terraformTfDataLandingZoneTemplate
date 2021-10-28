resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.0.0/24"
    security_group = var.nsg_id
  }

}


resource "azurerm_subnet" "snet-training" {
  name                                           = "snet-training"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = var.training_subnet_address_space
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "snet-aks" {
  name                                           = "snet-aks"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = var.aks_subnet_address_space
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "snet-workspace" {
  name                                           = "snet-workspace"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = var.ml_subnet_address_space
  enforce_private_link_endpoint_network_policies = true
}