terraform {
  required_version = "~> 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "aloha-bucket-123"
    key    = "aloha-terraform-state-files/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "aloha-state-lock"
  }
}
# Provider Block
provider "aws" {
  region = var.aws_region
}
