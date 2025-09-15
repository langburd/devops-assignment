variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "tags" {
  description = "The tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR associated with the VPC to be created"
  type        = string
}

variable "vpc_subnets_map" {
  description = "Map of Subnets. Last character of Subnet name is to specify Availability Zone: A,B,C,D"
  type = object({
    public = map(map(object({ cidr = string })))
  })
  default = {
    public = {}
  }
}
