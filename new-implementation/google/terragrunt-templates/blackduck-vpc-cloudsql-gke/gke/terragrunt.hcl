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
  initial_node_count = 3
  machine_type = "n2-standard-2"
}


