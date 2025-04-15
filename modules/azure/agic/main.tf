# Providers
terraform {
  required_version = ">= 1.5.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.35.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# data "azurerm_role_definition" "reader" {
#   name = "Reader"
# }

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azurerm_user_assigned_identity" "aks_workload_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.resource_group_name}-ingress"

  tags = var.tags
}

resource "azurerm_federated_identity_credential" "aks_workload_identity" {
  name                = azurerm_user_assigned_identity.aks_workload_identity.name
  resource_group_name = azurerm_user_assigned_identity.aks_workload_identity.resource_group_name
  parent_id           = azurerm_user_assigned_identity.aks_workload_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
  subject             = "system:serviceaccount:kube-system:ingress-azure"
}

resource "azurerm_role_assignment" "aks_workload_identity" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_user_assigned_identity.aks_workload_identity.principal_id
}

# az role assignment create --role Reader --scope /subscriptions/659a309d-849e-4ab3-8876-7c48581ead36/resourceGroups/avilangburd --assignee ad94d8e9-9199-4b81-97be-2a36300baab4
# az role assignment create --role Contributor --scope /subscriptions/659a309d-849e-4ab3-8876-7c48581ead36/resourceGroups/avilangburd/providers/Microsoft.Network/applicationGateways/avilangburd-appgw --assignee ad94d8e9-9199-4b81-97be-2a36300baab4

# data "azurerm_resource_group" "this" {
#   name = var.resource_group_name
# }

# data "azurerm_application_gateway" "this" {
#   name                = var.ingress_application_gateway_name
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_role_assignment" "aks_workload_identity_reader" {
#   scope                = data.azurerm_resource_group.this.id
#   role_definition_name = "Reader"
#   principal_id         = azurerm_user_assigned_identity.aks_workload_identity.principal_id
# }

# resource "azurerm_role_assignment" "aks_workload_identity_contributor" {
#   scope                = data.azurerm_application_gateway.this.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.aks_workload_identity.principal_id
# }

# Install CRD's for Application Gateway Ingress Controller (AGIC) Helm chart
resource "helm_release" "aad_pod_identity" {
  name          = "aad-pod-identity"
  namespace     = "kube-system"
  chart         = "aad-pod-identity"
  repository    = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  version       = "4.1.18"
  wait          = true
  recreate_pods = true
  values = [
    file("${path.module}/templates/aad_pod_identity.tpl")
  ]
}

# Since the IngressClass is already created, we need to import it into the state and add the missing labels and annotations for Helm install/upgrade to work
import {
  to = kubernetes_ingress_class.azure_application_gateway
  id = "azure-application-gateway"
}

resource "kubernetes_ingress_class" "azure_application_gateway" {
  metadata {
    name = "azure-application-gateway"
    labels = {
      "addonmanager.kubernetes.io/mode" = "Reconcile"
      "app"                             = "ingress-appgw"
      "app.kubernetes.io/component"     = "controller"
      "app.kubernetes.io/managed-by"    = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = "ingress-azure"
      "meta.helm.sh/release-namespace" = "kube-system"
    }
  }
  spec {
    controller = "azure/application-gateway"
  }
}

# Install Application Gateway Ingress Controller (AGIC) Helm chart
resource "helm_release" "ingress_azure" {
  name            = "ingress-azure"
  namespace       = "kube-system"
  chart           = "ingress-azure"
  repository      = "oci://mcr.microsoft.com/azure-application-gateway/charts"
  version         = "1.9.0"
  wait            = true
  force_update    = true
  recreate_pods   = true
  cleanup_on_fail = true
  values = [
    templatefile("${path.module}/templates/ingress_azure.tpl", {
      subscription_id                  = data.azurerm_client_config.current.subscription_id
      resource_group_name              = var.resource_group_name
      ingress_application_gateway_name = var.ingress_application_gateway_name
      identity_client_id               = azurerm_user_assigned_identity.aks_workload_identity.client_id
    })
  ]
  depends_on = [
    helm_release.aad_pod_identity,
    kubernetes_ingress_class.azure_application_gateway
  ]
}
