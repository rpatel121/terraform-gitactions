terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
    mysql = {
      source  = "petoju/mysql"
      version = "3.0.60"
    }
  }
}
