# Networking Module

This module manages the creation of VPCs and Subnets, allowing for the creation of both private and public subnets.

Example usage:
```terraform
module "vpc" {
  source = "./modules/networking"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "your_vpc"
  }

  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
      az         = "ap-northeast-2a"
    }
    subnet_2 = {
      cidr_block = "10.0.1.0/24"
      public     = true
      az         = "ap-northeast-2b"
    }
  }
}
```