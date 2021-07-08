variable "region" {
  type        = string
  description = "The name of the region you wish to deploy into"
}

variable "identifier" {
  description = "Cluster identifier"
  type        = string
  default     = "rds"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = []
}

variable "instance_class" {
  type        = string
  description = "Instance type to use at replica instance"
  default     = "db.r4.large"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create in the cluster"
  default     = 3
}

variable "skip_final_snapshot" {
  type        = string
  description = "skip creating a final snapshot before deleting the DB"
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
  default     = ""
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "snapshot_identifier" {
  description = "id of snapshot to restore"
  default     = ""
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  default     = false
}

variable "db_cluster_parameter_group_name" {
  description = "Name of the DB parameter group to associate."
  default     = ""
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
  default     = true
}

variable "kms_key_id" {
  description = "KMS Key ID that must be set when storage encrypted = 'false'"
  default     = ""
}

variable "engine" {
  description = "Aurora database engine type, currently aurora, aurora-postgresql"
  type        = string
  default     = "aurora"
}

variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
  default     = "5.6.10a"
}

variable "replica_scale_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora (MySQL) read replicas"
  type        = bool
  default     = false
}

variable "enable_audit_log" {
  description = "Enable audit log."
  default     = false
}

variable "enable_error_log" {
  description = "Enable error log."
  default     = true
}

variable "enable_general_log" {
  description = "Enable general log."
  default     = true
}

variable "enable_slowquery_log" {
  description = "Enable slowquery log."
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default = {
    Name = "tfm-aws-aurora-db"
  }
}