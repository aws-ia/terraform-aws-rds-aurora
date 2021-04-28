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


######################################
# Create VPC
######################################

module "aurora_vpc" {
  source            = "aws-quickstart/vpc/aws"
  version           = "0.0.7"
  region            = var.region
  cidr              = "10.0.0.0/16"
  public_subnets    = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20", "10.0.176.0/20", "10.0.240.0/22", "10.0.244.0/22"]
  private_subnets_A = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19", "10.0.232.0/22", "10.0.236.0/22"]
}

######################################
# Create Aurora DB
######################################

module "aurora" {
  depends_on = [module.aurora_vpc]
  source     = "../modules/aurora"
  region     = var.region
  vpc_id     = module.aurora_vpc.vpc_id
}