terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
	  source  = "hashicorp/aws"
      version = ">= 2"
    }
  }
  backend "s3" {
	bucket = "bank-cloud-infrastructure-tf-state"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}