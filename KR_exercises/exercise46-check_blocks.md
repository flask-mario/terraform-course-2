# Check Blocks

## Introduction

이 실습에서는 Terraform에서 `check` 블록을 생성하고 구현하는 과정을 안내합니다. AWS 인스턴스에서 누락된 태그에 대한 경고를 생성하는 검사를 생성하고 여러 가용성 영역에 서브넷을 분산하여 고가용성을 보장하는 방법을 배우게 됩니다. 단계별 지침을 따라 이 연습이 끝날 때까지 모범 사례를 적용하고 Terraform 스크립트에서 일반적인 실수를 방지하는 방법을 더 잘 이해하게 될 것입니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. `aw_instance`에 `CostCenter` 태그가 없을 때 경고를 생성하는 check를 만듭니다.
2. 관련 `CostCenter` 태그를 사용하여 `aws_instance` 리소스를 확장하고 경고가 더 이상 표시되지 않는지 확인합니다.
3. `aw_subnet` 리소스를 리팩터링하여 두 개의 서브넷을 생성합니다. AZ를 유효한 단일 값으로 하드코딩합니다.
4. `check` 블록을 생성하여 서브넷이 둘 이상의 가용 영역(AZ)에 분산되어 있는지 확인합니다.
5. 가용성 영역을 선택하기 위해 라운드 로빈 전략을 채택하도록 `aws_subnet` 리소스를 마이그레이션합니다.
6. 경고 메시지가 더 이상 표시되지 않는지 확인합니다.

## Step-by-Step Guide

1. `aw_instance`에 중요한 태그가 없을 때 경고를 생성하는 검사를 만들어 보겠습니다. 먼저 `CostCenter` 태그가 빈 문자열과 다른지 확인하는 어설션이 포함된 `check` 블록을 추가합니다. 또한 null 값이 있을 가능성도 고려하세요. (힌트: `can` 함수는 래퍼로 유용하게 사용할 수 있습니다).

    ```
    check "cost_center_check" {
      assert {
        condition     = can(aws_instance.this.tags.CostCenter != "")
        error_message = "Your AWS Instance does not have a CostCenter tag."
      }
    }
    ```

2. 변경 사항을 저장하고 `terraform plan`을 실행합니다. 위에서 정의한 검사에 따라 경고 메시지가 표시되어야 합니다.
3. 이제 `aws_instance` 리소스를 관련 CostCenter 태그로 확장하고 `terraform plan`을 다시 한 번 실행합니다. 경고가 사라졌는지 확인합니다.

    ```
    resource "aws_instance" "this" {
      ...

      tags = {
        CostCenter = "1234"
      }

      ...
    }
    ```

4. `aw_subnet` 리소스를 리팩터링하여 두 개의 서브넷을 생성합니다. `count` 메타 인수를 사용하고 `availability_zone` 속성을 작업 중인 지역의 유효한 단일 값으로 설정합니다(제 경우에는 `ap-northeast-2`입니다). 또한 `aws_instance` 리소스를 업데이트하여 그에 따라 서브넷을 검색해야 합니다.

    ```
    resource "aws_subnet" "this" {
      count             = 2
      vpc_id            = data.aws_vpc.default.id
      cidr_block        = "172.31.${128 + count.index}.0/24"
      availability_zone = "ap-northeast-2a"

      lifecycle {
        postcondition {
          condition     = contains(data.aws_availability_zones.available.names, self.availability_zone)
          error_message = "Invalid AZ"
        }
      }
    }
    ```

5. `check` 블록을 추가하여 서브넷이 둘 이상의 AZ에 분산되어 있는지 확인합니다. 조건 속성은 어떻게 생겼을까요?

    ```
    check "high_availability_check" {
      assert {
        condition     = length(toset([for subnet in aws_subnet.this : subnet.availability_zone])) > 1
        error_message = <<-EOT
          You are deploying all subnets within the same AZ.
          Please consider distributing them across AZs for higher availability.
          EOT
      }
    }
    ```

6. `terraform plan`을 실행하고 화면에 경고 메시지가 표시되는지 확인합니다.
7. 이제 가용성 영역을 선택하기 위해 라운드 로빈 전략을 채택하도록 `aws_subnet` 리소스를 마이그레이션합니다. 또한 서브넷 수를 `4`(또는 가용 영역이 `n개`인 지역의 경우 `n + 1`)로 업데이트하여 라운드 로빈이 예상대로 작동하는지 확인합니다.

    ```
    data "aws_vpc" "default" {
      default = true
    }

    data "aws_availability_zones" "available" {
      state = "available"
    }

    resource "aws_subnet" "this" {
      count      = 4
      vpc_id     = data.aws_vpc.default.id
      cidr_block = "172.31.${128 + count.index}.0/24"
      availability_zone = data.aws_availability_zones.available.names[
        count.index % length(data.aws_availability_zones.available.names)
      ]

      lifecycle {
        postcondition {
          condition     = contains(data.aws_availability_zones.available.names, self.availability_zone)
          error_message = "Invalid AZ"
        }
      }
    }

    check "high_availability_check" {
      assert {
        condition     = length(toset([for subnet in aws_subnet.this : subnet.availability_zone])) > 1
        error_message = <<-EOT
          You are deploying all subnets within the same AZ.
          Please consider distributing them across AZs for higher availability.
          EOT
      }
    }
    ```

8. `terraform plan`을 다시 실행하고 경고 메시지가 더 이상 표시되지 않는지 확인합니다.
9. 이 연습을 완료하기 전에 인프라를 삭제하세요.

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 테라폼에서 `check` 블록을 생성하고 구현하는 방법을 이해하는 데 중요한 단계를 밟았습니다. 다음 연습에서는 테라폼에 대해 더 자세히 알아볼 테니 계속 열심히 공부해 주세요.
