# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------
######################################
# Defaults
######################################
terraform {
  required_version = ">= 0.13"

  backend "remote" {}
}

provider "aws" {
  region = var.region
}

resource "random_pet" "name" {
  prefix = "tfm-aws"
  length = 1
}

######################################
# Create Aurora DB
######################################

module "aurora" {
  source = "../../modules/aurora"
  region = var.region
  name   = random_pet.name.id
  vpc_id = "" #add the VPC ID you wish the database to be built in.
}