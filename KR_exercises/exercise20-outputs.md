# Working with Outputs

## Introduction

이 연습에서는 Terraform에서 출력으로 작업하는 방법을 살펴보겠습니다. 출력은 리소스와 모듈에 대한 데이터를 노출하는 방법으로, 리소스의 상태를 이해하거나 다른 시스템과 통합하는 데 매우 유용할 수 있습니다. 로컬을 정의하고, S3 버킷을 설정하고, 버킷 이름에 대한 출력을 생성하겠습니다. 그런 다음 터미널에서 출력을 실행하고 검사하고 Terraform 외부에서 출력 값을 검색하는 방법을 배워보겠습니다. 시작해 봅시다!

## Step-by-Step Guide

1. 이전 연습에 따라 로컬을 정의했는지 확인합니다.

    ```
    locals {
      project       = "08-input-vars-locals-outputs"
      project_owner = "terraform-course"
      cost_center   = "1234"
      managed_by    = "Terraform"
    }

    locals {
      common_tags = {
        project       = local.project
        project_owner = local.project_owner
        cost_center   = local.cost_center
        managed_by    = local.managed_by
        sensitive_tag = var.my_sensitive_value
      }
    }
    ```

2. 또한 접미사로 `random_id`와 함께 S3 버킷이 올바르게 설정되어 있는지 확인하세요. EC2 인스턴스 코드를 주석 처리하여 terraform apply 명령이 더 빨리 완료되도록 할 수 있습니다.

    ```
    # s3.tf

    resource "random_id" "project_bucket_suffix" {
      byte_length = 4
    }
    resource "aws_s3_bucket" "project_bucket" {
      bucket = "${local.project}-${random_id.project_bucket_suffix.hex}"

      tags = merge(local.common_tags, var.additional_tags)
    }

    ---

    # compute.tf

    # resource "aws_instance" "compute" {
    #   ami           = data.aws_ami.ubuntu.id
    #   instance_type = var.ec2_instance_type

    #   root_block_device {
    #     delete_on_termination = true
    #     volume_size           = var.ec2_volume_config.size
    #     volume_type           = var.ec2_volume_config.type
    #   }

    #   tags = merge(local.common_tags, var.additional_tags)
    # }
    ```

3. 버킷 이름을 출력하는 `s3_bucket_name`이라는 출력을 생성합니다. 출력에 적절한 설명을 추가합니다.

    ```
    output "s3_bucket_name" {
      value       = aws_s3_bucket.project_bucket.bucket
      description = "The name of the S3 bucket"
    }
    ```

4. terraform apply 명령을 실행하고 확인한 후 터미널에서 출력되는 내용을 확인합니다.
5. 테라폼 외부에서 출력 값을 검색하려면 `terraform output <output name>` 명령을 실행합니다. 이 경우 `terraform output s3_bucket_name`이 됩니다.
    1. 큰따옴표를 생략하는 `-raw` 플래그를 추가하여 출력값을 다른 셸 명령에서 사용할 수 있도록 할 수도 있습니다.

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 여러분은 테라폼에서 출력물을 다루는 방법을 이해하는 데 또 한 걸음 더 나아갔습니다. 과정을 진행하면서 배운 내용을 계속 적용하고 개선해 나가시기 바랍니다.
