//  This security group allows intra-node communication on all ports with all
//  protocols.
resource "aws_security_group" "cluster-vpc" {
  name = "${var.prefix}-cluster-vpc"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  description = "Default security group that allows all instances in the VPC to talk to each other over any port and protocol."
  vpc_id = "${aws_vpc.cluster.id}"

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = true
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = true
  }

  tags {
    Name = "${var.prefix} Cluster Internal VPC"
  }
}

//  This security group allows public ingress to the instances for HTTP, HTTPS
//  and common HTTP/S proxy ports.
resource "aws_security_group" "cluster-http-public-ingress" {
  name = "${var.prefix}-cluster-http-public-ingress"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  description = "Security group that allows public ingress to instances, HTTP, HTTPS and more."
  vpc_id = "${aws_vpc.cluster.id}"

  //  HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTP Proxy
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS Proxy
  ingress {
    from_port = 8443
    to_port = 8443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix} Cluster HTTP Public Access"
  }
}

//  This security group allows public egress from the instances for HTTP and
//  HTTPS.
resource "aws_security_group" "cluster-http-public-egress" {
  name = "${var.prefix}-cluster-http-public-egress"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  description = "Security group that allows egress to the internet for instances over HTTP and HTTPS."
  vpc_id = "${aws_vpc.cluster.id}"

  //  HTTP
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix} Cluster HTTP Public Access"
  }
}

// This security group allows access from the instances to Amazon's RDS service.
resource "aws_security_group" "cluster-rds-egress" {
  name = "${var.prefix}-cluster-rds-egress"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  description = "Security group that allow egress to the Amazon RDS service for instances."
  vpc_id = "${aws_vpc.cluster.id}"

  //  amazon RDS
  egress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix} Cluster RDS Access"
  }
}

//  Security group which allows SSH access to a host. Used for the bastion.
resource "aws_security_group" "cluster-ssh" {
  name = "${var.prefix}-cluster-ssh"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  description = "Security group that allows public ingress over SSH."
  vpc_id = "${aws_vpc.cluster.id}"

  //  SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix} Cluster SSH Access"
  }
}
