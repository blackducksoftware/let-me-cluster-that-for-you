resource "aws_db_instance" "default" {
  allocated_storage     = "${var.db_size_in_gb}"
  //max_allocated_storage = "${var.db_size_in_gb}"
  storage_type          = "gp2"
  engine                = "postgres"
  engine_version        = "${var.postgres_version}"
  instance_class        = "${var.db_instance_class}"
  identifier            = "${var.database_name}"
  username              = "${var.master_username}"
  password              = "${var.master_user_password}"
  skip_final_snapshot   = "${var.db_snapshot}"
  final_snapshot_identifier = "${var.database_name}-snapshot"
  multi_az = "${var.multi_az}"
  storage_encrypted    = "true"
  parameter_group_name = "${var.db_parameter_group}"
  port                 = "${var.db_port}"
  tags = {
    Name       = "${var.database_name}_postgres"
  }
  timeouts {
    create = "${var.db_create_timeout}m"
  }
}

data "aws_vpc" "default" {
  default = "true"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name = "default"
}