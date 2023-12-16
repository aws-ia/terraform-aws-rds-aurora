variable "region" {
  description = "The name of the primary AWS region you wish to deploy into"
  type        = string
  default     = "us-east-2"
}

variable "sec_region" {
  description = "The name of the secondary AWS region you wish to deploy into"
  type        = string
  default     = "us-west-2"
}

variable "account" {
  type        = string
  description = "account, which could be AWS Account Name or Number"
  default     = null
}

variable "namespace" {
  description = "namespace, which could be your organiation name, e.g. amazon"
  type        = string
  default     = "aws"
}
variable "env" {
  description = "environment, e.g. 'sit', 'uat', 'prod' etc"
  type        = string
  default     = "dev"
}

variable "identifier" {
  description = "Cluster identifier"
  type        = string
  default     = "aurora"
}

variable "name" {
  description = "Prefix for resource names"
  type        = string
  default     = "aurora"
}

variable "delimiter" {
  description = "delimiter, which could be used between name, namespace and env"
  type        = string
  default     = "-"
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

#tfsec:ignore:general-secrets-no-plaintext-exposure
variable "password" {
  default     = ""
  type        = string
  description = "If no password is provided, a random password will be generated"
}

variable "manage_master_user_password" {
  description = "Manage master user password using AWS Secrets Manager"
  type        = bool
  default     = false
}

/*
variable "tags" {
  default     = {}
  description = "tags, which could be used for additional tags"
}
*/

variable "engine" {
  description = "Aurora database engine type: aurora, aurora-mysql, aurora-postgresql"
  type        = string
  default     = "aurora-postgresql"
  #default     = "aurora-mysql"
}

variable "engine_version_pg" {
  description = "Aurora PostgreSQL database engine version."
  type        = string
  default     = "15.4"
}

variable "engine_version_mysql" {
  description = "Aurora MySQL database engine version."
  type        = string
  default     = "8.0.mysql_aurora.3.05.1"
}

variable "setup_globaldb" {
  description = "Setup Aurora Global Database with 1 Primary and 1 X-region Secondary cluster"
  type        = bool
  default     = false
}

variable "setup_as_secondary" {
  description = "Setup aws_rds_cluster.primary Terraform resource as Secondary Aurora cluster after an unplanned Aurora Global DB failover"
  type        = bool
  default     = false
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
  type        = string
  default     = ""
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying Aurora storage layer should be encrypted"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "Specifies Aurora storage type: Aurora Standard vs. Aurora I/O-Optimized"
  type        = string
  default     = ""
}

variable "primary_instance_count" {
  description = "instance count for primary Aurora cluster"
  type        = number
  default     = 2
}

variable "secondary_instance_count" {
  description = "instance count for secondary Aurora cluster"
  type        = number
  default     = 1
}

variable "instance_class" {
  type        = string
  description = "Aurora DB Instance type. Specify db.serverless to create Aurora Serverless v2 instances."
  default     = "db.r7g.large"
}