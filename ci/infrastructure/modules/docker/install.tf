resource "null_resource" "docker-install" {
  count = "${var.is_enabled == "true" ? "${var.master_count}" + "${var.worker_count}" : "0"}"

  connection {
    type = "ssh"
    user = "${var.ssh_user}"
    private_key = "${file("${var.private_key_file}")}"
    agent = "false"
    host = "${element(concat(var.master_nodes, var.worker_nodes), count.index)}"
  }

  depends_on = [
    "null_resource.docker-install-prep"
  ]

  provisioner "remote-exec" {
    inline = [
      # This is incredibly stupid.  The -subscription-manager-rhsm-certificates package obsoletes python-rhsm-certificates, but
      # subscription-manager-rhsm-certificates doesn't actually contain the certs for accessing Red Hat's docker images.  See:
      # https://bugs.centos.org/view.php?id=14785
      # https://lists.centos.org/pipermail/centos-devel/2018-June/016749.html
      # Use the work around in the centos bug (d/l the python-rhsm-certificates package and extract the cert file)
      "sudo yum install -y --setopt=obsoletes=0 subscription-manager-rhsm-certificates yum-utils wget",
      "yumdownloader python-rhsm-certificates",
      "rpm2cpio python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm | cpio -iv --to-stdout ./etc/rhsm/ca/redhat-uep.pem | sudo tee /etc/rhsm/ca/redhat-uep.pem",
      # docker-1.13.1-90.git07f3374.el7 is broken and docker-1.13.1-93.gitb2f74b2.el7 idn't in the centos repos yet, hence this abomination:
      "if [ '${local.docker_pkg}' = 'docker' ] ; then wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/python-pytoml-0.1.14-1.git7dea353.el7.noarch.rpm && sudo yum install -y python-pytoml-0.1.14-1.git7dea353.el7.noarch.rpm && rm python-pytoml-0.1.14-1.git7dea353.el7.noarch.rpm && wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/atomic-registries-1.22.1-29.gitb507039.el7.x86_64.rpm && sudo yum install -y atomic-registries-1.22.1-29.gitb507039.el7.x86_64.rpm && rm atomic-registries-1.22.1-29.gitb507039.el7.x86_64.rpm && wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/skopeo-containers-0.1.31-1.dev.gitae64ff7.el7.centos.x86_64.rpm && sudo yum install -y skopeo-containers-0.1.31-1.dev.gitae64ff7.el7.centos.x86_64.rpm && rm skopeo-containers-0.1.31-1.dev.gitae64ff7.el7.centos.x86_64.rpm && wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/container-storage-setup-0.11.0-2.git5eaf76c.el7.noarch.rpm && sudo yum install -y container-storage-setup-0.11.0-2.git5eaf76c.el7.noarch.rpm && rm container-storage-setup-0.11.0-2.git5eaf76c.el7.noarch.rpm && wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/oci-umount-2.5-3.el7.x86_64.rpm && sudo yum install -y oci-umount-2.5-3.el7.x86_64.rpm && rm oci-umount-2.5-3.el7.x86_64.rpm && wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/oci-systemd-hook-0.2.0-1.git05e6923.el7_6.x86_64.rpm && sudo yum install -y oci-systemd-hook-0.2.0-1.git05e6923.el7_6.x86_64.rpm && rm oci-systemd-hook-0.2.0-1.git05e6923.el7_6.x86_64.rpm && wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm && sudo yum install -y container-selinux-2.107-3.el7.noarch.rpm && rm container-selinux-2.107-3.el7.noarch.rpm && wget https://rpmfind.net/linux/centos/7.7.1908/extras/x86_64/Packages/oci-register-machine-0-6.git2b44233.el7.x86_64.rpm && sudo yum install -y oci-register-machine-0-6.git2b44233.el7.x86_64.rpm && rm oci-register-machine-0-6.git2b44233.el7.x86_64.rpm; fi",
      "if [ '${local.docker_pkg}' = 'docker' ] ; then for COMPONENT in '' -client -common -rhel-push-plugin; do wget https://cbs.centos.org/kojifiles/packages/docker/1.13.1/93.gitb2f74b2.el7/x86_64/docker$${COMPONENT}-1.13.1-93.gitb2f74b2.el7.x86_64.rpm; done && sudo yum -y install ./docker*.rpm && rm ./*.rpm; else sudo yum -y install ${local.docker_pkg}; fi",
      "sudo systemctl enable docker",
    ]
  }
}
