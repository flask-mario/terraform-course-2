# EC2 인스턴스로 모듈 테스트

## Introduction

이 연습에서는 Amazon EC2 인스턴스로 모듈을 테스트해 보겠습니다. 네트워킹 모듈이 올바르게 작동하는지 확인한 다음 생성된 서브넷 중 하나에 새 EC2 인스턴스를 생성하겠습니다. 이를 통해 모듈을 다른 AWS 서비스와 통합하는 방법을 이해하고 기능을 검증하는 데 도움이 될 것입니다.

## Step-by-Step Guide

1. 먼저 네트워킹 모듈이 올바르게 작동하는지 확인하기 위해 `terraform apply`를 실행하고 모든 리소스가 생성되었는지 확인합니다.
2. Ubuntu AMI를 사용하여 새 EC2 인스턴스를 생성하고 이 EC2 인스턴스를 모듈로 생성한 `subnet_1` 서브넷 내에 배포합니다.

    ```
    locals {
      project_name = "13-local-modules"
    }

    data "aws_ami" "ubuntu" {
      most_recent = true
      owners      = ["099720109477"] # Owner is Canonical

      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
      }

      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    }

    resource "aws_instance" "this" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
      subnet_id     = module.vpc.private_subnets["subnet_1"].subnet_id

      tags = {
        Name    = local.project_name
        Project = local.project_name
      }
    }
    ```

3. `terraform apply`를 실행하고 AWS 콘솔에서 생성된 인프라를 검사하여 모든 것이 작동하는지 확인합니다.

4. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! Amazon EC2 인스턴스로 모듈을 성공적으로 테스트하고 다른 AWS 서비스와 통합했습니다. 이는 Terraform과 AWS로 작업하는 방법을 이해하는 데 있어 중요한 단계입니다. 계속 열심히 하세요!
