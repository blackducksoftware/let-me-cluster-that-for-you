//  Define the VPC.
resource "aws_vpc" "cluster" {
  cidr_block = "${local.vpc_cidr}"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.prefix} Cluster VPC"
  }
}

//  Create an Internet Gateway for the VPC.
resource "aws_internet_gateway" "cluster" {
  vpc_id = "${aws_vpc.cluster.id}"
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  tags {
    Name = "${var.prefix} Cluster IGW"
  }
}

//  Create a public subnet.
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.cluster.id}"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  cidr_block = "${local.subnet_cidr}"
//  availability_zone = "${lookup(var.subnetaz, var.region)}"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.cluster"]

  tags {
    Name = "${var.prefix} Cluster Public Subnet"
  }
}

//  Create a route table allowing all addresses access to the IGW.
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.cluster.id}"
  count = "${var.is_enabled == "true" ? "1" : "0"}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.cluster.id}"
  }

  tags {
    Name = "${var.prefix} Cluster Public Route Table"
  }
}

//  Now associate the route table with the public subnet - giving
//  all public subnet instances access to the internet.
resource "aws_route_table_association" "public-subnet" {
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}
