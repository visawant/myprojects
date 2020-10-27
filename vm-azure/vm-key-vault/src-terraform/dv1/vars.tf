###############################################################################
#  TENANT VARIABLES  #
###############################################################################

AZ_LOCATION             = "eastus2"
AZ_RSG_NAME             = "dv1_rsg_qpid_ci_cd"

###############################################################################
#  AKV VARIABLES  #
###############################################################################

AZ_AKV_NAME             = "vipulakv20"


###############################################################################
#  AKV POLICY VARIABLES  #
###############################################################################

AZ_TENANT_ID                       = "*************************************"

# Azure DevOps service principal    # Go to Azure active directory and enterprise applications, select all applications, search for sp:sp_dv1_rsg_qpid_ci_cd,copy the object-id
AZ_DEVOPS_TEAMSERVICEPRINCIPAL_ID   = "************************************"

# AD Cloud enablement group
AZ_AD_CONTRIBUTORRESOURCEGROUPID    = "************************************"
