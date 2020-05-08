terraform {
  source = "../../../../tf-modules/cloudsql"
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
  network_name = dependency.vpc.outputs.network_name
  subnet_name = dependency.vpc.outputs.subnet_name[0]
  #project_id = "snps-polaris-onprem-dev"
  #region       = dependency.vpc.outputs.region
}
