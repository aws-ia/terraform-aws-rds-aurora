###########
# Defaults
###########

terraform {
  required_version = ">= 0.14"
  backend "remote" {}
}

provider "aws" {
  alias  = "primary"
  region = var.region
}

provider "aws" {
  alias  = "secondary"
  region = var.sec_region
}

#########################
# Collect data
#########################

data "aws_availability_zones" "region_p" {
  state     = "available"
  provider  = aws.primary
}

data "aws_availability_zones" "region_s" {
  state     = "available"
  provider  = aws.secondary
}

/*
data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
}
*/

data "aws_rds_engine_version" "family" {
  engine    = var.engine
  version   = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  provider  = aws.primary
}

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

data "aws_partition" "current" {}

#########################
# Create Unique password
#########################

resource "random_password" "master_password" {
  length  = 10
  special = false
}

###########
# DB Subnet
###########

resource "aws_db_subnet_group" "private_p" {
  provider   = aws.primary
  name       = "${var.name}-sg"
  subnet_ids = var.Private_subnet_ids_p
  tags        = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_subnet_group" "private_s" {
  provider   = aws.secondary
  count      = var.setup_globaldb ? 1 : 0
  name       = "${var.name}-sg"
  subnet_ids = var.Private_subnet_ids_s
  tags        = {
    Name = "My DB subnet group"
  }
}

###########
# KMS
###########

resource "aws_kms_key" "kms_p" {
  provider                = aws.primary
  count                   = var.storage_encrypted ? 1 : 0
  description             = "KMS key for Aurora Storage Enryption"
  tags                    = var.tags
  # following causes terraform destory to fail. But this is needed so that old Aurora encrypted snapshots can be restored.
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_key" "kms_s" {
  provider                = aws.secondary
  count                   = var.setup_globaldb && var.storage_encrypted ? 1 : 0
  description             = "KMS key for Aurora Storage Enryption"
  tags                    = var.tags
  # following causes terraform destory to fail. But this is needed so that old Aurora encrypted snapshots can be restored.
  lifecycle {
    prevent_destroy = true
  }
}

###########
# IAM
###########

resource "aws_iam_role" "rds_enhanced_monitoring" {
  description         = "IAM Role for RDS Enhanced monitoring"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.monitoring_rds_assume_role.json
  managed_policy_arns = ["arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]
  tags                = var.tags
}

#############
# RDS Aurora
#############

# Aurora Global DB 
resource "aws_rds_global_cluster" "globaldb" {
  count                         = var.setup_globaldb ? 1 : 0
  provider                      = aws.primary
  global_cluster_identifier     = "${var.identifier}-globaldb"
  engine                        = var.engine
  engine_version                = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  storage_encrypted             = var.storage_encrypted
}

resource "aws_rds_cluster" "primary" {
  provider                        = aws.primary
  global_cluster_identifier       = var.setup_globaldb ? aws_rds_global_cluster.globaldb[0].id : null
  cluster_identifier              = "${var.identifier}-${var.region}"
  engine                          = var.engine
  engine_version                  = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  availability_zones              = [data.aws_availability_zones.region_p.names[0], data.aws_availability_zones.region_p.names[1], data.aws_availability_zones.region_p.names[2]]
  db_subnet_group_name            = aws_db_subnet_group.private_p.name
  port                            = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  database_name                   = var.setup_as_secondary ? null : var.database_name
  master_username                 = var.setup_as_secondary ? null : var.username
  master_password                 = var.setup_as_secondary ? null : (var.password == "" ? random_password.master_password.result : var.password)
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group_p.id
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.storage_encrypted ? aws_kms_key.kms_p[0].arn : null
  apply_immediately               = true
  skip_final_snapshot             = var.skip_final_snapshot
  snapshot_identifier             = var.snapshot_identifier != "" ? var.snapshot_identifier : null
  enabled_cloudwatch_logs_exports = local.logs_set
  tags                            = var.tags
  depends_on                      = [
    # When this Aurora cluster is setup as a secondary, setting up the dependency makes sure to delete this cluster 1st before deleting current primary Cluster during terraform destory
    # Comment out the following line if this cluster has changed role to be the primary Aurora cluster because of a failover for terraform destory to work
    #aws_rds_cluster_instance.secondary,
  ]
  lifecycle {
    ignore_changes = [
      replication_source_identifier,
    ]
  }
}

resource "aws_rds_cluster_instance" "primary" {
  count                         = var.primary_instance_count
  provider                      = aws.primary
  identifier                    = "${var.name}-${var.region}-${count.index + 1}"
  cluster_identifier            = aws_rds_cluster.primary.id
  engine                        = aws_rds_cluster.primary.engine
  engine_version                = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  auto_minor_version_upgrade    = var.setup_globaldb ? false : var.auto_minor_version_upgrade
  instance_class                = var.instance_class
  db_subnet_group_name          = aws_db_subnet_group.private_p.name
  db_parameter_group_name       = aws_db_parameter_group.aurora_db_parameter_group_p.id
  performance_insights_enabled  = true
  monitoring_interval           = var.monitoring_interval
  monitoring_role_arn           = aws_iam_role.rds_enhanced_monitoring.arn
  apply_immediately             = true
  tags                          = var.tags
}

# Secondary Aurora Cluster
resource "aws_rds_cluster" "secondary" {
  count                           = var.setup_globaldb ? 1 : 0
  provider                        = aws.secondary
  global_cluster_identifier       = aws_rds_global_cluster.globaldb[0].id
  cluster_identifier              = "${var.identifier}-${var.sec_region}"
  engine                          = var.engine
  engine_version                  = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  availability_zones              = [data.aws_availability_zones.region_s.names[0], data.aws_availability_zones.region_s.names[1], data.aws_availability_zones.region_s.names[2]] 
  db_subnet_group_name            = aws_db_subnet_group.private_s[0].name
  port                            = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group_s[0].id
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  source_region                   = var.storage_encrypted ? var.region : null
  kms_key_id                      = var.storage_encrypted ? aws_kms_key.kms_s[0].arn : null
  apply_immediately               = true
  skip_final_snapshot             = var.skip_final_snapshot
  tags                            = var.tags
  depends_on                      = [
    # When this Aurora cluster is setup as a secondary, setting up the dependency makes sure to delete this cluster 1st before deleting current primary Cluster during terraform destory
    # Comment out the following line if this cluster has changed role to be the primary Aurora cluster because of a failover for terraform destory to work
    aws_rds_cluster_instance.primary,
  ]
  lifecycle {
    ignore_changes = [
      replication_source_identifier,
    ]
  }
}

# Secondary Cluster Instances
resource "aws_rds_cluster_instance" "secondary" {
  count                         = var.setup_globaldb ? var.secondary_instance_count : 0
  provider                      = aws.secondary
  identifier                    = "${var.name}-${var.sec_region}-${count.index + 1}"
  cluster_identifier            = aws_rds_cluster.secondary[0].id
  engine                        = var.engine
  engine_version                = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  auto_minor_version_upgrade    = false
  instance_class                = var.instance_class
  db_subnet_group_name          = aws_db_subnet_group.private_s[0].name
  db_parameter_group_name       = aws_db_parameter_group.aurora_db_parameter_group_s[0].id
  performance_insights_enabled  = true
  monitoring_interval           = var.monitoring_interval
  monitoring_role_arn           = aws_iam_role.rds_enhanced_monitoring.arn
  apply_immediately             = true
  tags                          = var.tags
}

#############################
# RDS Aurora Parameter Groups
##############################

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group_p" {
  provider    = aws.primary
  name        = "${var.name}-cluster-parameter-group"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_cluster_pgroup_params : local.mysql_cluster_pgroup_params
    iterator = pblock

    content {
      name  = pblock.value.name
      value = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
}

resource "aws_db_parameter_group" "aurora_db_parameter_group_p" {
  provider    = aws.primary
  name        = "${var.name}-db-parameter-group"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-db-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_db_pgroup_params : local.mysql_db_pgroup_params
    iterator = pblock

    content {
      name  = pblock.value.name
      value = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group_s" {
  count       = var.setup_globaldb ? 1 : 0
  provider    = aws.secondary
  name        = "${var.name}-cluster-parameter-group"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_cluster_pgroup_params : local.mysql_cluster_pgroup_params
    iterator = pblock

    content {
      name  = pblock.value.name
      value = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
}

resource "aws_db_parameter_group" "aurora_db_parameter_group_s" {
  count       = var.setup_globaldb ? 1 : 0
  provider    = aws.secondary
  name        = "${var.name}-db-parameter-group"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-db-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_db_pgroup_params : local.mysql_db_pgroup_params
    iterator = pblock

    content {
      name  = pblock.value.name
      value = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
}

#############################
# Monitoring
##############################

resource "aws_sns_topic" "default_p" {
  provider  = aws.primary
  name      = "rds-events"
}

resource "aws_db_event_subscription" "default_p" {
  provider         = aws.primary
  name             = "${var.name}-rds-event-sub"
  sns_topic        = aws_sns_topic.default_p.arn
  source_type      = "db-cluster"
  source_ids       = [aws_rds_cluster.primary.id]
  event_categories = [
    "creation",
    "deletion",
    "failover",
    "failure",
    "maintenance",
    "notification",
  ]
}

resource "aws_sns_topic" "default_s" {
  count     = var.setup_globaldb ? 1 : 0
  provider  = aws.secondary
  name      = "rds-events"
}

resource "aws_db_event_subscription" "default_s" {
  count            = var.setup_globaldb ? 1 : 0
  provider         = aws.secondary
  name             = "${var.name}-rds-event-sub"
  sns_topic        = aws_sns_topic.default_s[0].arn
  source_type      = "db-cluster"
  source_ids       = [aws_rds_cluster.secondary[0].id]
  event_categories = [
    "creation",
    "deletion",
    "failover",
    "failure",
    "maintenance",
    "notification",
  ]
}