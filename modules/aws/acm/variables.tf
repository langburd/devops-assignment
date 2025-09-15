variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = "app"
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone"
  type        = string
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the hosted zone"
  type        = map(string)
  default     = {}
}
