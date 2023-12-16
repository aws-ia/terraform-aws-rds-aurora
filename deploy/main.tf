######################################
# Defaults
######################################

provider "aws" {
  alias  = "primary"
  region = var.region
}

provider "aws" {
  alias  = "secondary"
  region = var.sec_region
}

resource "random_string" "rand4" {
  length  = 4
  special = false
  upper   = false
}

#########################
# Collect data
#########################

data "aws_caller_identity" "current" {
  provider = aws.primary
}

######################################
# Generate Tags
######################################

module "vpc_label" {
  source    = "aws-ia/label/aws"
  version   = "0.0.5"
  providers = { aws = aws.primary }

  account   = var.account == null ? data.aws_caller_identity.current.account_id : var.account
  namespace = var.namespace
  env       = var.env
  name      = "${var.name}-${random_string.rand4.result}"
  delimiter = var.delimiter
  tags = [
    {
      "key" : "terraform",
      "value" : "true"
    }
  ]
}

######################################
# Create VPC
######################################

module "aurora_vpc_p" {
  source    = "aws-ia/vpc/aws"
  version   = "4.4.1"
  providers = { aws = aws.primary }

  name       = "aurora-vpc"
  az_count   = 3
  cidr_block = "10.0.0.0/16"
  subnets = {
    public = {
      netmask                   = 20
      nat_gateway_configuration = "all_azs"
    }
    private = {
      netmask                 = 20
      connect_to_public_natgw = true
    }
  }
  vpc_enable_dns_hostnames = true
  tags                     = module.vpc_label.tags_aws
}

module "aurora_vpc_s" {
  source    = "aws-ia/vpc/aws"
  version   = "4.4.1"
  providers = { aws = aws.secondary }

  count = var.setup_globaldb ? 1 : 0

  name       = "aurora-vpc"
  az_count   = 3
  cidr_block = "10.0.0.0/16"
  subnets = {
    public = {
      netmask                   = 20
      nat_gateway_configuration = "all_azs"
    }
    private = {
      netmask                 = 20
      connect_to_public_natgw = true
    }
  }
  vpc_enable_dns_hostnames = true
  tags                     = module.vpc_label.tags_aws
}

######################################
# Create Aurora DB
######################################

#tfsec:ignore:aws-rds-enable-performance-insights-encryption tfsec:ignore:aws-rds-enable-performance-insights
module "aurora" {
  source    = "../"
  providers = { aws = aws.primary }

  region                      = var.region
  sec_region                  = var.sec_region
  private_subnet_ids_p        = [for _, value in module.aurora_vpc_p.private_subnet_attributes_by_az : value.id]
  private_subnet_ids_s        = var.setup_globaldb ? [for _, value in module.aurora_vpc_s[0].private_subnet_attributes_by_az : value.id] : null
  name                        = var.name
  identifier                  = var.identifier
  engine                      = var.engine
  engine_version_pg           = var.engine_version_pg
  engine_version_mysql        = var.engine_version_mysql
  instance_class              = var.instance_class
  username                    = var.username
  password                    = var.password
  manage_master_user_password = var.manage_master_user_password
  setup_globaldb              = var.setup_globaldb
  setup_as_secondary          = var.setup_as_secondary
  tags                        = module.vpc_label.tags_aws
  monitoring_interval         = var.monitoring_interval
  storage_encrypted           = var.storage_encrypted
  storage_type                = var.storage_type
  primary_instance_count      = var.primary_instance_count
  secondary_instance_count    = var.secondary_instance_count
  snapshot_identifier         = var.snapshot_identifier
}