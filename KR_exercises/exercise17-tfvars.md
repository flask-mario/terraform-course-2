# `tfvars`로 작업하기

## Introduction

이 연습에서는 Terraform에서 `.tfvars` 파일을 사용하여 변수 구성을 관리하고 적용하는 방법을 살펴보겠습니다. 변수 구성이 포함된 파일을 만든 다음 이를 Terraform 플랜에 로드하겠습니다. 이는 인프라 설정에서 다양한 환경이나 단계를 관리할 수 있는 좋은 방법입니다. 전체 연습을 통해 `terraform.tfvars` 파일로 작업하는 방법을 직접 경험하고 구성을 관리하는 데 효과적으로 사용할 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 정의된 변수에 적합한 구성이 포함된 `terraform.tfvars` 파일을 생성합니다.
2. 파일 이름을 `dev.terraform.tfvars`로 변경하고 Terraform 명령을 실행할 때 어떤 일이 발생하는지 확인합니다.
3. 다른 변수 값으로 `prod.terraform.tfvars` 파일을 새로 생성합니다. 이 파일을 Terraform 플랜에 로드하고 명령을 적용하는 것을 테스트할 수 있어야 합니다.

## Step-by-Step Guide

1. 지금까지 정의한 변수에 대한 적절한 값으로 `terraform.tfvars` 파일을 생성합니다. 테라폼이 이 파일을 자동으로 찾기 때문에 파일 이름을 `terraform.tfvars`로 지정하는 것이 중요합니다.

    ```
    ec2_instance_type = "t2.micro"

    ec2_volume_config = {
      size = 10
      type = "gp2"
    }

    additional_tags = {
      ValuesFrom = "terraform.tfvars"
    }
    ```

2. `terraform plan` 및 `terraform apply` 명령을 실행하여 Terraform이 `terraform.tfvars` 파일에서 값을 올바르게 로드하는지 확인합니다.
3. 이제 파일 이름을 `dev.terraform.tfvars`로 바꾸고 `terraform plan` 및 `terraform apply` 명령을 다시 실행합니다. Terraform이 값을 로드할 수 있나요? Terraform은 다른 이름의 `.tfvars` 파일을 자동으로 로드하지는 않지만 `-var-file=<파일 이름>` 옵션을 사용하여 `.tfvars` 파일을 `terraform plan` 및 `terraform apply` 명령에 전달할 수 있습니다.
4. 새 `prod.terraform.tfvars` 파일을 생성합니다. 변수에 대해 다른 값을 설정하고 이 파일을 `terraform plan` 및 `terraform apply` 명령에 로드하는 방법을 테스트합니다. 아래 구성은 무료 티어를 벗어나므로 적용하지 마세요!

    ```
    ec2_instance_type = "t3.large"

    ec2_volume_config = {
      size = 10
      type = "gp3"
    }

    additional_tags = {
      ValuesFrom = "prod.terraform.tfvars"
    }
    ```

5. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료한 것을 축하합니다! 여러분은 Terraform에서 `.tfvars` 파일을 사용하여 변수 구성을 관리하고 적용하는 방법을 배웠습니다. 계속 연습하여 여러분의 Terraform 기술을 계속 향상시키세요!
