# Taints를 이용한 리소스 대체

## Introduction

이 연습에서는 Terraform에서 "tainting" 개념을 탐색합니다. 이는 리소스를 다음 계획에서 다시 생성하기 위해 표시하는 방법입니다. `terraform taint` 및 `terraform untaint` 명령을 사용하여 리소스의 라이프사이클을 제어하는 방법을 배우게 될 것입니다. 이를 위해 S3 버킷과 VPC를 생성하고 관리하며, 이러한 리소스에 대한 tainting이 관련 리소스에 어떤 영향을 미치는지 관찰할 것입니다. 또한 tainted 리소스의 재생성으로 인해 발생할 수 있는 잠재적인 문제를 처리하는 방법에 대해 알아볼 것입니다. 이 연습을 통해 Terraform에서 리소스 종속성과 라이프사이클 관리에 대한 이해력을 향상시킬 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:


1. S3 버킷을 생성합니다.
2. CLI를 통해 버킷을 tainted 상태로 표시하고 untaint 상태로 변경합니다.
3. 올바른 CIDR 블록을 가진 VPC와 해당 VPC 내의 서브넷을 생성합니다.
4. VPC를 tainted 상태로 표시하고 해당 VPC의 재생성이 서브넷의 재생성을 트리거하는지 확인합니다.
5. `aws_s3_bucket_public_access_block` 리소스를 생성하고, `block_public_acls` 및 `block_public_policy` 옵션을 false로 설정합니다.
6. S3 버킷을 tainted 상태로 표시하고, 해당 버킷의 재생성이 `aws_s3_bucket_public_access_block` 리소스의 재생성을 **트리거하지 않는지** 확인합니다. 이 동작의 결과는 무엇인가요? 라이프사이클 메타-인자를 사용하여 이 문제를 해결할 수 있을까요?


## Step-by-Step Guide


1. `taint.tf`라는 새 파일을 생성하고 파일 내에 S3 버킷을 생성합니다. `terraform apply`를 실행하여 버킷을 생성합니다.


    ```
    resource "aws_s3_bucket" "tainted" {
      bucket = "my-tainted-bucket-19384981jhahds"
    }
    ```


2. CLI 명령 `terraform taint aws_s3_bucket.tainted`을 사용하여 버킷을 tainted 상태로 표시합니다. `terraform apply` 명령을 실행하고 Terraform이 리소스를 재생성하기 위해 표시한 것을 확인합니다.
3. `terraform untaint aws_s3_bucket.tainted`를 실행하여 버킷을 untaint 상태로 변경합니다. 이제 Terraform이 리소스를 다시 생성하려고 시도하지 않을 것임을 확인합니다.
4. 이제 tainted 리소스가 재생성될 때 Terraform이 종속 리소스를 어떻게 처리하는지 알아보겠습니다. 이를 위해 동일한 CIDR 블록을 사용하여 VPC와 서브넷을 생성합니다. `terraform apply`를 사용하여 리소스를 생성합니다.


    ```
    resource "aws_vpc" "this" {
      cidr_block = "10.0.0.0/16"
    }

    resource "aws_subnet" "this" {
      vpc_id     = aws_vpc.this.id
      cidr_block = "10.0.0.0/24"
    }
    ```


5. 우리가 생성한 `aws_vpc`를 tainted 상태로 표시하고, terraform apply 명령을 실행합니다. 출력은 어떻게 나오나요?
6. Terraform은 기본적으로 downstream 리소스를 항상 다시 생성하지 않습니다. 이를 시각화하기 위해 S3 버킷에 `aws_s3_bucket_public_access_block` 리소스를 추가하세요. `block_public_acls`와 `block_public_policy`를 모두 false로 설정하여 문제를 더 쉽게 시각화할 수 있도록 합니다.


    ```
    resource "aws_s3_bucket_public_access_block" "from_tainted" {
      bucket = aws_s3_bucket.tainted.bucket

      block_public_acls       = false
      block_public_policy     = false
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
    ```


7. `terraform apply`를 통해 생성을 확인하고 AWS 콘솔에서 공개 액세스 블록이 올바르게 구성되었는지 확인합니다.
8. S3 버킷을 tainted 상태로 표시하고 `terraform apply`를 실행합니다. 변경 사항을 확인하고 AWS 콘솔에서 공개 액세스 블록이 Terraform 구성과 일치하는지 확인합니다.
9. 이 연습을 마치기 전에 인프라를 삭제하는 것을 잊지 마세요!


## Congratulations on Completing the Exercise!

이 연습을 완료하신 것을 축하드립니다! Terraform을 숙달하기 위한 또 다른 중요한 단계를 거치셨습니다! 리소스의 tainting과 untainting에 대한 습득한 지식은 Terraform 인프라 관리에 필수적입니다. 좋은 작업을 계속 이어나가세요!
