resource "null_resource" "kubernetes-prep" {
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

  provisioner "file" {
    source = "${path.module}/kubernetes.repo"
    destination = "kubernetes.repo"
  }

  provisioner "file" {
    source = "${path.module}/kubernetes-sysctl.conf"
    destination = "kubernetes.conf"
  }

  provisioner "file" {
    source = "${path.module}/kubelet-extra-args.sh"
    destination = "kubelet-extra-args.sh"
  }

  provisioner "file" {
    source = "${path.module}/90-extra-args.conf"
    destination = "90-extra-args.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv kubernetes.conf /etc/sysctl.d",
      "sudo sysctl --system",
      "sudo mv kubernetes.repo /etc/yum.repos.d",
      "sudo yum makecache -y fast",
      "sudo setenforce 0",
      "sudo sed -i 's/enforcing/permissive/' /etc/selinux/config",
      #"sudo yum install -y kubeadm-${var.kube_version} kubelet-${var.kube_version} kubectl-${var.kube_version}",
      # All this fuss to keep yum from zealously installing the latest kubernetes-cni (specifying the version works, but it gets upgraded later on)
      "sudo yum install -y kubeadm-${var.kube_version} kubelet-${var.kube_version} kubectl-${var.kube_version} 2>/tmp/cni-might-fail || if ! rpm -q kubernetes-cni; then",
      "  if [ \"$(cat /tmp/cni-might-fail | head -n 2 | tail -n 1 | cut -d= -f2)\" = \" 0.6.0\" ]; then",
      "    sudo yum -y install kubernetes-cni-0.6.0 kubelet-${var.kube_version} && sudo yum install -y kubeadm-${var.kube_version} kubelet-${var.kube_version} kubectl-${var.kube_version}",
      "  fi",
      "fi",
#      "set +x",
      # This is silly, but needed to support mulitple kubernetes versions.  As the kubernetes installation process has
      # evolved, the way to define KUBELET_EXTRA_ARGS has changed.  Later releases of the kubernetes install have a
      # /etc/sysconfig/kubelet file that defines KUBELET_EXTRA_ARGS to nothing,  and have moved the unit files from
      # /etc to /usr/lib.  To deal with this, we put a unit file in the systemd unit directory and modify the file
      # in /etc/sysconfig
      "sudo cp 90-extra-args.conf ${local.systemd_system_root}/systemd/system/kubelet.service.d/",
      "chmod 755 kubelet-extra-args.sh && sudo ./kubelet-extra-args.sh",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable kubelet",
      "sudo systemctl start kubelet",
    ]
  }
}

resource "null_resource" "kubernetes-install-prep" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.installer_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host_public_dns_name}"
  }

  depends_on = [
    "null_resource.kubernetes-prep"
  ]

  provisioner "file" {
    source = "${var.ssh_private_key_file}"
    destination = "~/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/id_rsa",
      "kubeadm token generate > kubernetes.token",
      "for n in ${join(" ", var.worker_private_dns_names)}; do scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null kubernetes.token $n:; done"
    ]
  }
}
