variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "germanywestcentral"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_appgw_id" {
  description = "The ID of the AppGW subnet"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the resource group"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}
