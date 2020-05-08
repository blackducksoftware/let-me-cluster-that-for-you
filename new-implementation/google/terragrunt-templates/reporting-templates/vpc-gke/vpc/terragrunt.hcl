terraform {
  source = "../../../../tf-modules/vpc"
}

include {
  path = "${find_in_parent_folders()}"
}
# inputs = {
#   network_name = "reporting-poc"
#   subnet_name = "reporting-poc"
# }


