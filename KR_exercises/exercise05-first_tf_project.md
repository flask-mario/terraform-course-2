# Our First Terraform Project

## Introduction

이 실습에서는 널리 사용되는 코드형 인프라 도구인 Terraform을 사용하여 첫 번째 프로젝트를 만들어 보겠습니다. Terraform 프로젝트 설정, AWS 공급자 구성, 리소스 이름 지정을 위한 임의 ID 생성, AWS S3 버킷 생성 및 버킷 이름 출력의 기본 사항을 다룰 것입니다. 이를 통해 Terraform을 사용하여 AWS 리소스를 관리하는 방법을 실습으로 소개합니다. 시작해 보겠습니다!

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 테라폼 버전을 설정하고 필요한 공급자(`random` 및 `AWS`)를 지정합니다.
2. 코스에 사용 중인 지역을 사용하도록 AWS 공급자를 구성합니다.
3. AWS S3 버킷 이름에 대한 임의 ID를 생성합니다.
4. AWS S3 버킷을 생성합니다.
5. 버킷 이름에 대한 출력 블록을 생성합니다.

### Useful Resources

-   Terraform Random provider: [https://registry.terraform.io/providers/hashicorp/random/latest/docs](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

## Step-by-Step Guide

1. '테라폼' 블록에서 필요한 테라폼 버전(`~> 1.7`)을 지정합니다. 또한 필요한 공급자와 해당 버전을 정의합니다. 이 경우, `aws` 공급자(`~> 5.0`)와 `random` 공급자(`~> 3.0`)가 필요합니다.

    ```
    terraform {
      required_version = "~> 1.7"
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
        random = {
          source  = "hashicorp/random"
          version = "~> 3.0"
        }
      }
    }
    ```

2. `provider` 블록을 사용하여 AWS 리전을 `"ap-northeast-2"`로 구성합니다.

    ```
    provider "aws" {
      region = "ap-northeast-2"
    }
    ```

3. `"bucket_suffix"`라는 이름의 `random_id` 리소스를 `byte_length`가 `6`인 리소스로 생성합니다. 이 ID는 S3 버킷의 고유 이름을 만드는 데 사용됩니다.

    ```
    resource "random_id" "bucket_suffix" {
      byte_length = 6
    }
    ```

4. `aws_s3_bucket` 리소스 이름을 `example_bucket`으로 생성하세요. 랜덤 ID를 `"example-bucket-"`에 추가하여 고유한 버킷 이름을 만들기 위해 인터폴레이션을 사용하세요.`

    ```
    resource "aws_s3_bucket" "example_bucket" {
      bucket = "example-bucket-${random_id.bucket_suffix.hex}"
    }
    ```

5. 마지막으로 `output` 블록을 사용하여 생성된 버킷의 이름을 출력합니다.

    ```
    output "bucket_name" {
      value = aws_s3_bucket.example_bucket.bucket
    }
    ```

6. 테라폼 구성을 작성한 후 터미널에서 다음 테라폼 CLI 명령을 실행합니다:
    - `terraform init`: 이 명령은 필요한 공급자 플러그인을 다운로드하여 Terraform 워크스페이스를 초기화합니다.
    - `terraform plan`: 이 명령은 실제로 변경하지 않고도 Terraform이 인프라에 어떤 변화를 가져올지 보여줍니다.
    - `terraform apply`: 이 명령은 변경 사항을 적용하여 인프라를 만듭니다.
    - `terraform destroy`: 인프라 생성이 완료되었으면 이 명령을 사용하여 Terraform 구성으로 생성된 모든 리소스를 제거하세요.

## Congratulations on Completing the Exercise!

이 연습을 잘 완료했습니다! 테라폼 여정에서 한 걸음 더 나아갔습니다. 계속 연습하고 기술을 향상시키세요. 새로운 도구나 기술을 익히려면 꾸준한 연습이 중요하다는 것을 기억하세요. 축하합니다!
