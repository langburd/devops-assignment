variable "cluster_name" {
  description = "Name of the AKS cluster to create"
  type        = string
}

variable "ingress_application_gateway_name" {
  description = "Name of the Application Gateway to create"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "germanywestcentral"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
