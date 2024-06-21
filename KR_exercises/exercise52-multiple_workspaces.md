# 여러 작업 공간으로 작업하기

## Introduction

이 연습에서는 여러 개의 Terraform 작업 공간으로 작업하는 방법을 살펴봅니다. 버킷 이름을 확장하여 그 값에 `terraform.workspace` 표현식을 포함하도록 하고 여러 작업 공간에 변경 사항을 적용하는 방법을 배웁니다. 또한 Terraform 구성에서 `terraform.workspace` 값의 적절한 사용과 부적절한 사용에 대해서도 살펴보겠습니다. 이 연습이 끝나면 Terraform에서 여러 워크스페이스를 효율적으로 관리하고 조작하는 방법을 이해하게 될 것입니다.

## Step-by-Step Guide

1. 버킷 이름을 확장하여 그 값에 `terraform.workspace` 표현식을 포함시킵니다. `dev` 및 `default` 작업 공간 모두에 terraform 적용을 사용하여 변경 사항을 적용합니다.

    ```
    resource "random_id" "bucket_suffix" {
      byte_length = 4
    }

    resource "aws_s3_bucket" "this" {
      bucket = "workspaces-demo-${terraform.workspace}-${random_id.bucket_suffix.hex}"
    }
    ```

2. **잘못된 코드 스포일러 경고!** 테라폼 구성에서 terraform.workspace의 값을 사용하지 않는 방법을 살펴보겠습니다. 이를 위해 먼저 `prod`와 `staging`라는 두 개의 워크스페이스를 더 만들어 보겠습니다. 이제 다음 규칙에 따라 여러 버킷을 배포하도록 S3 버킷 구성을 확장합니다:

    1. `prod` workspace에 3개의 버킷을 배포해야 합니다.
    2. `staging` workspace에 2개의 버킷을 배포해야 합니다.
    3. `dev` workspace에 1개의 버킷을 배포해야 합니다.

    또한 버킷 이름에 `count.index` 값을 추가하여 고유하도록 해야 합니다. 다음은 `terraform.workspace`를 **사용하지 않는** 방법입니다!

    ```
    resource "aws_s3_bucket" "this" {
      count  = terraform.workspace == "prod" ? 3 : terraform.workspace == "staging" ? 2 : 1
      bucket = "workspaces-demo-${terraform.workspace}-${count.index}-${random_id.bucket_suffix.hex}"
    }
    ```

3. 저희가 만든 세 개의 다른 워크스페이스에 이 구성을 적용해 보세요. 이 방법은 작동하지만 위의 코드는 읽고 유지 관리하기가 매우 어렵습니다. 훨씬 더 좋은 방법이 있으며 다음 연습에서 이를 살펴보겠습니다.

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 수고하셨습니다! Terraform에서 여러 작업 공간을 관리하고 조작하는 방법을 이해하는 데 큰 진전을 이루었습니다. 이는 테라폼을 마스터하기 위한 중요한 단계입니다. 계속 열심히 하세요!
