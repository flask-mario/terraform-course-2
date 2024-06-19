# 모듈의 출력 정의하기

## Introduction

이 연습에서는 모듈의 출력을 정의하겠습니다. 이는 다른 리소스나 모듈에서 사용할 수 있는 특정 값을 노출할 수 있기 때문에 Terraform 모듈 개발에서 매우 중요한 단계입니다. 우리는 VPC ID, public subnet, private subnet에 대한 출력을 만드는 데 집중할 것입니다. 여기에는 새로운 `vpc_id` 모듈 출력과 두 개의 새로운 출력인 `public_subnets` 및 `private_subnets`의 생성이 포함됩니다. 이러한 출력을 효과적으로 생성하고 활용하는 방법을 이해하는 데 도움이 되는 자세한 지침이 프로세스를 안내합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 생성된 VPC의 VPC ID를 노출하는 `vpc_id` 모듈 출력을 새로 생성합니다.
2. 제공된 서브넷 각각에 대해 `subnet_id`와 `availability_zone`을 노출하는 `public_subnets`와 `private_subnets` 두 개의 출력을 새로 정의합니다.

## Step-by-Step Guide

1. 생성된 VPC의 VPC ID를 노출하는 `vpc_id` 모듈 출력을 새로 생성합니다. 생성된 출력에 관련 설명을 추가합니다.

    ```
    output "vpc_id" {
      description = "The AWS ID from the created VPC"
      value       = aws_vpc.this.id
    }
    ```

2. 제공된 서브넷 각각에 대해 다음 정보를 노출하는 두 개의 새 출력인 `public_subnets`와 `private_subnets`를 생성합니다:

    1. 생성된 서브넷의 ID가 포함된 `subnet_id`를 입력합니다.
    2. 생성된 서브넷의 AZ를 포함하는 `availability_zone`.

    사용자가 `subnet_config` 변수에 제공한 키를 사용하여 출력 맵을 구성합니다. 이렇게 하면 사용자가 제공한 키를 기반으로 특정 서브넷에 대한 정보를 쉽게 검색할 수 있습니다. 코드를 깔끔하게 유지하세요:

    1. 인라인 `for` 루프를 제공하는 대신 값 구문 분석에 로컬을 도입합니다.
    2. 생성된 각 출력에 대한 설명 제공.

    ```

    locals {
      output_public_subnets = {
        for key in keys(local.public_subnets) : key => {
          subnet_id         = aws_subnet.this[key].id
          availability_zone = aws_subnet.this[key].availability_zone
        }
      }

      output_private_subnets = {
        for key in keys(local.private_subnets) : key => {
          subnet_id         = aws_subnet.this[key].id
          availability_zone = aws_subnet.this[key].availability_zone
        }
      }
    }

    output "public_subnets" {
      description = "The ID and the availability zone of public subnets."
      value       = local.output_public_subnets
    }

    output "private_subnets" {
      description = "The ID and the availability zone of private subnets."
      value       = local.output_private_subnets
    }
    ```

3. 루트 구성에서 모듈에서 수신하는 값을 시각화하기 위해 몇 가지 출력을 만듭니다.

    ```
    output "module_vpc_id" {
      value = module.vpc.vpc_id
    }

    output "module_public_subnets" {
      value = module.vpc.public_subnets
    }

    output "module_private_subnets" {
      value = module.vpc.private_subnets
    }
    ```

4. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 모듈의 출력을 정의함으로써 모듈 구현의 중요한 단계를 수행했습니다. 아직 끝나지 않았다는 것을 기억하세요! 다음 몇 번의 연습에서는 이 모듈을 계속 구현해 보겠습니다. 계속 열심히 하세요!
