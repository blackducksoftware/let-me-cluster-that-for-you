terraform {
  source = "../../../tf-modules/postgres-rds"
}
dependencies {
   paths = ["../vpc"]
}
dependency "vpc" {
  config_path = "../vpc"
}
include {
  path = "${find_in_parent_folders()}"
}
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.vpc_database_subnets
  security_groups = "default"
}

