terraform {
  source = "../../../../tf-modules/azure-db"
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
  subnet_id = dependency.vnet.outputs.subnet_id
}

