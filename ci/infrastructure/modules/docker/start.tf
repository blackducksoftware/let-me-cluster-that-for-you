resource "null_resource" "docker-start" {
  count = "${var.is_enabled == "true" ? "${var.master_count}" + "${var.worker_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.ssh_user}"
    private_key = "${file("${var.private_key_file}")}"
    agent = "false"
    host = "${element(concat(var.master_nodes, var.worker_nodes), count.index)}"
  }

  depends_on = [
    "null_resource.docker-install",
    "null_resource.docker-storage-config-os-version",
    "null_resource.docker-storage-config-ce-version",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl start docker",
    ]
  }
}
