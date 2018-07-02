terraform {
  backend "s3" {
    bucket = "prodmann-terraform-artifacts"
    key    = "post03/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {}

