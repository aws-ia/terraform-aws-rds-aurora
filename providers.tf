# https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md
# https://github.com/hashicorp/terraform/releases

terraform {
  required_version = ">= 1.3.0"
  # backend "remote" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2"
    }
  }
}