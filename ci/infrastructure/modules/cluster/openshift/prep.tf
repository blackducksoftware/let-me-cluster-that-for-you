resource "null_resource" "openshift-nodes-prep" {
  count = "${var.is_enabled == "true" ? "${var.master_node_count + var.worker_node_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.cluster_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${element(concat(var.master_public_dns_names, var.worker_public_dns_names), count.index)}"
  }

  # This provisioner exists solely to ensure the dependency setup works.  That is,
  # that this module won't run until the dependency finishes.
  provisioner "local-exec" {
    command = "echo 'Waited for dependency ${var.depends_on} to complete'"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion httpd-tools python2-pyyaml python-ipaddress kexec-tools sos psacct",
    ]
  }
}

resource "null_resource" "openshift-install-prep" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host}"
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

#  provisioner "metrics" {
#   metrics ...
#      "sudo yum install -y pyOpenSSL java-1.8.0-openjdk-headless",
#  } 

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/id_rsa",
      # Disable epel because we need ansible 2.4 and epel has a newer version that won't work, and
      # just for fun centos 7 has a version of ansible 2.4 this is too old.  We need to use pip
      # to install the version of ansible we need
      "sudo yum install -y yum-utils",
      "sudo yum-config-manager --disable epel",
      "sudo yum-config-manager --enable rhui-REGION-rhel-server-extras",
      "sudo yum makecache -y fast",
      "sudo yum install -y git python2-pip --enablerepo epel",
      "sudo pip install pip --upgrade",
      "sudo pip install ansible${local.ansible_version}",
      "git clone -b release-${var.os_version} https://github.com/openshift/openshift-ansible",
      # Since we don't handle annotations for _any_ openshift version this should work in all of them
      "pushd openshift-ansible && while test $(grep annotation roles/openshift_persistent_volumes/templates/persistent-volume.yml.j2 | wc -l) -gt 0; do git reset --hard HEAD^; done; popd",
    ]
  }
}
