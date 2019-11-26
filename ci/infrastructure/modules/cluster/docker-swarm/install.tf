resource "null_resource" "swarm-install-master" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.cluster_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host_public_dns_name}"

  }

  depends_on = [
    "null_resource.swarm-install-prep",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo docker swarm init",
      "sudo docker swarm join-token --quiet worker > swarm_worker.token",
      "for n in ${join(" ", var.worker_private_dns_names)}; do scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null swarm_worker.token $n:; done",
    ]
  }
}

resource "null_resource" "swarm-install-nodes" {
  count = "${var.is_enabled == "true" ? "${var.worker_node_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.cluster_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.worker_public_dns_names[count.index]}"

  }

  depends_on = [
    "null_resource.swarm-install-master",
  ]


  provisioner "remote-exec" {
    inline = [
      "sudo docker swarm join --token `cat swarm_worker.token` ${var.install_host_private_dns_name}:2377"
    ]
  }
}
