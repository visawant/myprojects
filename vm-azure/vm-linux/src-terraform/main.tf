###############################################################################
#  VARIABLES DECLARATIONS #
###############################################################################

variable "AZ_LOCATION" {}
variable "AZ_RSG_NAME" {}
variable "AZ_SUB_NETMGMT_ID" {}
variable "AZ_VM_NAME" {}
variable "AZ_VM_ADMIN_USERNAME" {}
variable "AZ_AKV_ID" {}
variable "AZ_AKV_NAME" {}
#variable "AZ_STA_BOOT_DIAG_NAME" {}
#variable "AZ_STA_BOOT_DIAG_URI" {}

###############################################################################
#  PROVIDER SETUP  #
###############################################################################


# AZURE provider
provider "azurerm" {
  version = "~> 2.6.0"
  features {}
}
# backend type only, remaining config specified in /environment/backend.cfg file
terraform {
  backend "azurerm" { }
}

###############################################################################
#  KEY VAULT REFERENCE DATA  #
###############################################################################

data "azurerm_key_vault_secret" "DATA_AKV_SECRET_ADMINPWD" {
  name            = var.AZ_VM_ADMIN_USERNAME
  key_vault_id    = var.AZ_AKV_ID
}

###############################################################################
#  STORAGE ACCOUNT FOR BOOT DIAGNOSTICS  #
###############################################################################

#resource "azurerm_storage_account" "RES_STA_VM_NETMGMT_DIAG" {
#  name                      = var.AZ_STA_BOOT_DIAG_NAME
#  resource_group_name       = var.AZ_RSG_NAME
#  location                  = var.AZ_LOCATION
#  account_kind              = "Storage"
#  account_tier              = "Standard"
#  account_replication_type  = "LRS"
#  enable_https_traffic_only = true

#  lifecycle {
#    ignore_changes = [
#    # Ignore changes to tags, these are updated by an automation account
#      tags,
#    ]
#  } 
#}

###############################################################################
#  VIRTUAL MACHINE  #
###############################################################################

#--- NIC
resource "azurerm_network_interface" "RES_NIC_VM_NETMGMT" {
  name                            = "${var.AZ_VM_NAME}-interface0"
  location                        = var.AZ_LOCATION
  resource_group_name             = var.AZ_RSG_NAME
 
  ip_configuration {
    name                          = "${var.AZ_VM_NAME}-ip"
    subnet_id                     = var.AZ_SUB_NETMGMT_ID
    private_ip_address_allocation = "Dynamic"
  }
  
  lifecycle {
    ignore_changes = [
    # Ignore changes to tags, these are updated by an automation account
      tags,
    ]
  }  
}

#--- VM BASICS
resource "azurerm_virtual_machine" "RES_VM_NETMGMT" {
  name                              = var.AZ_VM_NAME
  location                          = var.AZ_LOCATION
  resource_group_name               = var.AZ_RSG_NAME
  network_interface_ids             = [azurerm_network_interface.RES_NIC_VM_NETMGMT.id]
  vm_size                           = "Standard_D2_v3"
  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true

  tags = {
    AutoShutdownSchedule  = "0:00 -> 23:59:59"
    # Initial value for Name is overridden by our automatic scheduled
    # re-tagging process; changes to this are ignored by ignore_changes
    # below.
    createdBy             = "placeholder"
    CreatedDate           = "placeholder"
    Environment           = "placeholder"
    SystemOwner           = "placeholder"
    DataClassification    = "Proprietary"
  }

  lifecycle {
    ignore_changes = [
#      tags ["createdBy"],
#      tags ["CreatedDate"],
#      tags ["Environment"],
#      tags ["SystemOwner"],
#      tags ["DataClassification"],
    ]
  }

#--- Base OS Image ---
   storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
#--- Disk Storage Type
  storage_os_disk {
    name              = "${var.AZ_VM_NAME}-os-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb         = "100"
  }
#--- Define password + hostname ---
  os_profile {
    computer_name  = var.AZ_VM_NAME
    admin_username = var.AZ_VM_ADMIN_USERNAME
    admin_password = data.azurerm_key_vault_secret.DATA_AKV_SECRET_ADMINPWD.value
  }
#--- UPDATES
   os_profile_linux_config {
    disable_password_authentication = false
  }
#--- Running MediaWiki Docker Container On Provisioned VM
   provisioner "remote-exec" {
    inline = [
      "sudo curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
#     "sudo usermod -aG docker $${USER}",
	    "sudo docker run --name some-mediawiki -p 8080:80 -d mediawiki"
    ]

    connection {
      type     = "ssh"
      user     = "var.AZ_VM_ADMIN_USERNAME"
      password = "data.azurerm_key_vault_secret.DATA_AKV_SECRET_ADMINPWD.value"
      host     = "data.azurerm_network_interface.RES_NIC_VM_NETMGMT.private_ip_address"
    }
  }
#resource "azurerm_virtual_machine_data_disk_attachment" "data" {
#  virtual_machine_id = azurerm_linux_virtual_machine.main.id
#  managed_disk_id    = azurerm_managed_disk.data.id
#  lun                = 0
#  caching            = "None"
#}  
#-- VM Diagnostics 
#  boot_diagnostics {
#    enabled     = true
#    storage_uri = var.AZ_STA_BOOT_DIAG_URI
# }
}
