variable "app_environment" {
  description = "The environment to deploy the app to"
  type        = string
  default     = "development"
}

variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = "app"
}

variable "cluster_name" {
  description = "Name of the AKS cluster to create"
  type        = string
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
