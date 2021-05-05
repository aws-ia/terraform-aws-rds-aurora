###########
# Defaults
##########

terraform {
  required_version = ">= 0.14"

}

######
# Create Uniquie password
######

resource "random_password" "master_password" {
  length  = 10
  special = false
}

######
# Collect data
######

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
}

resource "aws_db_subnet_group" "private-2" {
  name       = "${var.name}-main"
  subnet_ids = data.aws_subnet_ids.private.ids

  tags = {
    Name = "My DB subnet group"
  }
}

#############
# RDS Aurora
#############
resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = var.identifier
  engine                  = var.engine
  availability_zones      = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  database_name           = var.database_name
  master_username         = var.username
  master_password         = var.password == "" ? random_password.master_password.result : var.password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  engine_version          = var.engine_version
  db_subnet_group_name    = aws_db_subnet_group.private-2.name
  port                    = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  storage_encrypted       = var.storage_encrypted
  skip_final_snapshot     = var.skip_final_snapshot
  tags                    = var.tags
}

resource "aws_rds_cluster_instance" "postgresql" {
  count                      = 3
  identifier                 = "${var.name}-${count.index + 1}"
  cluster_identifier         = aws_rds_cluster.postgresql.id
  engine                     = aws_rds_cluster.postgresql.engine
  engine_version             = aws_rds_cluster.postgresql.engine_version
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  instance_class             = var.instance_class
  db_subnet_group_name       = aws_db_subnet_group.private-2.name
  tags                       = var.tags
}

resource "aws_sns_topic" "default" {
  name = "rds-events"
}

resource "aws_db_event_subscription" "default" {
  name      = "${var.name}-rds-event-sub"
  sns_topic = aws_sns_topic.default.arn

  source_type = "db-cluster"
  source_ids  = [aws_rds_cluster.postgresql.id]

  event_categories = [
    "creation",
    "deletion",
    "failover",
    "failure",
    "maintenance",
    "notification",
  ]
}

resource "aws_db_parameter_group" "aurora_db_postgres11_parameter_group" {
  name        = "${var.name}-aurora-db-postgres11-parameter-group"
  family      = "aurora-postgresql11"
  description = "aurora-db-postgres11-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres11_parameter_group" {
  name        = "${var.name}-aurora-postgres11-cluster-parameter-group"
  family      = "aurora-postgresql11"
  description = "aurora-postgres11-cluster-parameter-group"
}