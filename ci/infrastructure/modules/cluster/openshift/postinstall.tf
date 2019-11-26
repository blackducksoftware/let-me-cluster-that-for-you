resource "null_resource" "openshift-origin-master-postinstall" {
  count = "${var.is_enabled == "true" ? "${var.master_node_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.cluster_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${element(var.master_public_dns_names, count.index)}"
  }

  depends_on = [
    "null_resource.openshift-origin-install",
  ]

  provisioner "file" {
    source = "${path.module}/post-install-common.sh"
    destination = "~/post-install-common.sh"
  }

  provisioner "remote-exec" {
    inline = [
#      "sudo htpasswd -cb /etc/origin/master/users.htpasswd admin admin",
      "oc adm policy add-cluster-role-to-user cluster-admin admin",
      "sudo /bin/sh ./post-install-common.sh",
      "sudo systemctl restart docker",
    ]
  }
}

resource "null_resource" "openshift-origin-worker-postinstall" {
  count = "${var.is_enabled == "true" ? "${var.worker_node_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.cluster_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${element(var.worker_public_dns_names, count.index)}"
  }

  depends_on = [
    "null_resource.openshift-origin-install",
  ]

  provisioner "file" {
    source = "${path.module}/post-install-common.sh"
    destination = "~/post-install-common.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /bin/sh ./post-install-common.sh",
      "sudo systemctl restart docker",
    ]
  }
}
