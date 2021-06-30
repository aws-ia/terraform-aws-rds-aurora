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
variable "account" {
  description = "account, which could be AWS Account Name or Number"
  default     = "rds-test"
}
variable "name" {
  description = "deployment name"
  default     = "aurora"
}
variable "delimiter" {
  description = "delimiter, which could be used between name, namespace and env"
  default     = "-"
}
variable "attributes" {
  default     = []
  description = "atttributes, which could be used for additional attributes"
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