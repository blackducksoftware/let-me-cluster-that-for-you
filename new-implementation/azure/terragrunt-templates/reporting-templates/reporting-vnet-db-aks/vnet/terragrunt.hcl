terraform {
  source = "../../../../tf-modules/vnet"
}

include {
  path = "${find_in_parent_folders()}"
}
inputs = {
  location = "centralus"
}

