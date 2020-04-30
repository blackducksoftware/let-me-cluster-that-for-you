output "db_endpoint" {
  value = "${module.db.this_db_instance_endpoint}"
}

output "name" {
  value = "${module.db.this_db_instance_name}"
}

output "vpc_database_subnets" {
  value = "${module.db.this_db_subnet_group_id}"
}

