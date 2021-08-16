variable "region" {
  description = "The name of the primary region you wish to deploy into"
  default = "us-east-2"
}

variable "sec_region" {
  description = "The name of the secondary region you wish to deploy into"
  default = "us-west-2"
}

variable "namespace" {
  description = "namespace, which could be your organiation name, e.g. amazon"
  default     = "aws"
}
variable "env" {
  description = "environment, e.g. 'sit', 'uat', 'prod' etc"
  default     = "dev"
}
variable "name" {
  description = "deployment name"
  default     = "aurora"
}
variable "delimiter" {
  description = "delimiter, which could be used between name, namespace and env"
  default     = "-"
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "password" {
  default     = ""
  description = "If no password is provided, a random password will be generated"
}
variable "tags" {
  default     = {}
  description = "tags, which could be used for additional tags"
}
variable "engine" {
  description = "Aurora database engine type: aurora, aurora-mysql, aurora-postgresql"
  type        = string
  default     = "aurora-postgresql"
  #default     = "aurora-mysql"
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

variable "monitoring_interval" {
  description = "Enhanced Monitoring interval in seconds"
  type        = number
  default     = 1
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "Valid values for var: monitoring_interval are (0, 1, 5, 10, 15, 30, 60)."
  } 
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  type        = bool
  default     = false
}