provider "aws" {
    region = "us-east-1"
}

variable "s3-bucket" {
    description = "the name of the bucket"
    }

resource "aws_s3_bucket" "workspace" {
    bucket = var.s3-bucket
}

