# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------
######################################
# Defaults
######################################
terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  region = var.region
}

resource "random_pet" "name" {
  prefix = "tfm-aws"
  length = 1
}

locals {
  name = random_pet.name.id
}

######################################
# Create VPC
######################################

module "aurora_vpc" {
  source            = "aws-quickstart/vpc/aws"
  region            = var.region
  name              = local.name
  cidr              = "10.0.0.0/16"
  public_subnets    = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20", "10.0.176.0/20", "10.0.240.0/22", "10.0.244.0/22"]
  private_subnets_A = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19", "10.0.232.0/22", "10.0.236.0/22"]
}

######################################
# Create Aurora DB
######################################

module "aurora" {
  depends_on = [module.aurora_vpc]
  source     = "../../modules/aurora2"
  region     = var.region
  name       = local.name
  vpc_id     = module.aurora-vpc.vpc_id
}