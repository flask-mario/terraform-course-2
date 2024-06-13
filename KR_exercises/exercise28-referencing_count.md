# `count` 인수를 사용하여 리소스 참조하기

## Introduction

이 실습에서는 Terraform에서 `count` 인자로 생성된 리소스를 참조하는 방법을 살펴보겠습니다. 생성할 EC2 인스턴스 수를 결정하는 새 변수를 만들고, 데이터 소스를 활용하여 Ubuntu AWS AMI를 읽고, 이러한 인스턴스를 여러 서브넷에 배포합니다. 이 실습은 Terraform에서 변수, 데이터 소스 및 리소스 생성에 대한 실질적인 경험을 제공합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 숫자 유형이고 기본값이 1인 새 변수 `ec2_instance_count`를 생성합니다.
2. 우분투 AWS AMI를 읽는 데이터 소스를 생성합니다.
3. `ec2_instance_count` 변수를 사용하여 여러 EC2 인스턴스를 생성하는 `aws_instance` 리소스를 생성합니다.
4. 이전 연습에서 생성한 모든 서브넷에 EC2 인스턴스를 균등하게 배포합니다.

## Step-by-Step Guide

1. 숫자 유형이고 기본값이 1인 `ec2_instance_count`라는 변수를 새로 만듭니다.

    ```
    variable "ec2_instance_count" {
      type    = number
      default = 1
    }
    ```

2. 이전 연습에서 정의한 대로 Ubuntu AWS AMI를 읽는 데이터 소스를 생성하고, `ec2_instance_count` 변수를 활용하여 여러 EC2 인스턴스를 생성하는 `aws_instance` 리소스를 생성합니다. `terraform plan` 명령을 실행하여 문제가 있는지 검사합니다.

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

    resource "aws_instance" "from_count" {
      count         = var.ec2_instance_count
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"

      tags = {
        Name    = "${local.project}-${count.index}"
        Project = local.project
      }
    }
    ```

3. 서브넷 ID를 `aws_subnet.main` 리소스에서 생성한 첫 번째 서브넷의 ID로 설정합니다. `terraform apply` 명령을 실행하고 변경 사항을 확인한 후 올바른 서브넷에 배포되었는지 확인합니다.

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

    resource "aws_instance" "from_count" {
      count         = var.ec2_instance_count
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
      subnet_id     = aws_subnet.main[0].id

      tags = {
        Name    = "${local.project}-${count.index}"
        Project = local.project
      }
    }
    ```

4. 이제 4개의 EC2 인스턴스를 생성해 보겠습니다. `terraform.tfvars` 파일을 생성하고 `ec2_instance_count` 변수를 4로 설정합니다. 또한 생성한 서브넷에 이러한 EC2 인스턴스를 균등하게 배포하고 싶습니다. 지금까지 배운 것을 가지고 어떻게 이를 달성할 수 있을까요? (**Hint:** 서브넷에 액세스하는 데 사용하는 인덱스를 동적으로 계산할 수 있습니다.)

    ```
    resource "aws_instance" "from_count" {
      count         = var.ec2_instance_count
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
      subnet_id     = aws_subnet.main[
        count.index % length(aws_subnet.main)
      ].id

      tags = {
        Name    = "${local.project}-${count.index}"
        Project = local.project
      }
    }
    ```

5. `terraform apply`을 실행하고 변경 사항을 확인합니다.
6. 모든 단계를 완료한 후에는 반드시 리소스를 삭제하세요!

## Congratulations on Completing the Exercise!

수고하셨습니다! Terraform에서 카운트 인수를 사용하여 리소스를 참조하는 이 연습을 성공적으로 완료하셨습니다. 변수, 데이터 소스 및 리소스 생성을 사용하여 여러 서브넷에 걸쳐 여러 EC2 인스턴스를 관리하고 배포하는 방법을 배웠습니다. 계속 열심히 공부하세요!
