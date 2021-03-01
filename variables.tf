variable "region" {
  type        = string
  description = "The name of the region you wish to deploy into"
  default     = "us-east-1"
}

variable "name" {
  description = "Name given resources"
  type        = string
  default     = "aws-quickstart"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

# variable "avaliability_zones" {
#     type = string
#     description = "which AZ to deploy the DB in"
# }

# variable "replica_count" {
#   description = "Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead."
#   default     = 1
# }

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

variable "skip_final_snapshot" {
  type        = string
  description = "skip creating a final snapshot before deleting the DB"
  default     = true
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
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
  description = "Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql"
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

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default = {
    Name = "quickstart-aurora-db"
  }
}