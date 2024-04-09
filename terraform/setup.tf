provider "aws" {}
#data "aws_region" "configured" {}

terraform {
    backend "s3" {
        bucket = "sw-parlai-backend-s3-bucket"
        key = "tf-modules/terraform.tfstate"
        region = "us-east-1"
    }
}
 