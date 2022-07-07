terraform {
  required_version = ">= 1.0.0"
  backend "remote" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }
}