variable "region" {
  type        = string
  description = "The name of the primary region you wish to deploy into"
}

variable "sec_region" {
  type        = string
  description = "The name of the secondary region you wish to deploy into"
}

variable "identifier" {
  description = "Cluster identifier"
  type        = string
  default     = "tfm-aurora"
}

variable "name" {
  description = "Prefix for resource names"
  type        = string
  default     = "tfm-aurora"
}

/*
variable "vpc_id" {
  type        = string
  description = "VPC id"
}
*/

variable "Private_subnet_ids_p" {
  type        = list(string)
  description = "A list of private subnet IDs in your Primary AWS region VPC"
}

variable "Private_subnet_ids_s" {
  type        = list(string)
  description = "A list of private subnet IDs in your Secondary AWS region VPC"
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = []
}

variable "primary_instance_count" {
  description = "instance count for primary cluster"
  default = 2
}

variable "secondary_instance_count" {
  description = "instance count for secondary cluster"
  default = 1
}

variable "instance_class" {
  type        = string
  description = "Instance type to use at replica instance"
  default     = "db.r5.large"
}

variable "skip_final_snapshot" {
  type        = string
  description = "skip creating a final snapshot before deleting the DB"
  #set the value to false for production workload
  default     = true
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = "mydb"
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "password" {
  description = "Master DB password"
  type        = string
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00"
}

variable "port" {
  description = "The port on which to accept connections"
  type        = string
  default     = ""
}

variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Aurora database engine type: aurora (for MySQL 5.6-compatible Aurora), aurora-mysql (for MySQL 5.7-compatible Aurora), aurora-postgresql"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_pg" {
  description = "Aurora database engine version."
  type        = string
  default     = "12.4"
}

variable "engine_version_mysql" {
  description = "Aurora database engine version."
  type        = string
  default     = "5.7.mysql_aurora.2.10.0"
}

variable "setup_globaldb" {
  description = "Setup Aurora Global Database with 1 Primary and 1 X-region Secondary cluster"
  type        = bool
  default     = false
}

variable "setup_as_secondary" {
  description = "Setup Aurora Global Database Secondary cluster after an unplanned failover"
  type        = bool
  default     = false
}

variable "replica_scale_enabled" {
  description = "Whether to enable autoscaling for Aurora read replica auto scaling"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default = {
    Name = "tfm-aws-aurora-db"
  }
}

variable "monitoring_interval" {
  description = "Enhanced Monitoring interval in seconds"
  type        = number
  default     = 1
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "Valid values for var: monitoring_interval are (0, 1, 5, 10, 15, 30, 60)."
  } 
}

variable "snapshot_identifier" {
  description = "id of snapshot to restore. If you do not want to restore a db, leave the default empty string."
  default     = ""
}

variable "enable_audit_log" {
  description = "Enable MySQL audit log export to Amazon Cloudwatch."
  default     = false
}

variable "enable_error_log" {
  description = "Enable MySQL error log export to Amazon Cloudwatch."
  default     = false
}

variable "enable_general_log" {
  description = "Enable MySQL general log export to Amazon Cloudwatch."
  default     = false
}

variable "enable_slowquery_log" {
  description = "Enable MySQL slowquery log export to Amazon Cloudwatch."
  default     = false
}

variable "enable_postgresql_log" {
  description = "Enable PostgreSQL log export to Amazon Cloudwatch."
  default     = false
}