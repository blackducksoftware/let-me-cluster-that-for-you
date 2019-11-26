//  Create the internal DNS.
resource "aws_route53_zone" "internal" {
  name = "${var.prefix}.cluster"
//  count = "${local.support_count}"
  count = "0"
  comment = "${var.prefix} Cluster Internal DNS"
  vpc_id = "${aws_vpc.cluster.id}"
  tags {
    Name = "${var.prefix} Internal DNS"
  }
}

// Routes for master instances
resource "aws_route53_record" "masters" {
//  count = "${var.masters}"
  count = "0"
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name = "${element(local.master_cluster_dns_names, count.index)}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_instance.masters.*.private_ip, count.index)}"]
}

// Routes for worker instances
resource "aws_route53_record" "workers" {
//  count = "${var.workers}"
  count = "0"
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name = "${element(local.worker_cluster_dns_names, count.index)}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_instance.workers.*.private_ip, count.index)}"]
}
