# List 변수를 기반으로 EC2 인스턴스 생성하기

## Introduction

이 실습에서는 구성 목록을 기반으로 Terraform에서 여러 EC2 인스턴스를 생성하는 방법을 배웁니다. 인스턴스 유형 및 AMI와 같은 원하는 EC2 인스턴스 속성을 목록 변수에 정의한 다음 Terraform을 사용하여 이러한 인스턴스를 생성합니다. 이 실습을 통해 복잡한 구성을 처리하고 Terraform에서 데이터 소스 및 리소스를 조작하는 실무 경험을 쌓을 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶은 경우, 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 지정된 구성 목록 변수를 기반으로 EC2 인스턴스 목록을 생성합니다.
2. 구성 목록에는 인스턴스 유형 및 AMI와 같은 세부 정보가 포함됩니다.
3. AMI 속성은 `"ubuntu"`와 같은 사용자 친화적인 값을 수신하고 데이터 소스를 기반으로 AMI ID를 검색해야 합니다.
4. 인스턴스는 여러 서브넷에 분산되어 있습니다.

## Step-by-Step Guide

1. `variables.tf` 파일 아래에 새 변수 `ec2_instance_config_list`를 생성합니다. 이 변수는 특정 키를 가진 객체를 포함하는 목록 유형입니다. 키는 모두 문자열 유형인 `instance_type` 및 `ami`를 포함합니다. 이 변수의 기본값은 빈 목록입니다.

    ```
    variable "ec2_instance_config_list" {
      type = list(object({
        instance_type = string
        ami           = string
      }))

      default = []
    }
    ```

2. `terraform.tfvars` 파일에 변수에 대한 항목을 추가합니다. 목록에는 `instance_type`이 `"t2.micro"`(또는 무료 티어에 해당하는 유형)로 설정되고 `ami`가 `"ubuntu"`로 설정된 객체 하나가 포함되어야 합니다. 또한 추가 ec2 인스턴스가 생성되지 않도록 `ec2_instance_count` 변수를 `0`으로 설정해야 합니다.

    ```
    ec2_instance_config_list = [
      {
        instance_type = "t2.micro",
        ami           = "ubuntu"
      }
    ]
    ```

3. `compute.tf` 파일에서 `count = length(var.ec2_instance_config_list)` 메타 인수를 사용하여 목록을 반복하는 새 리소스 `aws_instance.from_list`를 추가합니다. 구성 개체에서 정보를 검색합니다. `ubuntu` 값을 사용하여 AMI ID를 가져오려면 어떻게 해야 하나요? (힌트: 로컬 맵을 사용하여 데이터 소스에서 오는 AMI ID를 저장하세요).

    ```
    locals {
      ami_ids = {
        ubuntu = data.aws_ami.ubuntu.id
      }
    }

    data "aws_ami" "ubuntu" {
      most_recent = true
      owners      = ["099720109477"] # Canonical is the owner

      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
      }

      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    }

    resource "aws_instance" "from_list" {
      count         = length(var.ec2_instance_config_list)
      ami           = local.ami_ids[var.ec2_instance_config_list[count.index].ami]
      instance_type = var.ec2_instance_config_list[count.index].instance_type
      subnet_id     = aws_subnet.main[
        count.index % length(aws_subnet.main)
      ].id

      tags = {
        Name    = "${local.project}-${count.index}"
        Project = local.project
      }
    }
    ```

4. `terraform plan`을 실행하고 제안된 변경 사항을 검사합니다.

## Congratulations on Completing the Exercise!

이 연습을 완료했습니다! 이제 Terraform에서 목록을 기반으로 여러 EC2 인스턴스를 생성하는 방법을 성공적으로 배웠습니다. 이는 Terraform에서 복잡한 구성을 관리하고 데이터 소스 및 리소스를 조작하는 데 있어 중요한 진전입니다. 계속 열심히 하세요!
