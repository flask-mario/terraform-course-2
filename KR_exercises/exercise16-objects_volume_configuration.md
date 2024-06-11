# 볼륨 구성에 오브젝트 사용

## Introduction

이 연습에서는 EC2 인스턴스에서 볼륨 구성을 위한 객체 사용에 대해 살펴보겠습니다. 이 개념을 사용하면 관련 구성 세부 정보를 보다 관리하기 쉬운 단일 엔티티로 캡슐화할 수 있습니다. 또한 EC2 인스턴스에 추가 태그를 통합하여 AWS 리소스를 보다 유연하게 관리하는 방법도 살펴봅니다. 이 실습을 통해 Terraform 변수와 리소스에 대한 이해를 강화하고, 이를 사용하여 보다 효율적이고 유연한 구성을 만드는 방법을 배울 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. EC2 인스턴스에 대한 루트 블록 디바이스의 볼륨 유형과 볼륨 유형이 포함된 변수 `ec2_volume_config`를 생성합니다.
2. 사용자가 EC2 인스턴스에 추가 태그를 정의할 수 있는 `additional_tags` 변수를 생성합니다.
3. 새 변수를 활용하도록 EC2 인스턴스 구성을 업데이트합니다.

## Step-by-Step Guide

1. `ec2_volume_type` 및 `ec2_volume_size` 변수 사용에서 `object` 유형인 단일 `ec2_volume_config` 변수 사용으로 마이그레이션합니다. 합리적인 기본값을 설정하고 새 변수에 유용한 설명을 추가합니다.

    ```
    variable "ec2_volume_config" {
      type = object({
        size = number
        type = string
      })
      description = "The size and type of the root block volume for EC2 instances."

      default = {
        size = 10
        type = "gp3"
      }
    }
    ```

2. 문자열의 `map` 유형이며 기본적으로 비어 있는 새 `additional_tags` 변수를 추가합니다. 이렇게 하면 필요한 경우 리소스에 태그를 더 추가할 수 있습니다.

    ```
    variable "additional_tags" {
      type    = map(string)
      default = {}
    }
    ```

3. 새 변수를 사용하도록 EC2 인스턴스 리소스를 마이그레이션합니다.

    ```
    resource "aws_instance" "compute" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.ec2_instance_type

      root_block_device {
        delete_on_termination = true
        volume_size           = var.ec2_volume_config.size
        volume_type           = var.ec2_volume_config.type
      }

      tags = merge(var.additional_tags, {
        ManagedBy = "Terraform"
      })
    }
    ```

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! `object` 및 `map` 유형의 변수를 사용하는 방법을 성공적으로 배웠습니다. 계속 열심히 공부하세요!
