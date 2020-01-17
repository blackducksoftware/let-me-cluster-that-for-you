/* Azure provider */

variable "resource_group_name" {
  type = string
  description = "Azure resource group name that groups all the created resources together. Preferably globally unique to avoid naming conflicts."
}

variable "resource_group_location" {
  type = string
  description = "Azure resource group location."
}

/* Postgres */

variable "postgres_subnet_id" {
  type        = string
  description = "Subnet id for PostgreSQL clusters."
}

variable "postgres_instances" {
  type    = list(string)
  default = []
  description = "Name for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_admins" {
  type    = list(string)
  default = []
  description = "Admin username for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_versions" {
  type    = list(string)
  default = []
  description = "Version for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_sku_names" {
  type    = list(string)
  default = []
  description = "SKU name for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}
variable "postgres_sku_capacities" {
  type    = list(number)
  default = []
  description = "SKU capability for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}
variable "postgres_sku_tiers" {
  type    = list(string)
  default = []
  description = "SKU tier for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}
variable "postgres_sku_families" {
  type    = list(string)
  default = []
  description = "SKU family for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}

variable "postgres_node_counts" {
  type    = list(number)
  default = []
  description = "Number of nodes for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_storage_sizes" {
  type    = list(number)
  default = []
  description = "Storage size for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_auto_grows" {
  type    = list(string)
  default = []
  description = "Auto grow Enabled/Disabled for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_backup_retention_days" {
  type    = list(number)
  default = []
  description = "Backup retention days for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_geo_redundant_backups" {
  type    = list(string)
  default = []
  description = "Geo redundant backup Enabled/Disabled for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}
