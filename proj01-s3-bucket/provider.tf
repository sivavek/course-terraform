terraform {
  required_version = ">= 1.11.0, <= 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 5.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0, < 4.0"
      # If you need a specific patch version, use: version = ">= 3.0, < 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}