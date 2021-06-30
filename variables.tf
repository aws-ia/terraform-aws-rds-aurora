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

variable "instance_class" {
  type        = string
  description = "Instance type to use at replica instance"
  default     = "db.r5.large"
}

variable "skip_final_snapshot" {
  type        = string
  description = "skip creating a final snapshot before deleting the DB"
  #set the value to false for actual workload
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

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
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
  default     = true
}

variable "engine" {
  description = "Aurora database engine type: aurora (for MySQL 5.6-compatible Aurora), aurora-mysql (for MySQL 5.7-compatible Aurora), aurora-postgresql"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
  default     = "12.4"
}

variable "setup_globaldb" {
  description = "Setup Aurora Global Database with 1 Primary and 1 X-region Secondary cluster"
  type        = bool
  default     = true
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