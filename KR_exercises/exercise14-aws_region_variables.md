# 변수를 통해 AWS 리전 받기

## Introduction

이 실습에서는 Terraform의 변수를 사용하여 AWS 리전을 수신하는 방법을 살펴보겠습니다. 이를 통해 리소스가 생성될 리전을 동적으로 설정할 수 있습니다. 그러나 이 접근 방식에는 고유한 문제점이 있으며 잠재적인 함정을 알고 있어야 한다는 점에 유의하는 것이 중요합니다. 이 연습에서는 Terraform 구성 파일을 만들고 적용하고 리전을 변경할 때의 동작을 관찰하는 과정을 안내합니다. 연습이 끝나면 Terraform이 리전, 인스턴스를 처리하는 방법과 리소스를 신중하게 관리하는 것의 중요성에 대해 더 깊이 이해하게 될 것입니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. `aws_region`이라는 단일 변수가 포함된 `variables.tf` 파일을 생성합니다.
2. 지금까지 사용했던 표준 구성 코드(Terraform 필수 버전 및 AWS 공급자 요구 사항)로 `provider.tf` 파일을 생성합니다.
3. `aws_region` 변수를 사용하여 `aws` 제공자를 구성할 지역을 설정합니다.
4. 우분투 AWS AMI용 `aws_ami` 데이터 소스를 사용하여 EC2 인스턴스를 생성합니다.

## Step-by-Step Guide

1. `variables.tf` 파일을 생성하고 `aws_region`이라는 단일 변수를 선언합니다. 변수에 기본값을 지정하지 않으면 Terraform 명령을 실행할 때 값을 제공해야 합니다.
2. `provider.tf` 파일을 생성하고 Terraform 프로젝트에 사용하던 표준 구성 코드를 추가합니다.

    ```
    terraform {
      required_version = "~> 1.7"
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
      }
    }
    ```

3. `aws_region` 변수를 사용하여 `aws` 공급자의 지역을 설정합니다.

    ```
    provider "aws" {
      region = var.aws_region
    }
    ```

4. 이 패턴은 매우 위험합니다! 이유를 짐작할 수 있을까요? 여기서 무엇이 잘못될 수 있는지 확인하기 위해 EC2 인스턴스를 생성해 보겠습니다. 이전 섹션에서 수행한 것처럼 Ubuntu AWS AMI를 검색할 데이터 소스와 EC2 인스턴스를 생성합니다.

    ```
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

    resource "aws_instance" "compute" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"

      root_block_device {
        delete_on_termination = true
        volume_size           = 10
        volume_type           = "gp3
      }
    }
    ```

5. 이제 `terraform apply` 명령을 실행하고 지금까지 작업한 영역을 생성된 변수에 값으로 전달합니다. 모든 것이 예상대로 작동해야 합니다.
6. 이제 `terraform plan` 명령을 실행하되 다른 지역을 전달합니다. 결과적으로 어떤 일이 발생하나요? 이전에 생성된 EC2 인스턴스를 삭제할 계획인가요? 이 계획을 적용하면 각 리전에 몇 개의 인스턴스가 존재할까요?
7. 보시다시피, Terraform은 다른 리전에서 이전에 생성된 인스턴스를 **파괴하지** 않습니다! 이로 인해 많은 리소스가 Terraform에 의해 단순히 "잊혀질" 수 있으며, 이는 매우 번거로울 수 있습니다!
8. 마지막 단계로, `aws_region` 변수를 제거하고 `provider "aws"` 구성 블록에서 올바른 리전을 하드코딩합니다.
9. 모든 단계를 완료한 후에는 리소스를 반드시 삭제하세요!

## Congratulations on Completing the Exercise!

이 연습을 성공적으로 완료하셨습니다! Terraform에서 AWS 리전 및 변수로 작업하는 방법을 이해하는 데 중요한 단계를 밟으셨습니다. 이 지식은 여러 리전에서 리소스를 관리하고 배포하는 데 매우 중요합니다. 계속 열심히 하세요!
