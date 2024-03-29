###########################################################
# Terraform and AWS setting
###########################################################
terraform {
  # specify minimum terraform version
  required_version = ">= 1.6"

  # specify minimun aws version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
