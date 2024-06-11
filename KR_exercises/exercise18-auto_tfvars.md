# `auto.tfvars`로 작업하기

## Introduction

이 연습에서는 Terraform에서 `auto.tfvars`로 작업하는 방법을 배웁니다. 여기에는 프로덕션 환경에서 Terraform을 실행할 때 특정 구성을 적용하는 데 사용되는 `prod.auto.tfvars` 파일을 생성하고 구성하는 것이 포함됩니다. 또한 Terraform이 `*.auto.tfvars` 파일에서 값을 자동으로 로드하는 방법과 이러한 값이 `terraform.tfvars` 파일에 있는 값을 재정의하는 방법도 배우게 됩니다.

## Step-by-Step Guide

1. 먼저, `prod.auto.tfvars`라는 파일을 새로 만듭니다. 이 파일에는 프로덕션 환경에서 Terraform을 실행할 때 적용하려는 특정 구성이 포함됩니다. 기본 구성이 포함된 `terraform.tfvars` 파일도 있는지 확인하세요.

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

2. `prod.auto.tfvars` 내에서 `ec2_instance_type`을 `t3.large`로 설정합니다. 이 설정은 Terraform이 배포할 EC2 인스턴스의 유형을 지정합니다.

    ```
    ec2_instance_type = "t3.large"
    ```

3. `ec2_volume_config` 블록을 정의합니다. 이 블록은 연동된 EBS 볼륨의 구성을 정의합니다. `size`를 `10`으로, `type`을 `gp3`로 설정합니다.

    ```
    ec2_volume_config = {
      size = 10
      type = "gp3"
    }
    ```

4. 마지막으로 `additional_tags` 블록을 추가합니다. 이 블록을 사용하면 리소스에 추가 태그를 추가할 수 있습니다. `ValuesFrom` 태그는 `prod.auto.tfvars`로 설정되어 `prod.auto.tfvars` 파일에서 값을 가져온다는 것을 나타냅니다.

    ```
    additional_tags = {
      ValuesFrom = "prod.terraform.tfvars"
    }
    ```

5. `prod.auto.tfvars` 파일을 저장하고 `terraform plan` 명령을 실행합니다. 테라폼은 어떤 값을 사용하나요?
6. 이후 계획 및 적용 명령에서 테라폼이 자동으로 값을 로드하지 못하도록 `prod.auto.tfvars`를 삭제합니다.

`*.auto.tfvars` 파일은 Terraform이 실행될 때 자동으로 로드됩니다. `*.auto.tfvars` 파일의 값은 `terraform.tfvars` 파일의 값을 재정의합니다. 즉, `terraform.tfvars` 파일과 `*.auto.tfvars` 파일 모두에 동일한 변수가 정의되어 있는 경우 `*.auto.tfvars` 파일의 값이 사용됩니다.

## Congratulations on Completing the Exercise!

이 연습을 성공적으로 완료하셨습니다! 클라우드 인프라 전문 지식을 계속 개발하는 데 있어 중요한 기술인 Terraform에서 `auto.tfvars`를 사용하는 방법을 배웠습니다. 계속 열심히 공부하세요!
