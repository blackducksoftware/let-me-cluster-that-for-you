terraform {
  source = "../../../tf-modules/vnet"
}

include {
  path = "${find_in_parent_folders()}"
}
inputs = {
  location = get_env("TF_VAR_location", "")
}

