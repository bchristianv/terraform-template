# Example Infrastructure

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>2.70"
    }
  }

  backend "s3" {
    bucket         = "organization-tf-backend-storage"
    key            = "example/terraform.tfstate"
    dynamodb_table = "tf-backend-lock"
    region         = "us-west-2"
  }
}

provider "aws" {
  region  = var.region
}

resource "aws_instance" "example" {
  # ...
}
