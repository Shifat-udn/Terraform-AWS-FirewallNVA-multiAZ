# 1. Define the region in a central local block
locals {
  aws_region = "us-east-1"
}

# 2. Assign that local to your AWS provider
provider "aws" {
  region = local.aws_region
}