terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~> 5.7"
    }
  }

  backend "s3" {
    bucket = "jenkins-infra-31"
    key = "expense-eks"
    region = "us-east-1"
    dynamodb_table= "demo_key"     
    
  }
}

provider "aws" {
  region = "us-east-1"

}