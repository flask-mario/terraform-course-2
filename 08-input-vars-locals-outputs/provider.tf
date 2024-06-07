terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "terraform-test-mario-remote-backend"
    key    = "04-backends/dev/state.tfstate"
    region = "ap-northeast-2"
  }

}

# AMI ID(ap-northeast-2) : ami-0572f73f0a5650b33
# AMI ID(us-east-2) : ami-034de852f74caf71b


provider "aws" {
  region = "ap-northeast-2"
}
