module "module_azurerm_public_ip" {
  for_each = local.public_ips

  source = "./Modules/"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name              = each.value.name
  allocation_method = each.value.allocation_method
  sku               = each.value.sku
}

output "public_ips" {
  value = var.enable_module_output ? module.module_azurerm_public_ip[*] : null
}


module "module_azurerm_resource_group" {
  for_each = local.resource_groups

  source = "./Modules"

  name     = each.value.name
  location = each.value.location
}

output "resource_groups" {
  value = var.enable_module_output ? module.module_azurerm_resource_group[*] : null
}