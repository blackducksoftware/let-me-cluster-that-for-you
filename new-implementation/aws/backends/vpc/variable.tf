variable "region" {
  type = string
  description = "Region of vpc to setup"
  default = "us-east-1"
}

variable "vpc_name" {
  type = string
  description = "Name of the vpc"
}