###########
# Defaults
###########

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
  state    = "available"
  provider = aws.primary
}

data "aws_availability_zones" "region_s" {
  state    = "available"
  provider = aws.secondary
}

/*
data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
}
*/

data "aws_rds_engine_version" "family" {
  engine   = var.engine
  version  = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  provider = aws.primary
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

####################################
# Generate Final snapshot identifier
####################################

resource "random_id" "snapshot_id" {

  keepers = {
    id = var.identifier
  }

  byte_length = 4
}

###########
# DB Subnet
###########

resource "aws_db_subnet_group" "private_p" {
  provider   = aws.primary
  name       = "${var.name}-sg"
  subnet_ids = var.private_subnet_ids_p
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_subnet_group" "private_s" {
  provider   = aws.secondary
  count      = var.setup_globaldb ? 1 : 0
  name       = "${var.name}-sg"
  subnet_ids = var.private_subnet_ids_s
  tags = {
    Name = "My DB subnet group"
  }
}

###########
# KMS
###########

resource "aws_kms_key" "kms_p" {
  provider    = aws.primary
  count       = var.storage_encrypted ? 1 : 0
  description = "KMS key for Aurora Storage Encryption"
  tags        = var.tags
  # following causes terraform destroy to fail. But this is needed so that Aurora encrypted snapshots can be restored for your production workload.
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_key" "kms_s" {
  provider    = aws.secondary
  count       = var.setup_globaldb && var.storage_encrypted ? 1 : 0
  description = "KMS key for Aurora Storage Encryption"
  tags        = var.tags
  # following causes terraform destroy to fail. But this is needed so that Aurora encrypted snapshots can be restored for your production workload.
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
  count                     = var.setup_globaldb ? 1 : 0
  provider                  = aws.primary
  global_cluster_identifier = "${var.identifier}-globaldb"
  engine                    = var.engine
  engine_version            = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  database_name             = (var.snapshot_identifier != "") ? null : var.database_name
  storage_encrypted         = var.storage_encrypted
}

resource "aws_rds_cluster" "primary" {
  provider                         = aws.primary
  global_cluster_identifier        = var.setup_globaldb ? aws_rds_global_cluster.globaldb[0].id : null
  cluster_identifier               = "${var.identifier}-${var.region}"
  engine                           = var.engine
  engine_version                   = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  allow_major_version_upgrade      = var.allow_major_version_upgrade
  availability_zones               = [data.aws_availability_zones.region_p.names[0], data.aws_availability_zones.region_p.names[1], data.aws_availability_zones.region_p.names[2]]
  db_subnet_group_name             = aws_db_subnet_group.private_p.name
  port                             = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  database_name                    = var.setup_as_secondary || (var.snapshot_identifier != "") ? null : var.database_name
  master_username                  = var.setup_as_secondary || (var.snapshot_identifier != "") ? null : var.username
  master_password                  = var.setup_as_secondary || (var.snapshot_identifier != "") ? null : (var.password == "" ? random_password.master_password.result : var.password)
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group_p.id
  db_instance_parameter_group_name = var.allow_major_version_upgrade ? aws_db_parameter_group.aurora_db_parameter_group_p.id : null
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = var.preferred_backup_window
  #tfsec:ignore:aws-rds-encrypt-cluster-storage-data
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.storage_encrypted ? aws_kms_key.kms_p[0].arn : null
  apply_immediately               = true
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${var.region}-${random_id.snapshot_id.hex}"
  snapshot_identifier             = var.snapshot_identifier != "" ? var.snapshot_identifier : null
  enabled_cloudwatch_logs_exports = local.logs_set
  tags                            = var.tags
  depends_on = [
    # When this Aurora cluster is setup as a secondary, setting up the dependency makes sure to delete this cluster 1st before deleting current primary Cluster during terraform destroy
    # Comment out the following line if this cluster has changed role to be the primary Aurora cluster because of a failover for terraform destroy to work
    #aws_rds_cluster_instance.secondary,
  ]
  lifecycle {
    ignore_changes = [
      replication_source_identifier,
      # Since Terraform doesn't allow to conditionally specify a lifecycle policy, this can't be done dynamically.
      # Uncomment the following line for Aurora Global Database to do major version upgrade as per https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster
      # engine_version,
    ]
  }
}

#tfsec:ignore:aws-rds-enable-performance-insights-encryption tfsec:ignore:aws-rds-enable-performance-insights
resource "aws_rds_cluster_instance" "primary" {
  count                        = var.primary_instance_count
  provider                     = aws.primary
  identifier                   = "${var.name}-${var.region}-${count.index + 1}"
  cluster_identifier           = aws_rds_cluster.primary.id
  engine                       = aws_rds_cluster.primary.engine
  engine_version               = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  auto_minor_version_upgrade   = var.setup_globaldb ? false : var.auto_minor_version_upgrade
  instance_class               = var.instance_class
  db_subnet_group_name         = aws_db_subnet_group.private_p.name
  db_parameter_group_name      = aws_db_parameter_group.aurora_db_parameter_group_p.id
  performance_insights_enabled = true
  monitoring_interval          = var.monitoring_interval
  monitoring_role_arn          = aws_iam_role.rds_enhanced_monitoring.arn
  apply_immediately            = true
  tags                         = var.tags
}

# Secondary Aurora Cluster
resource "aws_rds_cluster" "secondary" {
  count                            = var.setup_globaldb ? 1 : 0
  provider                         = aws.secondary
  global_cluster_identifier        = aws_rds_global_cluster.globaldb[0].id
  cluster_identifier               = "${var.identifier}-${var.sec_region}"
  engine                           = var.engine
  engine_version                   = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  allow_major_version_upgrade      = var.allow_major_version_upgrade
  availability_zones               = [data.aws_availability_zones.region_s.names[0], data.aws_availability_zones.region_s.names[1], data.aws_availability_zones.region_s.names[2]]
  db_subnet_group_name             = aws_db_subnet_group.private_s[0].name
  port                             = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group_s[0].id
  db_instance_parameter_group_name = var.allow_major_version_upgrade ? aws_db_parameter_group.aurora_db_parameter_group_s[0].id : null
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = var.preferred_backup_window
  source_region                    = var.storage_encrypted ? var.region : null
  kms_key_id                       = var.storage_encrypted ? aws_kms_key.kms_s[0].arn : null
  apply_immediately                = true
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier        = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${var.sec_region}-${random_id.snapshot_id.hex}"
  enabled_cloudwatch_logs_exports  = local.logs_set
  tags                             = var.tags
  depends_on = [
    # When this Aurora cluster is setup as a secondary, setting up the dependency makes sure to delete this cluster 1st before deleting current primary Cluster during terraform destroy
    # Comment out the following line if this cluster has changed role to be the primary Aurora cluster because of a failover for terraform destroy to work
    aws_rds_cluster_instance.primary,
  ]
  lifecycle {
    ignore_changes = [
      replication_source_identifier,
      # Since Terraform doesn't allow to conditionally specify a lifecycle policy, this can't be done dynamically.
      # Uncomment the following line for Aurora Global Database to do major version upgrade as per https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster
      # engine_version,																											  
    ]
  }
}

# Secondary Cluster Instances
#tfsec:ignore:aws-rds-enable-performance-insights-encryption tfsec:ignore:aws-rds-enable-performance-insights
resource "aws_rds_cluster_instance" "secondary" {
  count                        = var.setup_globaldb ? var.secondary_instance_count : 0
  provider                     = aws.secondary
  identifier                   = "${var.name}-${var.sec_region}-${count.index + 1}"
  cluster_identifier           = aws_rds_cluster.secondary[0].id
  engine                       = var.engine
  engine_version               = var.engine == "aurora-postgresql" ? var.engine_version_pg : var.engine_version_mysql
  auto_minor_version_upgrade   = false
  instance_class               = var.instance_class
  db_subnet_group_name         = aws_db_subnet_group.private_s[0].name
  db_parameter_group_name      = aws_db_parameter_group.aurora_db_parameter_group_s[0].id
  performance_insights_enabled = true
  monitoring_interval          = var.monitoring_interval
  monitoring_role_arn          = aws_iam_role.rds_enhanced_monitoring.arn
  apply_immediately            = true
  tags                         = var.tags
}

#############################
# RDS Aurora Parameter Groups
##############################

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group_p" {
  provider    = aws.primary
  name_prefix = "${var.name}-cluster-"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_cluster_pgroup_params : local.mysql_cluster_pgroup_params
    iterator = pblock

    content {
      name         = pblock.value.name
      value        = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "aurora_db_parameter_group_p" {
  provider    = aws.primary
  name_prefix = "${var.name}-db-"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-db-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_db_pgroup_params : local.mysql_db_pgroup_params
    iterator = pblock

    content {
      name         = pblock.value.name
      value        = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group_s" {
  count       = var.setup_globaldb ? 1 : 0
  provider    = aws.secondary
  name_prefix = "${var.name}-cluster-"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_cluster_pgroup_params : local.mysql_cluster_pgroup_params
    iterator = pblock

    content {
      name         = pblock.value.name
      value        = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "aurora_db_parameter_group_s" {
  count       = var.setup_globaldb ? 1 : 0
  provider    = aws.secondary
  name_prefix = "${var.name}-db-"
  family      = data.aws_rds_engine_version.family.parameter_group_family
  description = "aurora-db-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "aurora-postgresql" ? local.apg_db_pgroup_params : local.mysql_db_pgroup_params
    iterator = pblock

    content {
      name         = pblock.value.name
      value        = pblock.value.value
      apply_method = pblock.value.apply_method
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

#############################
# Monitoring
##############################

#tfsec:ignore:aws-sns-enable-topic-encryption
resource "aws_sns_topic" "default_p" {
  provider = aws.primary
  name     = "rds-events"
}

resource "aws_db_event_subscription" "default_p" {
  provider    = aws.primary
  name        = "${var.name}-rds-event-sub"
  sns_topic   = aws_sns_topic.default_p.arn
  source_type = "db-cluster"
  source_ids  = [aws_rds_cluster.primary.id]
  event_categories = [
    "creation",
    "deletion",
    "failover",
    "failure",
    "maintenance",
    "notification",
  ]
}

#tfsec:ignore:aws-sns-enable-topic-encryption
resource "aws_sns_topic" "default_s" {
  count    = var.setup_globaldb ? 1 : 0
  provider = aws.secondary
  name     = "rds-events"
}

resource "aws_db_event_subscription" "default_s" {
  count       = var.setup_globaldb ? 1 : 0
  provider    = aws.secondary
  name        = "${var.name}-rds-event-sub"
  sns_topic   = aws_sns_topic.default_s[0].arn
  source_type = "db-cluster"
  source_ids  = [aws_rds_cluster.secondary[0].id]
  event_categories = [
    "creation",
    "deletion",
    "failover",
    "failure",
    "maintenance",
    "notification",
  ]
}

resource "aws_cloudwatch_metric_alarm" "cpu_util_p" {
  count               = var.primary_instance_count
  provider            = aws.primary
  alarm_name          = "CPU_Util-${element(split(",", join(",", aws_rds_cluster_instance.primary.*.id)), count.index)}"
  alarm_description   = "This metric monitors Aurora Instance CPU Utilization"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "80"
  statistic           = "Maximum"
  unit                = "Percent"
  alarm_actions       = [aws_sns_topic.default_p.arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBInstanceIdentifier = "${element(aws_rds_cluster_instance.primary.*.id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "free_local_storage_p" {
  count               = var.primary_instance_count
  provider            = aws.primary
  alarm_name          = "Free_local_storage-${element(split(",", join(",", aws_rds_cluster_instance.primary.*.id)), count.index)}"
  alarm_description   = "This metric monitors Aurora Local Storage Utilization"
  metric_name         = "FreeLocalStorage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "5368709120"
  statistic           = "Average"
  unit                = "Bytes"
  alarm_actions       = [aws_sns_topic.default_p.arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBInstanceIdentifier = "${element(aws_rds_cluster_instance.primary.*.id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "free_random_access_memory_p" {
  count               = var.primary_instance_count
  provider            = aws.primary
  alarm_name          = "FreeableMemory-${element(split(",", join(",", aws_rds_cluster_instance.primary.*.id)), count.index)}"
  alarm_description   = "This metric monitors Aurora Instance Random Access Memory Utilization"
  metric_name         = "FreeableMemory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "2147483648"
  statistic           = "Average"
  unit                = "Bytes"
  alarm_actions       = [aws_sns_topic.default_p.arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBInstanceIdentifier = "${element(aws_rds_cluster_instance.primary.*.id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "pg_max_used_tx_ids_p" {
  count               = var.engine == "aurora-postgresql" ? 1 : 0
  provider            = aws.primary
  alarm_name          = "PG_MaxUsedTxIDs-${aws_rds_cluster.primary.id}"
  alarm_description   = "This metric monitors Aurora PostgreSQL Max Used Tx IDs"
  metric_name         = "MaximumUsedTransactionIDs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "600000000"
  statistic           = "Average"
  unit                = "Count"
  alarm_actions       = [aws_sns_topic.default_p.arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBClusterIdentifier = "${aws_rds_cluster.primary.id}"
    Role                = "WRITER"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_util_s" {
  count               = var.setup_globaldb ? var.secondary_instance_count : 0
  provider            = aws.secondary
  alarm_name          = "CPU_Util-${element(split(",", join(",", aws_rds_cluster_instance.secondary.*.id)), count.index)}"
  alarm_description   = "This metric monitors Aurora Instance CPU Utilization"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "80"
  statistic           = "Maximum"
  unit                = "Percent"
  alarm_actions       = [aws_sns_topic.default_s[0].arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBInstanceIdentifier = "${element(aws_rds_cluster_instance.secondary.*.id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "free_local_storage_s" {
  count               = var.setup_globaldb ? var.secondary_instance_count : 0
  provider            = aws.secondary
  alarm_name          = "Free_local_storage-${element(split(",", join(",", aws_rds_cluster_instance.secondary.*.id)), count.index)}"
  alarm_description   = "This metric monitors Aurora Local Storage Utilization"
  metric_name         = "FreeLocalStorage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "5368709120"
  statistic           = "Average"
  unit                = "Bytes"
  alarm_actions       = [aws_sns_topic.default_s[0].arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBInstanceIdentifier = "${element(aws_rds_cluster_instance.secondary.*.id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "free_random_access_memory_s" {
  count               = var.setup_globaldb ? var.secondary_instance_count : 0
  provider            = aws.secondary
  alarm_name          = "FreeableMemory-${element(split(",", join(",", aws_rds_cluster_instance.secondary.*.id)), count.index)}"
  alarm_description   = "This metric monitors Aurora Instance Random Access Memory Utilization"
  metric_name         = "FreeableMemory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "2147483648"
  statistic           = "Average"
  unit                = "Bytes"
  alarm_actions       = [aws_sns_topic.default_s[0].arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBInstanceIdentifier = "${element(aws_rds_cluster_instance.secondary.*.id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "pg_max_used_tx_ids_s" {
  count               = (var.engine == "aurora-postgresql") && var.setup_globaldb ? 1 : 0
  provider            = aws.secondary
  alarm_name          = "PG_MaxUsedTxIDs-${aws_rds_cluster.secondary[0].id}"
  alarm_description   = "This metric monitors Aurora PostgreSQL Max Used Tx IDs"
  metric_name         = "MaximumUsedTransactionIDs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  treat_missing_data  = "notBreaching"
  period              = "60"
  threshold           = "600000000"
  statistic           = "Average"
  unit                = "Count"
  alarm_actions       = [aws_sns_topic.default_s[0].arn]
  namespace           = "AWS/RDS"
  dimensions = {
    DBClusterIdentifier = "${aws_rds_cluster.secondary[0].id}"
    Role                = "WRITER"
  }
}