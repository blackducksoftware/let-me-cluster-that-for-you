resource "null_resource" "kubernetes-install-master" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  connection {
    type = "ssh"
    user = "${var.cluster_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.install_host_public_dns_name}"

  }

  depends_on = [
    "null_resource.kubernetes-install-prep",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo kubeadm init --ignore-preflight-errors=swap,cri --apiserver-bind-port ${local.master_port} --kubernetes-version ${var.kube_version} --token `cat kubernetes.token` --pod-network-cidr=192.168.0.0/16 --apiserver-cert-extra-sans=${join(",", concat(var.master_public_ips, var.master_public_dns_names))}",
      "${local.pod_network_112_plus == "true" ? "sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://docs.projectcalico.org/v${local.kube_calico_version}/manifests/calico.yaml" : "sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml"}",
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //' > kubernetes-discovery.hash",
      "for n in ${join(" ", var.worker_private_dns_names)}; do scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null kubernetes-discovery.hash $n:; done",
    ]
  }
}

resource "null_resource" "kubernetes-install-nodes" {
  count = "${var.is_enabled == "true" ? "${var.worker_node_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.cluster_ssh_user}"
    private_key = "${file("${var.ssh_private_key_file}")}"
    agent = "false"
    host = "${var.worker_public_dns_names[count.index]}"

  }

  depends_on = [
    "null_resource.kubernetes-install-master",
  ]


  provisioner "remote-exec" {
    inline = [
      "sudo kubeadm join --ignore-preflight-errors=swap,cri --token `cat kubernetes.token` ${var.install_host_private_dns_name}:${local.master_port} --discovery-token-ca-cert-hash sha256:`cat kubernetes-discovery.hash`",
    ]
  }
}
