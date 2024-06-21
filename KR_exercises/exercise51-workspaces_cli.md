# Terraform CLI에서 워크스페이스 만들기

## Introduction

이 실습에서는 Terraform CLI(명령줄 인터페이스)에서 작업 공간을 만드는 방법을 자세히 살펴보겠습니다. 초기 구성 설정부터 데모용 S3 버킷 생성, 마지막으로 새 워크스페이스 생성까지 프로세스를 단계별로 안내해 드립니다. 이 실습을 통해 자신의 프로젝트에서 워크스페이스를 효과적으로 활용할 수 있는 실용적인 지식을 갖추게 될 것입니다.

## Step-by-Step Guide

1. 이 섹션의 파일을 저장할 새 폴더를 만듭니다. Terraform 필수 버전과 필수 공급자, 그리고 AWS 공급자 리전을 구성합니다.
2. `terraform workspace -help`를 실행하고 CLI 작업 공간에 대한 설명서를 살펴봅니다.
3. `terraform workspace show`를 실행하여 작업 중인 워크스페이스를 확인합니다.
4. 사용 가능한 모든 워크스페이스를 나열하려면 `terraform workspace list`을 실행합니다.
5. 데모용으로 새 S3 버킷을 생성합니다. 버킷 이름 끝에 임의의 ID를 포함하세요. `terraform apply`로 변경 사항을 확인합니다.

    ```
    resource "random_id" "bucket_suffix" {
      byte_length = 4
    }

    resource "aws_s3_bucket" "this" {
      count  = var.bucket_count
      bucket = "workspaces-demo-${random_id.bucket_suffix.hex}"
    }
    ```

6. `terraform workspace new dev`로 새 워크스페이스를 생성합니다.
7. `terraform apply`를 실행하고 어떤 일이 발생하는지 확인합니다.
8. 연습을 마치기 전에 인프라를 파괴하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 정말 수고하셨습니다! Terraform CLI에서 워크스페이스를 만들고 관리하는 방법을 이해하는 데 중요한 단계를 밟으셨습니다. 앞으로도 계속 열심히 하세요!
