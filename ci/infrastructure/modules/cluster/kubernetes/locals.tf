locals {
  master_port = "8443"
  converted_version = "${length(var.kube_version) < 3 ? "0.0" : "${var.kube_version}"}"
  major_version = "${join(".", slice(split(".", local.converted_version), 0, 2))}"
  major_minor = "${split(".", local.major_version)}"
  pod_network_112_plus = "${local.major_minor[0] == 1 && local.major_minor[1] > 11 ? "true" : "false"}"
  kube_calico_version = "${local.major_minor[1] > 11 ? "3.10":"3.9"}"
  systemd_system_root = "${local.major_minor[0] <= 1 && local.major_minor[1] < 14 ? "/etc" : "/usr/lib"}"
}

data "external" "kubeconfig" {
  depends_on = [
    "null_resource.kubernetes-install-master",
    "null_resource.kubernetes-install-nodes",
  ]

  program = ["${path.module}/get_kubeconfig.sh"]

  query = {
    master = "${var.install_host_public_dns_name}"
    ssh_user = "${var.cluster_ssh_user}"
    ssh_key_file = "${var.ssh_private_key_file}"
    run = "${var.is_enabled}"
  }
}
