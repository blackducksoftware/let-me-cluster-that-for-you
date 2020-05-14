terraform {
  source = "../../../tf-modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
}
include {
  path = "${find_in_parent_folders()}"
}
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.vpc_public_subnets
  workers = 3
  instance_type = "t2.large"
}

