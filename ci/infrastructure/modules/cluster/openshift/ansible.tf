data "template_file" "ansible-config-file" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  template = "${file("${path.module}/ansible.cfg.template")}"

  vars {
    fork_count = "${var.worker_node_count + var.master_node_count + 10}"
  }
}

resource "null_resource" "ansible-config" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host}"
  }

  provisioner "file" {
    content = "${data.template_file.ansible-config-file.rendered}"
    destination = "~/ansible.cfg"
  }
}
