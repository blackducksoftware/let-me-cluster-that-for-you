terraform {
  source = "../../../tf-modules/gke"
}

dependency "vpc" {
  config_path = "../vpc"
}
include {
  path = "${find_in_parent_folders()}"
}
inputs = {
  network_name = dependency.vpc.outputs.network_name
  subnet_name = dependency.vpc.outputs.subnet_name[0]
  initial_node_count = 4
  machine_type = "n1-standard-4"
}


