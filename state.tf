terraform {
    backend "s3" {
        bucket = "aws-cicd-pipeline2021"
        region = "us-east-2"
        key    = "terraform.state"
    }
}

provider "aws" {
  region = "us-east-2"
}