resource "null_resource" "openshift-origin-install" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host}"
  }

  depends_on = [
    "null_resource.openshift-nodes-prep",
    "null_resource.openshift-config",
    "null_resource.openshift-install-prep",
    "null_resource.openshift-install-prereq",
    "null_resource.ansible-config",
    "null_resource.openshift-ssh-config",
  ]

  provisioner "remote-exec" {
    inline = [
      "ANSIBLE_CONFIG=./ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./inventory.cluster ./openshift-ansible/playbooks/${local.install_playbook}",
    ]
  }
}

resource "null_resource" "openshift-install-prereq" {
  count = "${var.is_enabled == "true" && local.alt_setup == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host}"
  }

  depends_on = [
    "null_resource.openshift-nodes-prep",
    "null_resource.openshift-config",
    "null_resource.openshift-install-prep",
    "null_resource.ansible-config",
    "null_resource.openshift-ssh-config",
  ]

  provisioner "remote-exec" {
    inline = [
      "ANSIBLE_CONFIG=./ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./inventory.cluster ./openshift-ansible/playbooks/prerequisites.yml",
    ]
  }
}

resource "null_resource" "openshift-ssh-config" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'ClientAliveInterval 120' | sudo tee -a /etc/ssh/sshd_config",
      "echo 'ClientAliveCountMax 720' | sudo tee -a /etc/ssh/sshd_config",
      "sudo systemctl restart sshd",
    ]
  }
}
