# 가용 영역 확인

## Introduction

이 연습에서는 구현 중인 VPC 모듈의 가용 영역(AZ)을 검증하는 데 중점을 두겠습니다. AZ를 검증함으로써 프로젝트에 적절하고 사용 가능한 영역을 활용하고 있는지 확인할 수 있습니다. 이 연습에서는 사용 가능한 AZ를 검색하기 위한 데이터 소스를 만들고, AWS 서브넷 리소스에 전제 조건 수명 주기 블록을 추가하고, 잘못된 AZ에 대한 사용자 친화적인 오류 메시지를 작성하는 과정을 포함합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 프로젝트의 해당 지역 내에서 사용 가능한 가용 영역(AZ)만 검색하는 데이터 소스 `aws_availability_zones.available`을 생성합니다.
2. `aw_subnet.this` 리소스에 `pre-condition` 라이프사이클 블록을 추가합니다. 이 전제 조건 확인은 제공된 가용 영역이 첫 번째 단계에서 생성된 데이터 소스에서 검색된 AZ에 포함되어 있는지 확인해야 합니다.
3. 잘못된 가용 영역이 제공된 경우 사용자에게 알리기 위한 사용자 친화적인 오류 메시지를 제공합니다.

## Step-by-Step Guide

1. 프로젝트의 해당 지역 내에서 사용 가능한 AZ만 검색하는 데이터 소스 `aws_availability_zones.available`을 만듭니다.

    ```
    data "aws_availability_zones" "available" {
      state = "available"
    }
    ```

2. `aw_subnet.this` 리소스에 `pre-condition` 수명 주기 블록을 추가합니다. 이 전제 조건 확인에서는 제공된 가용성 영역이 이전 단계에서 생성한 데이터 소스에서 검색된 AZ에 포함되어 있는지 확인합니다.

    ```
    resource "aws_subnet" "this" {
      for_each          = var.subnet_config
      vpc_id            = aws_vpc.this.id
      availability_zone = each.value.az
      cidr_block        = each.value.cidr_block

      tags = {
        Name   = each.key
      }

      lifecycle {
        precondition {
          condition     = contains(data.aws_availability_zones.available.names, each.value.az)
          error_message = "Invalid AZ."
        }
      }
    }
    ```

3. 잘못된 가용 영역이 제공된 경우 사용자에게 알릴 수 있는 사용자 친화적인 오류 메시지를 작성합니다. 오류 메시지에 관련 값을 보간하여 사용자가 최대한 많은 정보를 얻을 수 있도록 하세요.

    ```
    resource "aws_subnet" "this" {
      for_each          = var.subnet_config
      vpc_id            = aws_vpc.this.id
      availability_zone = each.value.az
      cidr_block        = each.value.cidr_block

      tags = {
        Name   = each.key
      }

      lifecycle {
        precondition {
          condition     = contains(data.aws_availability_zones.available.names, each.value.az)
          error_message = <<-EOT
          The AZ "${each.value.az}" provided for the subnet "${each.key}" is invalid.

          The applied AWS region "${data.aws_availability_zones.available.id}" supports the following AZs:
          [${join(", ", data.aws_availability_zones.available.names)}]
          EOT
        }
      }
    }
    ```

4. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료하셨습니다! AWS 인프라에서 가용 영역의 유효성을 검사하는 방법을 이해하는 데 중요한 단계를 밟으셨습니다. 이 지식은 탄력적이고 안정적인 클라우드 기반 시스템을 관리하고 유지 관리하는 데 매우 중요합니다. 다음 연습에서는 모듈을 계속 구현해 보겠습니다. 계속 노력하세요!
