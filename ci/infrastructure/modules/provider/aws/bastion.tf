resource "aws_instance" "bastion" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"
//  ami                  = "${data.aws_ami.amazonlinux.id}"
  ami = "${data.aws_ami.rhel7.id}"
  instance_type = "${local.bastion_image_size}"
  subnet_id = "${aws_subnet.public-subnet.id}"

  security_groups = [
    "${aws_security_group.cluster-vpc.id}",
    "${aws_security_group.cluster-ssh.id}",
    "${aws_security_group.cluster-http-public-egress.id}",
  ]

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name = "${var.prefix} Cluster Bastion"
  }

  connection {
    type = "ssh"
    user = "${local.cluster_ssh_user}"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum makecache fast",
      "sudo yum update -y",
      "sudo yum install -y python-passlib",
      "sudo yum install -y httpd"
    ]
  }
}
