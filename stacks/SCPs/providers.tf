provider "aws" {
  region = "us-east-1"
 # Add configuration_aliases = [ aws.management] and assme role and use the role to assume role in the management account
}


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

