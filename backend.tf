/*
terraform {
  backend "s3" {
    bucket       = "bucket-east-us-1-terraform"
    key          = "state/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
*/
