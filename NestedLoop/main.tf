provider "azure" {
  
}

## Use Case Provide Multiple principals to RBAC access to Keyvaults
resource "azurerm_role_assignment" "aasign-kv-role-to-terraform-agent" {
  scope = module.terraform-azurerm
}



