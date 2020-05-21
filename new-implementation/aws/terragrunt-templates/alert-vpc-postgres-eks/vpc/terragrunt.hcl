terraform {
  source = "../../../tf-modules/vpc"
}

include {
  path = "${find_in_parent_folders()}"
}
inputs = {
  vpc_name = get_env("TF_VAR_cluster_name", "")
}
