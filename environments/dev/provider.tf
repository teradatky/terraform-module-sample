###########################################################
# Terraform and AWS setting
###########################################################
terraform {
  # specify minimum terraform version
  required_version = ">= 0.14"

  # specify minimun aws version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.56.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
