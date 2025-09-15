variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = "app"
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone"
  type        = string
}

variable "public_ip_address" {
  description = "The public IP address of the Application Gateway"
  type        = string
}
