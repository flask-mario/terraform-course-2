# `count` 인수를 사용하여 여러 서브넷 만들기

## Introduction

이 연습에서는 Terraform에서 `count` 인수를 사용하여 여러 서브넷을 생성하는 방법을 살펴봅니다. 이 연습은 Terraform에서 리소스를 효율적으로 관리하고 코드 중복을 피하는 방법을 이해하는 데 도움이 되도록 설계되었습니다. 로컬 변수를 정의하고, 가상 프라이빗 클라우드(VPC)를 생성하고, `count` 메타 인수를 사용하여 여러 서브넷을 생성하는 방법을 배우게 됩니다. 또한 `tags` 속성을 사용하여 `count.index` 값을 사용하여 서브넷에 고유 이름을 할당하는 방법과 새로운 `subnet_count` 변수를 생성하여 서브넷 수를 구성할 수 있게 만드는 방법도 배우게 됩니다. 이 연습에서는 이러한 작업을 수행하는 방법에 대한 단계별 가이드를 제공합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. CIDR 블록이 `10.0.0.0/16`으로 설정된 가상 프라이빗 클라우드(VPC)를 생성합니다. VPC에는 새로 생성된 `local.project` 로컬 변수의 값을 담고 있는 `Project` 및 `Name` 태그가 지정됩니다.
2. `count` 메타 인수를 활용하여 여러 개의 서브넷을 생성하면 코드 중복을 줄이고 확장을 더 쉽게 할 수 있습니다.
3. `count.index` 값과 `tags` 속성을 사용하여 서브넷에 고유한 이름을 할당합니다.
4. 서브넷 개수를 구성할 수 있도록 `aws_subnet` 리소스에 하드코딩된 개수 값을 대체하는 새 변수 `subnet_count`를 생성합니다.

## Step-by-Step Guide

1. 새 `networking.tf` 파일을 만들고, 작업 중인 `project`를 저장할 로컬 변수를 정의합니다. 이렇게 하면 코드를 깔끔하고 재사용 가능하게 유지하는 데 도움이 됩니다. 이 연습에서는 `11-multiple-resources` 값을 가진 프로젝트 변수가 있습니다.

    ```
    locals {
      project = "11-multiple-resources"
    }
    ```

2. `aws_vpc` 유형의 리소스를 정의하여 가상 프라이빗 클라우드(VPC)를 생성하고 CIDR 블록을 `10.0.0.0/16`으로 설정합니다. `local.project` 로컬 변수에 저장된 값을 저장하는 두 개의 태그, `Project`와 `Name`을 추가합니다.

    ```
    resource "aws_vpc" "main" {
      cidr_block = "10.0.0.0/16"

      tags = {
        Project = local.project
        Name    = local.project
      }
    }
    ```

3. 두 개의 `aws_subnet` 리소스를 추가하여 두 개의 서브넷을 생성합니다.

    ```
    resource "aws_subnet" "subnet1" {
      vpc_id     = aws_vpc.main.id
      cidr_block = "10.0.0.0/16"

      tags = {
        Project = local.project
        Name    = local.project
      }
    }

    resource "aws_subnet" "subnet2" {
      vpc_id     = aws_vpc.main.id
      cidr_block = "10.0.1.0/16"

      tags = {
        Project = local.project
        Name    = local.project
      }
    }
    ```

4. 이 방법은 작동하지만 중복이 많고 확장하기가 쉽지 않습니다. `count` 메타 인수를 사용하여 여러 서브넷을 생성해 보겠습니다. subnet2 항목을 제거하고 subnet1에 `count = 2` 메타 인수를 포함하도록 변경합니다. 리소스 이름을 `aws_subnet.subnet1` 대신 `aws_subnet.main`으로 변경합니다.

    ```
    resource "aws_subnet" "main" {
      count      = 2
      vpc_id     = aws_vpc.main.id
      cidr_block = "10.0.0.0/24"

      tags = {
        Project = local.project
        Name    = "${local.project}-${each.index}"
      }
    }

    ```

5. 이 구성을 적용해 보세요. 작동하나요? 어떤 오류가 발생하나요?
6. 서브넷을 성공적으로 생성하려면 CIDR 블록이 서로 겹치지 않는지 확인해야 합니다. `count` 메타 인수를 사용할 때마다 사용할 수 있는 `count.index` 값을 활용할 수 있습니다. 서브넷의 `cidr_block`을 `"10.0.${count.index}.0/24"`로 업데이트합니다. 여기서 `${count.index}`는 현재 반복의 인덱스이므로 각 서브넷에 고유한 CIDR 블록을 사용할 수 있습니다. `tags` 속성은 서브넷에 이름을 할당하는 데 사용되며, `count.index`를 활용하여 각 서브넷을 고유하게 식별할 수도 있습니다.

    ```
    resource "aws_subnet" "main" {
      count      = 2
      vpc_id     = aws_vpc.main.id
      cidr_block = "10.0.${count.index}.0/24"

      tags = {
        Project = local.project
        Name    = "${local.project}-${count.index}"
      }
    }
    ```

7. 마지막으로, `subnet_count` 변수를 새로 생성하고 `aws_subnet` 리소스에서 하드코딩된 카운트 값에서 마이그레이션합니다.

    ```
    variable "subnet_count" {
      type    = number
      default = 2
    }

    resource "aws_subnet" "main" {
      count      = var.subnet_count
      vpc_id     = aws_vpc.main.id
      cidr_block = "10.0.${count.index}.0/24"

      tags = {
        Project = local.project
        Name    = "${local.project}-${count.index}"
      }
    }
    ```

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! `count` 인수를 사용하여 여러 리소스를 생성하는 방법을 배움으로써 테라폼을 마스터하는 데 중요한 한 걸음을 내디뎠습니다. 리소스를 효율적으로 관리하고 코드 중복을 피하는 방법에 대한 이해도가 향상되었습니다. 계속 열심히 공부하세요!
