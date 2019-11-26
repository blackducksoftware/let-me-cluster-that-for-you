//  Create an SSH keypair
resource "aws_key_pair" "keypair" {
  key_name = "${var.key_name}"
  count = "${var.is_enabled == "true" ? "${var.masters}" : "0"}"
  public_key = "${file(var.public_key_path)}"
}

//  Create the userdata script for setup.
data "template_file" "instance-setup" {
  template = "${file("${path.module}/setup.sh")}"
}

//  Launch the master nodes.
resource "aws_instance" "masters" {
  ami = "${data.aws_ami.rhel7.id}"
  count = "${var.is_enabled == "true" ? "${var.masters}" : "0"}"
  instance_type = "${local.masterimagesize}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.cluster-instance-profile.id}"
  user_data = "${data.template_file.instance-setup.rendered}"

  security_groups = [
    "${aws_security_group.cluster-vpc.id}",
    "${aws_security_group.cluster-http-public-ingress.id}",
    "${aws_security_group.cluster-http-public-egress.id}",
    "${aws_security_group.cluster-ssh.id}",
  ]

  root_block_device {
    volume_size = 50
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name = "${var.prefix} Cluster Master ${count.index}"
  }

  connection {
    type = "ssh"
    user = "${local.cluster_ssh_user}"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }

  timeouts {
    create = "${var.instance_create_timeout}m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum-config-manager --enable rhui-REGION-rhel-server-extras",
      "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum makecache fast",
      "sudo yum update -y",
      "sudo yum install -y pdsh",
    ]
  }
}


//  Create the workers.
resource "aws_instance" "workers" {
  ami = "${data.aws_ami.rhel7.id}"
  count = "${var.is_enabled == "true" ? "${var.workers}" : "0"}"
  instance_type = "${local.workerimagesize}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.cluster-instance-profile.id}"
  user_data = "${data.template_file.instance-setup.rendered}"

  security_groups = [
    "${aws_security_group.cluster-vpc.id}",
    "${aws_security_group.cluster-http-public-ingress.id}",
    "${aws_security_group.cluster-http-public-egress.id}",
    "${aws_security_group.cluster-ssh.id}",
    "${aws_security_group.cluster-rds-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name = "${var.prefix} Cluster Worker ${count.index}"
  }

  timeouts {
    create = "${var.instance_create_timeout}m"
  }

  connection {
    type = "ssh"
    user = "${local.cluster_ssh_user}"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum-config-manager --enable rhui-REGION-rhel-server-extras",
      "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum makecache fast",
      "sudo yum update -y",
      "sudo yum install -y pdsh",
    ]
  }
}
