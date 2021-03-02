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
  source                     = "./modules/aurora"
  region                     = var.region
  name                       = "${random_pet.name.id}-main"
  vpc_id                     = "" #add the VPC ID you wish the database to be built in.
  cluster_identifier         = var.name
  engine                     = var.engine
  database_name              = var.database_name
  master_username            = var.username
  master_password            = var.password == "" ? random_password.master_password.result : var.password
  backup_retention_period    = var.backup_retention_period
  preferred_backup_window    = var.preferred_backup_window
  engine_version             = var.engine_version
  port                       = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  storage_encrypted          = var.storage_encrypted
  skip_final_snapshot        = var.skip_final_snapshot
  tags                       = var.tags
  identifier                 = "${var.name}-${count.index + 1}"
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  instance_class             = var.instance_class
}