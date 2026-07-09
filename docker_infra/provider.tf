terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.48"
        }
    }
    backend "s3" {
        bucket = "flipkart-dev-buckets"
        key = "flipkart-dev-docker.tfstate"
        region = "us-east-1" 
        encrypt= true
        use_lockfile = true
    }
}

provider "aws" {
    region = "us-east-1"
}