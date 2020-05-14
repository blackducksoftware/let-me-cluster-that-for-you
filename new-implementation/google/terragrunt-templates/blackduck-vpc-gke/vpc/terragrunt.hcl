terraform {
  source = "../../../tf-modules/vpc"
}
include {
  path = "${find_in_parent_folders()}"
}
inputs = {
    network_name       = get_env("TF_VAR_network_name", "")
    subnet_name        = get_env("TF_VAR_subnet_name", "")
} 



