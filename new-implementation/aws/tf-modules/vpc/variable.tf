variable "region" {
  type        = string
  description = "Region of vpc to setup"
  default     = "ap-south-1"
}

variable "vpc_name" {
  type        = string
  description = "Name of the vpc"
}