resource "azurerm_public_ip" "public_ip" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.name
  allocation_method   = var.allocation_method
  sku                 = var.sku

  tags = var.tags
}

output "public_ip" {
  value = azurerm_public_ip.public_ip
}


resource "azurerm_resource_group" "resource_group" {

  name     = var.name
  location = var.location

  tags = var.tags
}

output "resource_group" {
  value = azurerm_resource_group.resource_group
}