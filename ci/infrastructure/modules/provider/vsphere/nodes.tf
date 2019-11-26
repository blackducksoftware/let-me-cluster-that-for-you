resource "vsphere_virtual_machine" "masters" {
  count = "${var.is_enabled == "true" ? "${var.masters}" : "0"}"
  name = "${var.prefix} Cluster Master ${count.index}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${local.master_cpus}"
  memory = "${local.master_memory}"
  guest_id = "${data.vsphere_virtual_machine.master_template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.master_template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.master_template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.master_template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.master_template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.master_template.disks.0.thin_provisioned}"
  }

  // Extra disk
  disk {
    label = "disk1"
    size = "80"
    eagerly_scrub = "false"
    thin_provisioned = "true"
    unit_number = 1
  }

/*
  timeouts {
    create = "${var.instance_create_timeout}m"
  }
*/

  clone {
    template_uuid = "${data.vsphere_virtual_machine.master_template.id}"

/*
    customize {
      linux_options {
        host_name = "${element(local.master_names, count.index)}"
        domain = "${var.domain_name}"
      }

      network_interface {}
    }
*/
  }

  connection {
    type = "ssh"
    user = "${local.cluster_ssh_user}"
    password = "${var.cluster_ssh_user_password}"
    agent = "false"
  }

  provisioner "file" {
    source = "${var.public_key_path}"
    destination = "~/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir ~/.ssh",
      "chmod 755 ~/.ssh",
      "cat ~/id_rsa.pub >> ~/.ssh/authorized_keys",
      "chmod 600 ~/.ssh/authorized_keys",
      "rm -f ~/id_rsa.pub",
      "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum makecache fast",
      "sudo yum update -y",
      "sudo yum install -y pdsh bind-utils",
      "sudo yum clean all",
      "sudo hostnamectl set-hostname ${element(local.master_names, count.index)}",
      "sudo systemctl stop firewalld || /bin/true",
      "sudo systemctl disable firewalld || /bin/true",
    ]
  }

  provisioner "file" {
    content = "${data.template_file.private-dns-config-file.rendered}"
    destination = "98-local-dns.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp 98-local-dns.sh /etc/NetworkManager/dispatcher.d",
      "sudo chmod 755 /etc/NetworkManager/dispatcher.d/98-local-dns.sh",
      "sudo /etc/NetworkManager/dispatcher.d/98-local-dns.sh",
    ]
  }

  provisioner "file" {
    content = "${element(data.template_file.vsphere-hostname-file.*.rendered, count.index)}"
    destination = "vsphere_hostname.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp vsphere_hostname.sh /etc/init.d",
      "sudo chmod +x /etc/init.d/vsphere_hostname.sh",
      "sudo ln -s /etc/init.d/vsphere_hostname.sh /etc/rc3.d/S11vsphere_hostname",
      "sudo /etc/init.d/vsphere_hostname.sh",
    ]
  }
}

resource "vsphere_virtual_machine" "workers" {
  count = "${var.is_enabled == "true" ? "${var.workers}" : "0"}"
  name = "${var.prefix} Cluster Worker ${count.index}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${local.worker_cpus}"
  memory = "${local.worker_memory}"
  guest_id = "${data.vsphere_virtual_machine.worker_template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.worker_template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.worker_template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.worker_template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.worker_template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.worker_template.disks.0.thin_provisioned}"
  }

  // Extra disk
  disk {
    label = "disk1"
    size = "80"
    eagerly_scrub = "false"
    thin_provisioned = "true"
    unit_number = 1
  }

/*
  timeouts {
    create = "${var.instance_create_timeout}m"
  }
*/

  clone {
    template_uuid = "${data.vsphere_virtual_machine.worker_template.id}"

/*
    customize {
      linux_options {
        host_name = "${element(local.worker_names, count.index)}"
        domain = "${var.domain_name}"
      }

      network_interface {}
    }
*/
  }

  connection {
    type = "ssh"
    user = "${local.cluster_ssh_user}"
    password = "${var.cluster_ssh_user_password}"
    agent = "false"
  }

  provisioner "file" {
    source = "${var.public_key_path}"
    destination = "~/id_rsa.pub"
  }

  provisioner "file" {
    content = "${data.template_file.private-dns-config-file.rendered}"
    destination = "98-local-dns.sh"
  }

  provisioner "file" {
    # This is rather fragile.  It depends up on the vsphere-hostname-file template creating the master
    # entries first, then the worker entries.  Really should find a better way to do this, but currently
    # only ways I see are independent tasks which requires dep hack, or seprate template that do the
    # same thing only one for masters and one for workers
    content = "${element(data.template_file.vsphere-hostname-file.*.rendered, count.index + var.masters)}"
    destination = "vsphere_hostname.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir ~/.ssh",
      "chmod 755 ~/.ssh",
      "cat ~/id_rsa.pub >> ~/.ssh/authorized_keys",
      "chmod 600 ~/.ssh/authorized_keys",
      "rm -f ~/id_rsa.pub",
      "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum makecache fast",
      "sudo yum update -y",
      "sudo yum install -y pdsh bind-utils",
      "sudo yum clean all",
      "sudo hostnamectl set-hostname ${element(local.worker_names, count.index)}",
      "sudo systemctl stop firewalld || /bin/true",
      "sudo systemctl disable firewalld || /bin/true",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp 98-local-dns.sh /etc/NetworkManager/dispatcher.d",
      "sudo chmod 755 /etc/NetworkManager/dispatcher.d/98-local-dns.sh",
      "sudo /etc/NetworkManager/dispatcher.d/98-local-dns.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp vsphere_hostname.sh /etc/init.d",
      "sudo chmod +x /etc/init.d/vsphere_hostname.sh",
      "sudo ln -s /etc/init.d/vsphere_hostname.sh /etc/rc3.d/S11vsphere_hostname",
      "sudo /etc/init.d/vsphere_hostname.sh",
    ]
  }
}

data "template_file" "private-dns-config-file" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  template = "${file("${path.module}/98-local-dns.sh.template")}"

  vars {
    private_domain_name = "${var.domain_name}"
    sed_private_domain_name = "${replace(var.domain_name, ".", "\\.")}"
  }
}

data "template_file" "vsphere-hostname-file" {
  count = "${var.is_enabled == "true" ? "${var.masters + var.workers}" : "0"}"
  template = "${file("${path.module}/vsphere_hostname.sh.template")}"

  vars {
    node_hostname = "${element(concat(local.master_private_dns_names, local.worker_private_dns_names), count.index)}"
  }
}
