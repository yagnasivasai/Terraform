variable "keyvault_role_assignment" {
    description = "value"
    type = set(string)
    default = [ "Key Vault Administrator","Key Vault Secrets Officer","Key Vault Reader","Key Vault Secrets User"] 
}