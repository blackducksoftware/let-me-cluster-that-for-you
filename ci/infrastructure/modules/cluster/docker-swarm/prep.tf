resource "null_resource" "swarm-install-prep" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host_public_dns_name}"
  }

  # This provisioner exists solely to ensure the dependency setup works.  That is,
  # that this module won't run until the dependency finishes.
  provisioner "local-exec" {
    command = "echo 'Waited for dependency ${var.depends_on} to complete'"
  }

  provisioner "file" {
    source = "${var.ssh_private_key_file}"
    destination = "~/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/id_rsa",
    ]
  }
}
