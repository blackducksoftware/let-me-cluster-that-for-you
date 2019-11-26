data "template_file" "docker-storage-file-os-version" {
  count = "${var.is_enabled == "true" && lower(var.docker_version) == "os" ? "${var.master_count}" + "${var.worker_count}" : "0"}"

  template = "${file("${path.module}/docker-os-storage-setup.template")}"

  vars {
    docker_disk = "${count.index < length(var.master_nodes) ? "${var.master_docker_disk}" : "${var.worker_docker_disk}"}"
  }
}

data "template_file" "docker-storage-file-ce-version" {
  count = "${var.is_enabled == "true" && lower(var.docker_version) != "os" ? "${var.master_count}" + "${var.worker_count}" : "0"}"
  template = "${file("${path.module}/docker-ce-storage-setup.sh.template")}"

  vars {
    docker_disk = "${count.index < length(var.master_nodes) ? "${var.master_docker_disk}" : "${var.worker_docker_disk}"}"
  }
}

resource "null_resource" "docker-storage-config-os-version" {
  count = "${var.is_enabled == "true" && lower(var.docker_version) == "os" ? "${var.master_count}" + "${var.worker_count}" : "0"}" 

  connection {
    type = "ssh"
    user = "${var.ssh_user}"
    private_key = "${file("${var.private_key_file}")}"
    agent = "false"
    host = "${element(concat(var.master_nodes, var.worker_nodes), count.index)}"
  }

  depends_on = [
    "null_resource.docker-install",
  ]

  provisioner "file" {
    content = "${data.template_file.docker-storage-file-os-version.*.rendered[count.index]}"
    destination = "~/docker-storage-setup"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv -f docker-storage-setup /etc/sysconfig/docker-storage-setup",
      "sudo docker-storage-setup",
    ]
  }
}

resource "null_resource" "docker-storage-config-ce-version" {
  count = "${var.is_enabled == "true" && lower(var.docker_version) != "os" ? "${var.master_count}" + "${var.worker_count}" : "0"}" 

  connection {
    type = "ssh"
    user = "${var.ssh_user}"
    private_key = "${file("${var.private_key_file}")}"
    agent = "false"
    host = "${element(concat(var.master_nodes, var.worker_nodes), count.index)}"
  }

  depends_on = [
    "null_resource.docker-install",
  ]

  provisioner "file" {
    content = "${data.template_file.docker-storage-file-ce-version.*.rendered[count.index]}"
    destination = "~/docker-storage-setup.sh"
  }

  provisioner "file" {
    source = "${path.module}/docker-thinpool.profile"
    destination = "~/docker-thinpool.profile"
  }

  provisioner "file" {
    source = "${path.module}/docker-daemon.json"
    destination = "~/daemon.json"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 755 docker-storage-setup.sh",
      "sudo ./docker-storage-setup.sh",
      "sudo mv -f docker-thinpool.profile /etc/lvm/profile/",
      "sudo lvchange --metadataprofile docker-thinpool docker/thinpool",
      "sudo lvs -o+seg_monitor",
      "sudo mkdir -p /etc/docker",
      "sudo chmod 700 /etc/docker",
      "sudo mv daemon.json /etc/docker/daemon.json",
    ]
  }
}
