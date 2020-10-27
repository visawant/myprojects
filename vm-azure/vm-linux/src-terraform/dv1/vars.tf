###############################################################################
#  TENANT VARIABLES  #
###############################################################################

AZ_LOCATION                 = "eastus2"
AZ_RSG_NAME                 = "dv1_rsg_qpid_ci_cd"
AZ_VM_NAME                  = "devopsdemovmtf" # 15 character limit, few special characters vm name

###############################################################################
#  VIRTUAL MACHINE VARIABLES  #
###############################################################################



AZ_SUB_NETMGMT_ID           = "/subscriptions/***********************/resourceGroups/eu2_nonprod1_rg_network/providers/Microsoft.Network/virtualNetworks/eu2_nonprod1_hub_vnet_10.170.0.0_16/subnets/eu2_nonprod1_hub_snet_servers_10.170.62.0_24"
AZ_AKV_ID                   = "/subscriptions/**********************/resourceGroups/dv1_rsg_qpid_ci_cd/providers/Microsoft.KeyVault/vaults/vipulakv20"
AZ_AKV_NAME                 = "vipulakv20" # key-vault name
AZ_VM_ADMIN_USERNAME        = "vipuldemovm" # secret name, and used to ssh vm
