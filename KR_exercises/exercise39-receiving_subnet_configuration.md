# 서브넷 구성을 수신하도록 VPC 모듈 확장하기

## Introduction

이 연습에서는 서브넷 구성을 수신하고 각 리소스를 생성하도록 VPC 모듈을 확장해 보겠습니다. 새 모듈 변수를 추가하고, 루트 구성에서 모듈 블록을 조정하고, 모듈 내에 새 리소스를 생성하겠습니다. 여기서는 `for_each` 루프와 `subnet_config` 변수를 사용하겠습니다. 이 상세 가이드는 이를 달성하는 데 필요한 모든 단계를 안내합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 모듈에 사용자로부터 서브넷 CIDR 블록과 가용성 영역을 수신하는 새 모듈 변수 `subnet_config`를 생성합니다.
2. 루트 구성에서 모듈 블록을 조정하여 CIDR 블록 `10.0.0.0/24`를 사용하는 단일 서브넷에 대한 항목과 작업 중인 지역에 대한 유효한 AZ를 추가합니다.
3. 모듈 내에서 새 리소스를 구현하여 `for_each` 루프와 `subnet_config` 변수를 사용하여 실제 서브넷을 생성합니다.

## Step-by-Step Guide

1. 모듈에서 사용자가 여러 서브넷을 만들 수 있어야 하므로 객체의 맵 유형이 될 새 변수 `subnet_config`를 만듭니다. 맵을 사용하면 사용자가 키를 지정할 수 있으며, 나중에 서브넷 정보를 예측 가능하게 검색하는 데 사용할 수 있습니다. 객체에는 다음과 같은 속성이 포함되어야 합니다:

    1. 해당 서브넷의 CIDR 블록을 수신하는 `cidr_block`.

    ```terraform
    variable "subnet_config" {
      type = map(object({
        cidr_block = string
      }))

      validation {
        condition = alltrue([
          for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
        ])
        error_message = "The cidr_block config option must contain a valid CIDR block."
      }
    }
    ```

2. 루트 구성에서 모듈 블록을 조정하여 단일 서브넷에 대한 항목을 추가합니다. 서브넷 CIDR 블록으로 `10.0.0.0/24`를 사용할 수 있습니다. 테라폼 플랜`을 실행하여 오류가 없는지 확인합니다.

    ```terraform
    module "vpc" {
      source = "./modules/networking"

      vpc_config = {
        cidr_block = "10.0.0.0/16"
        name       = "13-local-modules"
      }

      subnet_config = {
        subnet_1 = {
          cidr_block = "10.0.0.0/24"
        }
      }
    }
    ```

3. 서브넷 객체의 속성으로 가용성 영역도 수신하도록 `subnet_config` 변수를 확장하고, 모듈 블록을 조정하여 `subnet_1`에 유효한 가용성 영역을 추가합니다.

    ```
    variable "subnet_config" {
      type = map(object({
        cidr_block = string
        az         = string
      }))

      validation {
        condition = alltrue([
          for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
        ])
        error_message = "The cidr_block config option must contain a valid CIDR block."
      }
    }
    ```

4. 모듈 내에 새 리소스를 생성하여 실제 서브넷을 생성합니다. `for_each` 루프와 방금 생성한 변수를 활용합니다.

    ```
    resource "aws_subnet" "this" {
      for_each          = var.subnet_config
      vpc_id            = aws_vpc.this.id
      availability_zone = each.value.az
      cidr_block        = each.value.cidr_block

      tags = {
        Name   = each.key
      }
    }
    ```

5. `terraform plan`을 실행하고 하나의 리소스가 생성될 예정임을 확인하여 서브넷이 실제로 생성되는지 확인합니다.
6. 모든 단계를 완료한 후에는 리소스를 반드시 삭제하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 서브넷 구성을 수신하도록 VPC 모듈을 성공적으로 확장했습니다. 아직 끝나지 않았다는 것을 기억하세요! 다음 몇 번의 연습에서는 이 모듈을 계속 구현해 보겠습니다. 계속 열심히 하세요!
