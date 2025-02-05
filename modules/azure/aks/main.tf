terraform {
  required_version = ">= 1.5.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "< 4.4"
    }
  }
}

provider "azurerm" {
  features {}
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "9.4.1"

  resource_group_name                 = var.resource_group_name
  cluster_name                        = var.cluster_name
  prefix                              = var.resource_group_name
  agents_count                        = 1
  kubernetes_version                  = "1.27"
  log_analytics_workspace_enabled     = false
  rbac_aad                            = false
  enable_host_encryption              = false
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  ingress_application_gateway_enabled = true
  ingress_application_gateway_id      = var.ingress_application_gateway_id

  tags = var.tags
}
