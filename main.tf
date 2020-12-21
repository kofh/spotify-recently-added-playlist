terraform {
  backend "remote" {
    organization = "kofh"
    workspaces {
      name = "recently-added-playlist"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}
