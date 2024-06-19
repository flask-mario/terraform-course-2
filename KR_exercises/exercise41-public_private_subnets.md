# Module을 확장해서 Public, Private Subnet 생성하기

## Introduction

이 연습에서는 public 및 private 서브넷을 모두 생성하도록 모듈을 확장해 보겠습니다. 이 과정에는 각 서브넷 구성에 대해 선택적 `public` 속성을 허용하도록 모듈의 `subnet_config` 변수를 수정하고 public으로 표시된 서브넷이 하나 이상 있는지 여부에 따라 특정 리소스를 배포하는 것이 포함됩니다. 이 실습을 통해 AWS에서 서브넷을 관리하고 구성하는 방법을 더 깊이 이해할 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 각 서브넷 구성에 대한 선택적 `public` 옵션을 받으려면 `subnet_config` 모듈을 확장합니다.
2. public으로 표시된 서브넷이 하나 이상 있는 경우에만 `aws_internet_gateway` 리소스를 배포합니다.
3. public으로 표시된 서브넷이 하나 이상 있는 경우에만 공개 `aws_route_table` 리소스를 배포합니다.
4. 모든 public 서브넷과 public route table에 필요한 라우트 테이블 연결을 배포합니다.

## Step-by-Step Guide

1. 각 서브넷 구성에 대해 선택적 `public` 옵션을 받으려면 `subnet_config` 변수를 확장합니다. 속성 유형은 부울이어야 하며, 값이 전달되지 않을 경우 기본값은 `false`입니다.

    ```
    variable "subnet_config" {
      type = map(object({
        cidr_block = string
        public     = optional(bool, false)
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

2. 모듈에서 두 개의 중간 로컬 변수를 저장하는 새 로컬 블록을 생성합니다:

    1. `public = true` 속성을 가진 서브넷에 대한 구성 개체만 포함된 `public_subnets`.
    2. `public = false`(또는 정의되지 않음) 속성을 가진 서브넷에 대한 구성 개체만 포함하는 `private_subnets`.

    ```
    locals {
      public_subnets = {
        for key, config in var.subnet_config : key => config if config.public
      }

      private_subnets = {
        for key, config in var.subnet_config : key => config if !config.public
      }
    }
    ```

3. `public_subnets` 로컬 변수에 항목이 하나 이상 있는 경우에만 `aws_internet_gateway` 리소스를 배포합니다.

    ```
    resource "aws_internet_gateway" "this" {
      count  = length(local.public_subnets) > 0 ? 1 : 0
      vpc_id = aws_vpc.this.id
    }
    ```

4. 마찬가지로, public_subnets 로컬 변수에 항목이 하나 이상 있는 경우에만 `aws_route_table` 리소스를 배포하세요. 라우트 테이블은 공개, 즉 인터넷 게이트웨이에 대한 항목이 있는 CIDR 블록이 `0.0.0.0/0`인 경로를 포함해야 합니다.

    ```
    resource "aws_route_table" "public_rtb" {
      count  = length(local.public_subnets) > 0 ? 1 : 0
      vpc_id = aws_vpc.this.id

      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this[0].id
      }
    }
    ```

5. 모든 public 서브넷과 public route table에 필요한 라우팅 테이블 연결을 배포합니다.

    ```
    resource "aws_route_table_association" "public" {
      for_each = local.public_subnets

      subnet_id      = aws_subnet.this[each.key].id
      route_table_id = aws_route_table.public_rtb[0].id
    }
    ```

6. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료했습니다! AWS에서 public 및 private 서브넷을 모두 생성하도록 모듈을 성공적으로 확장했습니다. 이는 서브넷을 관리하고 구성하는 방법을 이해하는 데 중요한 단계입니다. 아직 끝나지 않았다는 것을 기억하세요! 다음 몇 번의 연습에서는 이 모듈을 계속 구현해 보겠습니다. 계속 열심히 공부하세요!
