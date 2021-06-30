terraform {
  required_version = ">= 0.15.1"
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
  source    = "aws-quickstart/label/aws"
  version   = "0.0.1"
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
  source            = "aws-quickstart/vpc/aws"
  version           = "0.0.8"
  region            = var.region
  # commented values are hardcoded in AWS quickstart VPC module currently
  #cidr              = "10.0.0.0/16"
  #public_subnets    = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  #private_subnets_A = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
  tags              = module.vpc_label.tags
}

module "aurora_vpc_s" {
  # count           =  var.setup_globaldb ? 1 :0
  source            = "aws-quickstart/vpc/aws"
  version           = "0.0.8"
  region            = var.sec_region
  #commented values are hardcoded in AWS quickstart VPC module currently
  #cidr              = "10.0.0.0/16"
  #public_subnets    = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  #private_subnets_A = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
  tags              = module.vpc_label.tags
}

######################################
# Create Aurora DB
######################################

module "aurora" {
  #depends_on           = [module.aurora_vpc_p]
  source                = "../"
  region                = var.region
  sec_region            = var.sec_region
  #vpc_id               = module.aurora_vpc.vpc_id
  Private_subnet_ids_p  = [module.aurora_vpc_p.PrivateSubnet1AID, module.aurora_vpc_p.PrivateSubnet2AID, module.aurora_vpc_p.PrivateSubnet3AID]
  Private_subnet_ids_s  = var.setup_globaldb ? [module.aurora_vpc_s.PrivateSubnet1AID, module.aurora_vpc_s.PrivateSubnet2AID, module.aurora_vpc_s.PrivateSubnet3AID] : null
  engine                = var.engine
  engine_version        = var.engine_version
  password              = var.password
  setup_globaldb        = var.setup_globaldb
  tags                  = module.vpc_label.tags
}