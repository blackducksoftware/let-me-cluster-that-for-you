data "template_file" "openshift-config-masters" {
  count = "${var.is_enabled == "true" ? "${var.master_node_count}" : "0"}"
  template = "$${master_hostname}"

  vars {
    master_hostname = "${element(var.master_private_dns_names, count.index)}"
  }
}

data "template_file" "openshift-config-master-nodes" {
  count = "${var.is_enabled == "true" ? "${var.master_node_count}" : "0"}"
  template = "$${master_hostname} openshift_node_labels=\"{'region': 'infra', 'zone': 'default'}\" openshift_schedulable=true openshift_node_group_name='node-config-master-infra'"

  vars {
    master_hostname = "${element(var.master_private_dns_names, count.index)}"
  }
}

data "template_file" "openshift-config-etcd-nodes" {
  count = "${var.is_enabled == "true" ? "${var.master_node_count}" : "0"}"
  template = "$${etcd_hostname}"

  vars {
    etcd_hostname = "${element(var.master_private_dns_names, count.index)}"
  }
}

data "template_file" "openshift-config-worker-nodes" {
  count = "${var.is_enabled == "true" ? "${var.worker_node_count}" : "0"}"

  template = "$${worker_hostname} openshift_node_labels=\"{'region': 'primary', 'zone': 'default'}\" openshift_node_group_name='node-config-compute'"

  vars {
    worker_hostname = "${element(var.worker_private_dns_names, count.index)}"
  }
}

data "template_file" "openshift-version-htpasswd-provider" {
  
  count = "${local.major_minor[0] > 3 || (local.major_minor[0] <= 3 && local.major_minor[1] > 9) ? "1" : "0"}"
  
  template = ", {'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider'}"
}

data "template_file" "openshift-config-file" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  template = "${file("${path.module}/inventory.template")}"

  vars {
    ssh_user = "${var.cluster_ssh_user}"
    public_hostname = "${var.public_hostname}"
    master_default_subdomain = "${var.default_subdomain}"
    master_hosts = "${join("\n", data.template_file.openshift-config-masters.*.rendered)}"
    etcd_hosts = "${join("\n", data.template_file.openshift-config-etcd-nodes.*.rendered)}"
    master_nodes = "${join("\n", data.template_file.openshift-config-master-nodes.*.rendered)}"
    worker_nodes = "${join("\n", data.template_file.openshift-config-worker-nodes.*.rendered)}"
    disk_minimum_override = "${length(var.minimum_free_space_gb) > 0 ? "openshift_check_min_host_disk_gb=${var.minimum_free_space_gb}" : ""}"
    cluster_version = "${var.os_version}"
    htpasswd_provider = "${join("",data.template_file.openshift-version-htpasswd-provider.*.rendered)}"
  }
}

resource "null_resource" "openshift-config" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host}"
  }

  provisioner "file" {
    content = "${data.template_file.openshift-config-file.rendered}"
    destination = "~/inventory.cluster"
  }
}
