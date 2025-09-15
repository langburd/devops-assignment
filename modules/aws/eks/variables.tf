variable "cluster_addons" {
  description = "List of addons to enable for the EKS cluster"
  type        = map(map(bool))
  default     = {}
}

variable "cluster_name" {
  description = "Name of the EKS cluster to create"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "eks_workers" {
  description = "List of managed node groups to create for the EKS cluster"
  type = map(object({
    min_size        = number
    max_size        = number
    desired_size    = number
    max_unavailable = number
    instance_types  = list(string)
    }
  ))
  default = {}
}

variable "subnet_ids" {
  description = "List of subnet IDs to place EKS cluster in"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "The tags to apply to the EKS"
  type        = map(string)
  default     = {}
}
