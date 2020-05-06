terraform {
  source = "../../../../tf-modules/aks"
}
dependencies {
    paths = ["../vnet"]
  }

dependency "vnet" {
  config_path = "../vnet"
}

include {
  path = "${find_in_parent_folders()}"
}
inputs = {
  rg_name = dependency.vnet.outputs.rg_name.name
  rg_location = dependency.vnet.outputs.rg_name.location
  subnet_id = dependency.vnet.outputs.subnet_id
}
