variable "rg_name" {
  description = "resource group name"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "pg_server_name" {
  default     = "pg-server"
  description = "cannot be empty or null. It can only be made up of lowercase letters 'a'-'z', the numbers 0-9 and the hyphen. The hyphen may not lead or trail in the name."
}

variable "pg_sku" {
  default = "GP_Gen5_2"
}

variable "storage_mb" {
  default = 5120
}

variable "backup_retention_days" {
  default = 7
}

variable "geo_redundant_backup" {
  default = "Disabled"
}

variable "administrator_login" {
  default = "psqladminun"
}

variable "administrator_login_password" {
  default = "H@Sh1CoR3!"
}

variable "pg_version" {
  default = "9.6"
}

variable "ssl_enforcement" {
  default = "Enabled"
}

