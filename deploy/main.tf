terraform {
  required_version = ">= 1.0.0"
  backend "remote" {}
}

######################################
# Defaults
######################################

provider "aws" {
  region = var.region
}

resource "random_string" "rand4" {
  length  = 4
  special = false
  upper   = false
}

######################################
# Generate Tags
######################################

module "vpc_label" {
  source    = "aws-ia/label/aws"
  version   = "0.0.2"
  region    = var.region
  namespace = var.namespace
  env       = var.env
  name      = "${var.name}-${random_string.rand4.result}"
  delimiter = var.delimiter
  tags      = tomap({ propogate_at_launch = "true", "terraform" = "true" })
}

######################################
# Create VPC
######################################

module "aurora_vpc_p" {
  source               = "aws-ia/vpc/aws"
  version              = "0.1.0"
  name                 = "aurora-vpc"
  region               = var.region
  cidr                 = "10.0.0.0/16"
  public_subnets       = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  private_subnets_a    = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
  enable_dns_hostnames = true
  tags                 = module.vpc_label.tags
  create_vpc           = true
}

module "aurora_vpc_s" {
  source               = "aws-ia/vpc/aws"
  version              = "0.1.0"
  name                 = "aurora-vpc"
  region               = var.sec_region
  cidr                 = "10.0.0.0/16"
  public_subnets       = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  private_subnets_a    = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
  enable_dns_hostnames = true
  tags                 = module.vpc_label.tags
  create_vpc           = var.setup_globaldb ? true : false
}

######################################
# Create Aurora DB
######################################

#tfsec:ignore:aws-rds-enable-performance-insights-encryption tfsec:ignore:aws-rds-enable-performance-insights
module "aurora" {
  source     = "../"
  region     = var.region
  sec_region = var.sec_region
  #vpc_id                  = module.aurora_vpc.vpc_id
  Private_subnet_ids_p     = [module.aurora_vpc_p.private_subnet_1a_id, module.aurora_vpc_p.private_subnet_2a_id, module.aurora_vpc_p.private_subnet_3a_id]
  Private_subnet_ids_s     = var.setup_globaldb ? [module.aurora_vpc_s.private_subnet_1a_id, module.aurora_vpc_s.private_subnet_2a_id, module.aurora_vpc_s.private_subnet_3a_id] : null
  engine                   = var.engine
  engine_version_pg        = var.engine_version_pg
  engine_version_mysql     = var.engine_version_mysql
  username                 = var.username
  password                 = var.password
  setup_globaldb           = var.setup_globaldb
  setup_as_secondary       = var.setup_as_secondary
  tags                     = module.vpc_label.tags
  monitoring_interval      = var.monitoring_interval
  storage_encrypted        = var.storage_encrypted
  primary_instance_count   = var.primary_instance_count
  secondary_instance_count = var.secondary_instance_count
  snapshot_identifier      = var.snapshot_identifier
}