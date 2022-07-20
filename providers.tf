# https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md
# https://github.com/hashicorp/terraform/blob/v1.0.10/CHANGELOG.md

terraform {
  required_version = ">= 1.0.0"
  backend "remote" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2"
    }
  }
}