# Precondition Blocks

## Introduction

이 연습에서는 Terraform에서 Precondition(전제 조건) 블록을 만드는 작업을 하게 됩니다. 이 연습은 Terraform이 인프라에 변경 사항을 적용하기 전에 충족해야 하는 규칙을 구현하는 방법을 이해하는 것을 목표로 합니다. 새 Terraform 프로젝트를 구성하고 Ubuntu AMI로 EC2 인스턴스를 생성합니다. 또한 선택한 인스턴스 유형이 허용된 인스턴스 유형 목록과 일치하는지 확인하기 위해 Precondition(전제 조건) 블록을 추가합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 이 섹션을 위한 새 폴더를 만듭니다.
2. 우분투 AMI로 EC2 인스턴스를 배포합니다.
3. 문자열 타입의 `instance_type` 변수를 생성하고 기본값은 `t2.micro`로 설정합니다.
4. EC2 인스턴스에 허용된 인스턴스 유형 목록이 포함된 새로운 `allowed_instance_types` 로컬을 생성합니다.
5. 생성된 EC2 인스턴스에서 Precondition(전제 조건) 블록을 정의하여 `instance_type` 변수의 값이 `allowed_instance_types` 로컬에 있는지 확인합니다.

## Step-by-Step Guide

1. 새 Terraform 프로젝트를 위한 새 폴더를 만들고, 필요한 Terraform 버전과 AWS 공급자를 이 과정 내내 사용했던 것과 동일한 버전으로 구성합니다.
2. `compute.tf` 파일이라는 이름의 새 파일을 생성하고 Ubuntu AMI로 EC2 인스턴스를 생성합니다.

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

    resource "aws_instance" "this" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.instance_type

      root_block_device {
        delete_on_termination = true
        volume_size           = 10
        volume_type           = "gp3"
      }
    }
    ```

3. 새 `variables.tf` 파일을 만들고 문자열 유형이고 기본값이 `t2.micro`인 새 변수 `instance_type`을 선언합니다.

    ```
    variable "instance_type" {
      type    = string
      default = "t2.micro"
    }
    ```

4. `compute.tf` 파일에 로컬에 `allowed_instance_types`를 새로 생성하고 EC2 인스턴스에 허용해야 하는 인스턴스 유형만 포함된 목록을 정의합니다.

    ```
    locals {
      allowed_instance_types = ["t2.micro", "t3.micro"]
    }
    ```

5. Precondition(전제 조건) 블록을 추가하여 `instance_type` 변수에 대해 받은 값이 `allowed_instance_types` 로컬에 포함되어 있는지 확인합니다. `terraform plan`을 실행하여 코드를 테스트하고 오류가 없는지 확인합니다. 변수의 기본값을 잘못된 값으로 변경하고 `terraform plan`을 다시 실행해 보세요. 어떤 유형의 오류가 발생하나요?

    ```
    resource "aws_instance" "this" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.instance_type
      subnet_id     = aws_subnet.this[0].id

      root_block_device {
        delete_on_termination = true
        volume_size           = 10
        volume_type           = "gp3"
      }

      lifecycle {
        precondition {
          condition     = contains(local.allowed_instance_types, var.instance_type)
          error_message = "Invalid instance type"
        }
      }
    }
    ```

## Congratulations on Completing the Exercise!

Terraform에서 전제 조건 블록 생성 연습을 성공적으로 완료하신 것을 축하드립니다! 테라폼이 인프라에 변경 사항을 적용하기 전에 충족해야 하는 규칙을 구현하는 방법을 이해하는 데 중요한 단계를 밟으셨습니다. 계속 열심히 하세요!
