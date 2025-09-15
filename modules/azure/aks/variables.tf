variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "ingress_application_gateway_id" {
  type        = string
  default     = null
  description = "The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster."
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the resource group"
  type        = map(string)
  default     = {}
}
