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