# Working with Locals

## Introduction

이 실습에서는 Terraform에서 로컬을 사용하는 방법을 살펴보겠습니다. 로컬은 입력 변수로 전달하지 않고도 모듈 내에서 재사용할 수 있는 변수를 정의할 수 있는 방법을 제공합니다. 일련의 단계를 통해 로컬을 정의하고, `common_tags` 블록을 생성하고, EC2 인스턴스를 리팩터링하고, 로컬을 활용하는 S3 리소스를 생성하고, 로컬 블록을 자체 파일로 이동하는 방법을 배우게 됩니다. 이 실습을 통해 로컬에 대한 이해도를 높이고 Terraform 프로젝트를 최적화하는 데 로컬을 어떻게 사용할 수 있는지 알아보세요.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. locals를 다음의 적절한 값으로 설정합니다.: `project`, `project_owner`, `cost_center`, `managed_by`.
2. 이전 로컬 객체 중 일부를 참조하여 객체를 생성하는 `common_tags` 로컬 객체를 만듭니다.
3. EC2 인스턴스의 태그를 설정할 때 `local.common_tags`와 `var.additional_tags`를 병합하도록 리팩터링합니다.
4. 구성에 로컬의 값도 사용하는 S3 리소스를 배포합니다.
5. 로컬 블록을 `shared-locals.tf`라는 자체 파일로 이동합니다.

## Step-by-Step Guide

1. 기존 파일에 `locals` 블록을 사용하여 `project`, `project_owner`, `cost_center`, `managed_by`와 같은 로컬을 정의합니다. Terraform에서 로컬은 입력 변수로 전달할 필요 없이 모듈 내에서 재사용할 수 있는 변수를 정의하는 방법입니다. 먼저 `compute.tf` 파일에 로컬 변수를 배치할 수 있습니다.

    ```
    locals {
      project       = "08-input-vars-locals-outputs"
      project_owner = "terraform-course"
      cost_center   = "1234"
      managed_by    = "Terraform"
    }
    ```

2. 해당 값을 객체와 유사한 구조로 통합하는 `common_tags` 블록을 정의합니다.

    ```
    locals {
      common_tags = {
        project       = local.project
        project_owner = local.project_owner
        cost_center   = local.cost_center
        managed_by    = local.managed_by
      }
    }
    ```

3. EC2 인스턴스를 태그 설정을 `local.common_tags`와 `var.additional_tags`를 merge를 사용하여 리팩터링 합니다.

    ```
    resource "aws_instance" "compute" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.ec2_instance_type

      root_block_device {
        delete_on_termination = true
        volume_size           = var.ec2_volume_config.size
        volume_type           = var.ec2_volume_config.type
      }

      tags = merge(local.common_tags, var.additional_tags)
    }
    ```

4. 구성에서 로컬의 일부 값을 활용하는 S3 리소스를 만듭니다.

    ```
    resource "random_id" "project_bucket_suffix" {
      byte_length = 4
    }

    resource "aws_s3_bucket" "project_bucket" {
      bucket = "${local.project}-${random_id.project_bucket_suffix.hex}"

      tags = merge(local.common_tags, var.additional_tags)
    }
    ```

5. 로컬 블록을 `shared-locals.tf`라는 자체 파일로 이동합니다. 테라폼 프로젝트에서 파일을 명시적으로 가져올 필요가 없다는 점에 유의하세요.

## Congratulations on Completing the Exercise!

Terraform에서 로컬을 사용하는 이 연습을 완료해 주셔서 감사합니다. 로컬 정의, `common_tags` 블록 생성, EC2 인스턴스 리팩토링, 로컬을 활용하는 S3 리소스 생성에 대한 실무 경험을 쌓으며 Terraform 기술을 향상시키는 데 중요한 단계를 밟으셨습니다. 계속 열심히 하세요!
