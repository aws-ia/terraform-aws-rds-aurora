variable "region" {
  default = "us-west-1"
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
  description = "If not password is provided a random password will be generated"
}
variable "tags" {
  default     = {}
  description = "tags, which could be used for additional tags"
}

