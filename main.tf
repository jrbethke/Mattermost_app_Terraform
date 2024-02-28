# This file denotes the cloud provider and starts the VPC
# created 2/28/24
# last modified 2/28/24
#

provider "aws" {
    profile = "usr" # Use IAM created user here to avoid placing Access and Secret Key tokens
    region = "${var.region}"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        name = "Production-vpc"
    }
}
