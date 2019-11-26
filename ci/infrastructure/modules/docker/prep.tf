resource "null_resource" "docker-install-prep" {
  count = "${var.is_enabled == "true" && lower(var.docker_version) != "os" ? "${var.master_count}" + "${var.worker_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.ssh_user}"
    private_key = "${file("${var.private_key_file}")}"
    agent = "false"
    host = "${element(concat(var.master_nodes, var.worker_nodes), count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
      "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum makecache fast",
    ]
  }
}
