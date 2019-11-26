locals {
  converted_version = "${length(var.os_version) < 3 ? "0.0" : "${var.os_version}"}"
  major_version = "${join(".", slice(split(".", local.converted_version), 0, 2))}"
  major_minor = "${split(".", local.major_version)}"
  alt_setup = "${local.major_minor[0] > 3 || (local.major_minor[0] <= 3 && local.major_minor[1] > 7) ? "true" : "false"}"
  ansible_version = "${local.major_minor[0] > 3 || (local.major_minor[0] <= 3 && local.major_minor[1] > 9) ? "==2.7.1" : "==2.4.6"}"
  install_playbook = "${local.alt_setup == "true" ? "deploy_cluster.yml" : "byo/config.yml"}"
}
