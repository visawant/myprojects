###############################################################################
#  VARIABLES DECLARATIONS #
###############################################################################

variable "AZ_LOCATION" {}
variable "AZ_RSG_NAME" {}
variable "AZ_AKV_NAME" {}
variable "AZ_TENANT_ID" {}
variable "AZ_DEVOPS_TEAMSERVICEPRINCIPAL_ID" {}
variable "AZ_AD_CONTRIBUTORRESOURCEGROUPID" {}

###############################################################################
#  PROVIDER SETUP  #
###############################################################################

# AZURE provider
provider "azurerm" {
  version = "~> 1.44"
}
# backend type only, remaining config specified in /environment/backend.cfg file
terraform {
  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

###############################################################################
#  KEY VAULT SETUP  #
###############################################################################

resource "azurerm_key_vault" "NETMGMT_KEYVAULT" {
  name                              = var.AZ_AKV_NAME
  location                          = var.AZ_LOCATION
  resource_group_name               = var.AZ_RSG_NAME
  tenant_id                         = var.AZ_TENANT_ID
  enabled_for_disk_encryption       = true
  enabled_for_template_deployment   = true

  sku_name = "standard"

}


resource "azurerm_key_vault_access_policy" "NETMGMT_KEYVAULT_POLICY_SP" {
  key_vault_id = azurerm_key_vault.NETMGMT_KEYVAULT.id

  tenant_id = var.AZ_TENANT_ID
  object_id = var.AZ_DEVOPS_TEAMSERVICEPRINCIPAL_ID

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update"
    ]
    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "encrypt",
      "get",
      "list",
      "update",
      "verify"
    ]
    secret_permissions = [
      "get",
      "list",
      "set"
    ]
}

resource "azurerm_key_vault_access_policy" "NETMGMT_KEYVAULT_POLICY_AD" {
  key_vault_id = azurerm_key_vault.NETMGMT_KEYVAULT.id

  tenant_id = var.AZ_TENANT_ID
  object_id = var.AZ_AD_CONTRIBUTORRESOURCEGROUPID

    certificate_permissions = [
      "backup",
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "purge",
      "recover",
      "restore",
      "setissuers",
      "update"
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey"
    ]
    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set"
    ]

    storage_permissions = [
      "backup",
      "delete",
      "deletesas",
      "get",
      "getsas",
      "list",
      "listsas",
      "purge",
      "recover",
      "regeneratekey",
      "restore",
      "set",
      "setsas",
      "update"
    ]
}
