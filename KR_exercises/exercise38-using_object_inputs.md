# 객체 변수 사용으로 마이그레이션

## Introduction

이 연습에서는 Terraform 모듈에서 객체 변수를 사용하도록 마이그레이션하는 작업을 진행합니다. 먼저 모듈 내에서 `aws_vpc` 리소스를 새로 생성하고, `vpc_cidr` 변수를 사용하여 VPC의 CIDR 블록을 제공합니다. 그런 다음 생성된 VPC에 태그를 추가하고 `terraform apply` 작업을 실행합니다. 그런 다음, 인프라를 변경하지 않고 마이그레이션을 성공적으로 수행할 수 있도록 `vpc_cidr` 변수를 수정하여 VPC CIDR 블록과 VPC 이름을 모두 수신하는 객체가 되도록 합니다. 이 연습에서는 Terraform에서 변수 마이그레이션을 처리하는 방법에 대한 실제 데모를 제공하여 복잡한 구성을 쉽게 처리할 수 있도록 합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 모듈 내에 `aws_vpc` 리소스를 새로 생성합니다. `vpc_cidr` 변수를 활용하여 VPC의 CIDR 블록을 제공합니다.
2. 생성된 VPC에 `Name` 태그를 포함한 적절한 태그를 추가합니다.
3. VPC CIDR 블록과 VPC 이름을 모두 수신하는 오브젝트에 `vpc_cidr` 변수를 마이그레이션하고 인프라에 대한 변경 없이 코드를 마이그레이션합니다.

## Step-by-Step Guide

1. 모듈 내에 `aws_vpc` 리소스를 새로 생성합니다. `vpc_cidr` 변수를 사용하여 VPC의 CIDR 블록을 제공합니다.
2. 생성된 VPC에 VPC에 추가할 `Name` 태그를 포함하여 태그를 추가합니다.
3. `terraform apply`을 실행하고 VPC가 생성되었는지 확인합니다. 작업을 확인하고 VPC가 성공적으로 생성되었는지 확인합니다.
4. `vpc_cidr` 변수를 VPC CIDR 블록과 VPC 이름을 모두 수신하는 객체로 마이그레이션합니다. 변수에 포함된 속성에 더 적합하도록 변수 이름을 변경합니다.

    ```
    variable "vpc_config" {
      type = object({
        cidr_block = string
        name       = string
      })

      validation {
        condition     = can(cidrnetmask(var.vpc_config.cidr_block))
        error_message = "The cidr_block config option must contain a valid CIDR block."
      }
    }
    ```

5. 또한 새 변수를 통해 받은 값을 올바르게 참조할 수 있도록 `aws_vpc` 리소스를 리팩터링해야 합니다. 모듈을 호출하는 코드도 리팩터링해야 합니다.

    ```
    # 13-local-modules/modules/networking/vpc.tf

    resource "aws_vpc" "this" {
      cidr_block = var.vpc_config.cidr_block

      tags = {
        Name = var.vpc_config.name
      }
    }

    ---

    # 13-local-modules/networking.tf

    module "vpc" {
      source = "./modules/networking"

      vpc_config = {
        cidr_block = "10.0.0.0/16"
        name       = "13-local-modules"
      }
    }
    ```

6. `terraform plan` 명령을 실행하고 인프라에 변경 사항이 없는지 확인하여 원치 않는 변경이 발생하지 않았는지 확인합니다.
7. 모든 단계를 완료한 후에는 반드시 리소스를 삭제하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 테라폼에서 객체 변수를 사용하여 마이그레이션하는 방법을 성공적으로 배웠습니다. 이는 복잡한 구성을 처리하는 데 중요한 기술입니다. 아직 끝나지 않았다는 것을 기억하세요! 다음 몇 번의 연습에서는 이 모듈을 계속 구현해 보겠습니다. 계속 열심히 공부하세요!
