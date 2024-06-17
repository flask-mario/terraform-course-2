# AWS EC2 모듈 사용

## Introduction

이 실습에서는 Terraform에서 AWS EC2 모듈을 사용하는 방법을 배워보겠습니다. 일부 VPC 모듈 정보를 리팩터링하고, 추가 로컬을 도입하고, `data` 블록을 활용하여 최신 Ubuntu 22.04 AMI(Amazon Machine Image)에 대한 정보를 얻습니다. 그런 다음 Terraform 레지스트리의 `terraform-aws-modules/ec2-instance/aws` 모듈을 사용하여 Amazon EC2 인스턴스를 생성합니다. 이 실습은 AWS EC2 모듈을 직접 경험하고 실제 시나리오에서 그 기능을 이해할 수 있는 좋은 기회를 제공합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶은 경우, 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. VPC 모듈 정보를 리팩터링하여 로컬 블록으로 추출합니다.
2. 다른 리소스에서 사용할 수 있도록 공유 파일에 `project_name` 및 `common_tags` 로컬을 추가로 생성합니다.
3. `data` 블록을 사용하여 최신 Ubuntu 22.04 AMI(Amazon 머신 이미지)에 대한 정보를 가져옵니다.
4. 테라폼 레지스트리에서 `terraform-aws-modules/ec2-instance/aws` 모듈을 사용하여 Amazon EC2 인스턴스를 생성합니다. 여기에는 인스턴스의 이름, AMI, 인스턴스 유형, 보안 그룹, 서브넷을 지정하는 것이 포함됩니다. 이전 연습에서 생성한 VPC 모듈을 활용해야 합니다.

## Step-by-Step Guide

1. VPC 모듈 구현을 리팩터링하여 VPC CIDR, 공용 및 사설 서브넷, VPC 이름을 자체 로컬로 추출합니다. VPC 이름은 다른 리소스에서도 사용되므로 공유 파일의 `project_name` 로컬에 배치합니다.

    ```
    # shared_data.tf
    locals {
      project_name = "12-public-modules"
    }

    ---

    # networking.tf
    locals {
      vpc_cidr             = "10.0.0.0/16"
      private_subnet_cidrs = ["10.0.0.0/24"]
      public_subnet_cidrs  = ["10.0.128.0/24"]
    }

    data "aws_availability_zones" "azs" {
      state = "available"
    }

    module "vpc" {
      source  = "terraform-aws-modules/vpc/aws"
      version = "5.5.3"

      cidr            = local.vpc_cidr
      name            = local.project_name
      azs             = data.aws_availability_zones.azs.names
      private_subnets = local.private_subnet_cidrs
      public_subnets  = local.public_subnet_cidrs
    }
    ```

2. 공유 파일에 `common_tags` 로컬을 생성하고 기존 VPC 모듈에 전달합니다.

    ```
    locals {
      project_name = "12-public-modules"
      common_tags = {
        Project   = local.project_name
        ManagedBy = "Terraform"
      }
    }
    ```

3. `compute.tf` 파일에서 `instance_type` 변수가 포함된 `locals` 블록을 선언합니다. 이 변수는 시작하려는 Amazon EC2 인스턴스의 유형을 정의합니다.

    ```
    locals {
      instance_type = "t2.micro"
    }
    ```

4. `data` 블록을 사용하여 최신 Ubuntu 22.04 AMI(Amazon 머신 이미지)에 대한 정보를 가져옵니다. `owners` 인수는 이미지 소유자의 AWS 계정 ID를 지정합니다. `filter` 인수는 AMI의 이름과 가상화 유형을 지정합니다.

    ```
    data "aws_ami" "ubuntu" {
      most_recent = true
      owners      = ["099720109477"] # Canonical

      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
      }

      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    }

    ```

5. `module` 블록을 사용하여 Terraform 레지스트리의 `terraform-aws-modules/ec2-instance/aws` 모듈을 사용하여 Amazon EC2 인스턴스를 생성합니다. 위의 정보와 이전 연습에서 생성한 VPC 모듈을 기반으로 인스턴스의 이름, AMI, 인스턴스 유형, 보안 그룹 및 서브넷을 지정합니다. VPC 모듈의 기본 보안 그룹 ID를 사용합니다. 또한 인스턴스에 공통 태그를 추가합니다.

    ```
    module "ec2" {
      source  = "terraform-aws-modules/ec2-instance/aws"
      version = "5.6.1"

      name                   = local.project_name
      ami                    = data.aws_ami.ubuntu.id
      instance_type          = local.instance_type
      vpc_security_group_ids = [module.vpc.default_security_group_id]
      subnet_id              = module.vpc.public_subnets[0]

      tags = local.common_tags
    }
    ```

6. 연습이 끝나면 반드시 인프라를 destroy하세요!

## Congratulations on Completing the Exercise!

이 연습을 성공적으로 완료한 것을 축하드립니다! Terraform에서 AWS EC2 모듈을 사용하는 방법을 훌륭하게 학습하셨습니다. 개념을 이해했을 뿐만 아니라 실제로 적용해 보았습니다. 앞으로도 계속 잘 부탁드립니다!
