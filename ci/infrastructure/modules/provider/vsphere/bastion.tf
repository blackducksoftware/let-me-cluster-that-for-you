resource "vsphere_virtual_machine" "bastion" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  name = "${var.prefix} Cluster Bastion"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${local.bastion_cpus}"
  memory = "${local.bastion_memory}"
  guest_id = "${data.vsphere_virtual_machine.bastion_template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.bastion_template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.bastion_template.network_interface_types[0]}"
  }

  disk {
    label = "disk0"
    size = "${data.vsphere_virtual_machine.bastion_template.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.bastion_template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.bastion_template.disks.0.thin_provisioned}"
  }

/*
  timeouts {
    create = "${var.instance_create_timeout}m"
  }
*/

  clone {
    template_uuid = "${data.vsphere_virtual_machine.bastion_template.id}"

/*
    customize {
      linux_options {
        host_name = "bastion"
        domain = "${var.domain_name}"
      }

      network_interface {}
    }
*/
  }

  connection {
    type = "ssh"
    user = "${local.bastion_ssh_user}"
    password = "${var.bastion_ssh_user_password}"
    agent = "false"
  }

  provisioner "local-exec" {
    command = "echo 'ssh user: ${local.cluster_ssh_user}, ssh password: ${var.cluster_ssh_user_password}'"
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
      "sudo yum clean all",
      "sudo sed -i -e 's/^search[[:blank:]]\\(.\\+\\)\\( opssight\\.internal\\)\\{0,1\\}$/search opssight.internal \\1/' /etc/resolv.conf",
      "sudo systemctl stop firewalld || /bin/true",
      "sudo systemctl disable firewalld || /bin/true",
    ]
  }
}
