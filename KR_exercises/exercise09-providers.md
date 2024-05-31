# Working with Providers

## Introduction

이 실습에서는 특히 AWS 제공자에 초점을 맞춰 Terraform의 제공자 개념을 살펴보겠습니다. 각각 다른 지역을 대상으로 하는 여러 AWS 제공자 인스턴스를 구성하는 방법을 배우게 됩니다. 이 연습이 끝나면 별도의 공급자 인스턴스를 사용하여 서로 다른 AWS 지역에 리소스를 배포할 수 있게 됩니다. 시작해 보겠습니다!

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 원하는 리전을 사용하도록 기본 AWS 공급자를 구성합니다(이 경우 `ap-northeast-2`).
2. 지역을 `us-east-1`로 설정하고 별칭을 `us-east`로 설정한 다른 AWS 공급자의 인스턴스를 구성합니다.
3. `ap-northeast-2` 리전에 S3 버킷 리소스를 생성합니다.
4. `us-east-1` 리전에 S3 버킷 리소스를 생성합니다.

## Step-by-Step Guide

1. Terraform 프로젝트 폴더 내에서 `provider.tf` 파일을 생성하고 `terraform` 블록 내의 `required_providers` 블록에 필요한 Terraform 버전과 AWS 공급자 소스 및 버전을 선언합니다:

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
    ```

2. 원하는 지역을 사용하도록 기본 `aws` 공급자를 구성합니다(제 경우에는 `ap-northeast-2`입니다):

    ```
    provider "aws" {
      region = "ap-northeast-2"
    }
    ```

3. 다른 `provider` 블록을 추가하고 리전을 `us-east-1`로 설정하여 `aws` 제공자의 다른 인스턴스를 구성합니다. 또한 나중에 리소스와 함께 사용할 수 있도록 별칭을 할당합니다:

    ```
    provider "aws" {
      region = "us-east-1"
      alias  = "us-east"
    }
    ```

4. `ap-northeast-2` 리전에 S3 버킷 리소스를 생성합니다:

    ```
    resource "aws_s3_bucket" "eu_west_1" {
      bucket = "some-random-bucket-name-aosdhfoadhfu"
    }
    ```

5. `us-east-1` 리전에 다른 S3 버킷 리소스를 생성합니다. 이번에는 앞서 생성한 별칭을 사용하여 리소스의 `provider` 인수에 전달하여 공급자를 지정합니다:

    ```
    resource "aws_s3_bucket" "us_east_1" {
      bucket   = "some-random-bucket-name-18736481364"
      provider = aws.us-east
    }
    ```

6. 프로젝트 디렉터리에서 `terraform init` 명령을 사용하여 Terraform을 초기화합니다.
7. `terraform validate` 명령을 사용하여 구성의 유효성을 검사합니다.
8. 구성이 유효하면 `terraform apply` 명령을 사용하여 적용합니다.
9. AWS 콘솔 또는 CLI를 사용하여 리소스가 두 리전에 올바르게 배포되었는지 확인합니다.
10. 모든 단계를 완료한 후에는 리소스를 반드시 삭제하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 수고하셨습니다! 테라폼에서 제공자의 개념을 성공적으로 탐색했으며 특히 AWS 제공자에 집중했습니다. 각각 다른 지역을 대상으로 하는 여러 AWS 공급자의 인스턴스를 구성하는 방법을 배웠으며, 별도의 공급자 인스턴스를 사용하여 서로 다른 AWS 지역에 리소스를 배포했습니다. 계속 열심히 하세요!
