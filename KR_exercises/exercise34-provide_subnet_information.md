# 설정에서 서브넷 정보 전달하기

## Introduction

이 연습은 인프라 코드에서 서브넷 구성을 전달하는 과정을 안내하기 위해 고안되었습니다. 서브넷 구성을 위한 맵 변수 생성, CIDR 블록에 대한 유효성 검사 규칙 추가, AWS 서브넷을 위한 리소스 블록 생성 등의 방법을 배우게 됩니다. 이 실습은 특히 EC2 인스턴스 및 서브넷 관리에서 Terraform과 AWS에 대한 이해를 높이는 것을 목표로 합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 각 항목이 CIDR 블록을 수신하는 서브넷 구성에 대한 맵 변수를 생성합니다.
2. 제공된 모든 CIDR 블록이 유효한지 확인하기 위해 유효성 검사 규칙을 추가합니다.
3. 서브넷 구성 맵의 각 항목에 대한 서브넷을 생성하는 AWS 서브넷에 대한 리소스 블록을 생성합니다.
4. 인스턴스를 배포할 서브넷을 수신하는 새 속성을 추가하여 기존 EC2 인스턴스 구성 변수를 확장합니다.

## Step-by-Step Guide

1. 먼저 서브넷 구성을 위한 변수를 생성합니다. 이 변수는 맵 유형이며, 이 맵의 각 값은 문자열인 단일 속성 `cidr_block`을 가진 객체입니다. 이렇게 하면 각 구성에 CIDR 블록이 포함된 서브넷 구성 맵을 전달할 수 있습니다.

    ```
    variable "subnet_config" {
      type = map(object({
        cidr_block = string
      }))
    }
    ```

2. 제공된 모든 CIDR 블록이 유효한지 확인하기 위해 유효성 검사 규칙을 추가합니다. 이 규칙은 `cidrnetmask` 함수를 사용하여 각 CIDR 블록이 유효한지 확인하고, `alltrue` 함수를 사용하여 모든 CIDR 블록이 유효한지 확인합니다. CIDR 블록이 유효하지 않은 경우 오류 메시지가 표시됩니다.

    ```
    validation {
      condition = alltrue([
        for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
      ])
      error_message = "At least one of the provided CIDR blocks is not valid."
    }
    ```

3. AWS 서브넷에 대한 리소스 블록을 생성합니다. 이 블록은 `var.subnet_config`의 각 항목에 대한 서브넷을 생성합니다. 각 서브넷은 `main` VPC와 연결되며(생성되지 않은 경우, CIDR 블록이 `10.0.0.0/16`인 `aws_vpc.main` 리소스를 새로 생성), 해당 CIDR 블록은 서브넷 구성에서 `cidr_block`으로 설정됩니다. 또한 서브넷에는 프로젝트 이름으로 설정된 `Project` 태그와 서브넷 구성에서 프로젝트 이름과 키의 조합으로 설정된 `Name` 태그가 태그됩니다.

    ```
    resource "aws_subnet" "main" {
      for_each   = var.subnet_config
      vpc_id     = aws_vpc.main.id
      cidr_block = each.value.cidr_block

      tags = {
        Project = local.project
        Name    = "${local.project}-${each.key}"
      }
    }
    ```

4. 인스턴스를 배포할 서브넷 키를 선택적으로 받을 수 있는 새로운 속성 `subnet_name`을 추가하여 기존 `ec2_instance_config_list` 및 `ec2_instance_config_map` 변수를 확장합니다. 값을 제공하지 않으면 속성 값을 `default`로 설정합니다.

    ```
    variable "ec2_instance_config_list" {
      type = list(object({
        instance_type = string
        ami           = string
        subnet_name   = optional(string, "default")
      }))

      default = []

      # Ensure that only t2.micro is used
      validation {
        ...
      }

      # Ensure that only ubuntu and nginx images are used.
      validation {
        ...
      }
    }

    variable "ec2_instance_config_map" {
      type = map(object({
        instance_type = string
        ami           = string
        subnet_name   = optional(string, "default")
      }))

      # Ensure that only t2.micro is used
      validation {
        ...
      }

      # Ensure that only ubuntu and nginx images are used.
      validation {
        ...
      }
    }
    ```

5. 생성된 리소스의 subnet_id 속성을 설정할 때 새 정보를 사용하도록 `aws_instance.from_list`와 `aws_instance.from_map` 리소스를 모두 마이그레이션합니다.

    ```
    resource "aws_instance" "from_list" {
      count         = length(var.ec2_instance_config_list)
      ami           = local.ami_ids[var.ec2_instance_config_list[count.index].ami]
      instance_type = var.ec2_instance_config_list[count.index].instance_type
      subnet_id     = aws_subnet.main[
        var.ec2_instance_config_list[count.index].subnet_name
      ].id

      tags = {
        Name    = "${local.project}-${count.index}"
        Project = local.project
      }
    }

    resource "aws_instance" "from_map" {
      for_each      = var.ec2_instance_config_map
      ami           = local.ami_ids[each.value.ami]
      instance_type = each.value.instance_type
      subnet_id     = aws_subnet.main[each.value.subnet_name].id

      tags = {
        Name    = "${local.project}-${each.key}"
        Project = local.project
      }
    }
    ```

6. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 특히 EC2 인스턴스와 서브넷을 관리하는 방법에 대해 테라폼과 AWS에 대한 이해를 심화시키는 데 중요한 단계를 밟으셨습니다. 앞으로도 계속 탐구하고 배우면서 열심히 공부하세요!
