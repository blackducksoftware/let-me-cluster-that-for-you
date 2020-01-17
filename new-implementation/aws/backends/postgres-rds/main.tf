
resource "aws_security_group" "allow_postgres" {
  name        = "${var.db_name}-postgres-sg"
  description = "Allow postgres inbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.db_name}-postgres-sg"
  }
}

resource "aws_security_group_rule" "allow_postgres_rule" {
  type            = "ingress"
  from_port       = 5432
  to_port         = 5432
  protocol        = "tcp"
  security_group_id = aws_security_group.allow_postgres.id
  source_security_group_id = var.security_groups
}

# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/2.13.0
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.db_name}postgres"

  engine            = "postgres"
  engine_version    = var.postgres_version
  instance_class    = "db.t2.large"
  allocated_storage = 10
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "${var.db_name}postgres"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = var.db_username

  password = var.db_password
  port     = "5432"

  vpc_security_group_ids = [ "${aws_security_group.allow_postgres.id}" ]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Name = var.db_name
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = var.subnets

  publicly_accessible = "false"
  # DB option group
  family = "postgres{var.postgres_version}"
  major_engine_version = var.postgres_version

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.db_name}-postgres-snapshot"

  # Database Deletion Protection
  deletion_protection = false
}