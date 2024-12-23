terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }
  }
  backend "s3" {
    bucket         = "jenkins-infra-31"
    key            = "jenkins-vpc-dev"
    region         = "us-east-1"
    dynamodb_table = "infra-dev"



  }
}

provider "aws" {
  region = "us-east-1"
}