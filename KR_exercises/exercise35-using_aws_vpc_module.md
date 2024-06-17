# AWS VPC 모듈 사용

## Introduction

이 연습에서는 AWS VPC 모듈을 사용하여 특정 서브넷 구성으로 가상 프라이빗 클라우드(VPC)를 설정합니다. 이 연습은 AWS 리소스, 특히 VPC와 서브넷을 생성하고 관리하는 데 있어 Terraform 모듈과 그 애플리케이션에 더 익숙해지는 데 도움이 되도록 설계되었습니다. 이 연습이 끝나면 데이터 소스를 사용하는 방법, AWS VPC 모듈을 사용하여 VPC를 생성하는 방법, 사설 및 공용 서브넷 구성을 지정하는 방법에 대해 더 깊이 이해하게 됩니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶은 경우, 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 공용 AWS VPC 모듈을 사용하여 `10.0.0.0/16`의 CIDR 블록으로 `12-public-modules`라는 이름의 VPC를 생성합니다.
2. 데이터 소스로 사용 가능한 가용 영역을 가져옵니다.
3. VPC 모듈을 확장하여 CIDR 블록이 `10.0.0.0/24`인 사설 서브넷을 생성합니다.
4. VPC 모듈을 확장하여 CIDR 블록이 `10.0.128.0/24`인 공용 서브넷을 생성합니다.

## Step-by-Step Guide

1. 프로젝트 디렉토리에 `12-public-modules` 폴더를 새로 생성하고 구성 블록을 추가합니다. 사용 중인 관련 리전으로 AWS 공급자를 구성합니다.

    ```
    terraform {
      required_version = "~> 1.7"
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
      }
    }

    provider "aws" {
      region = "eu-west-1"
    }
    ```

2. 데이터 소스를 사용하여 지정된 지역에 대해 사용 가능한 가용 영역을 가져옵니다.

    ```
    data "aws_availability_zones" "azs" {
      state = "available"
    }
    ```

3. 이제 AWS의 공용 VPC 모듈을 사용하여 VPC와 서브넷을 생성해 보겠습니다. 호환성을 보장하기 위해 버전 `5.5.3`을 사용합니다. VPC 정보에 다음 값을 사용하겠습니다:

    1. VPC CIDR block: `10.0.0.0/16`
    2. VPC name: `12-public-modules`
    3. VPC availability zones: 생성한 데이터 소스의 이름입니다.
    4. Private subnet CIDRs: `["10.0.0.0/24"]`
    5. Public subnet CIDRs: `["10.0.128.0/24"]`

    ```
    module "vpc" {
      source  = "terraform-aws-modules/vpc/aws"
      version = "5.5.3"

      cidr            = "10.0.0.0/16"
      name            = "12-public-modules"
      azs             = data.aws_availability_zones.azs.names
      private_subnets = ["10.0.0.0/24"]
      public_subnets  = ["10.0.128.0/24"]
    }
    ```

4. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! AWS 퍼블릭 모듈로 작업하는 방법을 배움으로써 Terraform과 AWS를 마스터하는 데 한 걸음 더 나아갔습니다. 계속 열심히 하세요!
