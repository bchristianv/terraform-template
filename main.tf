# Terraform Infrastructure Bootstrap

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>2.70"
    }
  }

  # After first `init/apply`, uncomment the `s3 backend` and
  # run `init` again to migrate state to s3/dynamodb, if desired.
  # backend "s3" {
  #   bucket         = "organization-tf-backend-storage"
  #   key            = "terraform-tf_infrastructure/terraform.tfstate"
  #   dynamodb_table = "tf-backend-lock"
  #   profile        = "ci-user"
  #   region         = "us-west-2"
  # }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.region
}

resource "aws_s3_bucket" "terraform-backend-storage" {
  bucket = "organization-tf-backend-storage"
  acl    = "private"

  tags = {
    name        = "terraform backend state storage"
    environment = "terraform_infrastructure"
  }
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform-backend-lock" {
  name           = "tf-backend-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    "name"        = "terraform backend state lock"
    "environment" = "terraform_infrastructure"
  }
}
