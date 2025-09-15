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

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster to create"
  type        = string
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
}
