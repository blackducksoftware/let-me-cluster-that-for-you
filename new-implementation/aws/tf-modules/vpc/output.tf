// vpc output
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_ip" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "vpc_public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "vpc_database_subnets" {
  value = "${module.vpc.database_subnets}"
}