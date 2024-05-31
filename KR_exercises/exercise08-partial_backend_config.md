# Partial Backend Configuration

## Introduction

이 연습에서는 Terraform에 대한 부분적인 백엔드 구성을 설정하는 과정을 안내합니다. 이 튜토리얼에서는 Terraform용 S3 백엔드를 구성하고, 개발 환경과 프로덕션 환경을 위한 별도의 백엔드 구성 파일을 만들고, Terraform이 사용할 백엔드 구성 파일을 지정하는 방법을 안내합니다. 이 연습을 완료하면 Terraform에서 다양한 환경에 대한 다양한 백엔드 구성을 관리하는 방법에 대해 보다 심층적으로 이해할 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 테라폼용 S3 백엔드를 성공적으로 구성합니다.
2. 개발 환경에 대한 부분적인 백엔드 구성을 제공하기 위해 `dev.tfbackend` 파일을 생성합니다.
3. 프로덕션 환경의 부분 백엔드 구성을 제공하기 위해 `prod.tfbackend` 파일을 생성합니다.
4. 명령줄 인수로 전달하여 Terraform이 사용할 백엔드 구성 파일을 지정할 수 있습니다.

## Step-by-Step Guide

1. `04-backends` 폴더에서 파일 작업을 계속합니다.
2. Terraform 구성에서 `backend "s3"` 블록을 다음으로 바꿉니다:

    ```
    backend "s3" {
      bucket = "<your-bucket-name>"
      region = "<your-aws-region>"
    }
    ```

    특정 백엔드 키를 제거하고 대신 `tfbackend` 파일에서 환경을 포함하는 키를 사용한다는 점에 유의하세요.

3. `dev.tfbackend`라는 파일을 생성합니다. 이 파일은 개발 환경에 대한 부분적인 백엔드 구성을 제공합니다. `dev.tfbackend` 파일에 다음을 추가합니다:

    ```
    key = "04-backends/dev/state.tfstate"
    ```

    이렇게 하면 S3 키가 `04-backends/dev` 아래의 경로로 설정됩니다.

4. 'prod.tfbackend'라는 파일을 만듭니다. 이 파일은 프로덕션 환경에 대한 부분적인 백엔드 구성을 제공합니다. prod.tfbackend` 파일에 다음을 추가합니다:

    ```
    key = "04-backends/prod/state.tfstate"
    ```

    이렇게 하면 S3 키가 `04-backends/prod` 아래의 경로로 설정됩니다.

5. 테라폼에 백엔드 파일을 전달합니다. 명령줄 인수로 전달하여 Terraform이 사용할 백엔드 구성 파일을 지정할 수 있습니다. 예를 들어 개발 백엔드를 사용하려면 다음 명령을 실행합니다:

    `terraform init -backend-config=dev.tfbackend`

    마찬가지로 프로덕션 백엔드를 사용하려면 실행합니다:

    `terraform init -backend-config=prod.tfbackend`

    이렇게 하면 개발 환경인지 프로덕션 환경인지에 따라 Terraform이 올바른 상태 파일을 사용할 수 있습니다.

    지금 바로 사용해 보세요! 이 단계를 수행하면 S3 백엔드가 Terraform용으로 구성되고 개발 및 프로덕션용 백엔드 구성 파일이 별도로 생성되어 S3 버킷의 서로 다른 경로에 상태를 저장하게 됩니다.

6. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 성공적으로 완료해 주셔서 감사합니다! 여러분은 Terraform에서 다양한 환경에 맞는 다양한 백엔드 구성을 설정하고 관리하는 방법을 배웠습니다. 이러한 지식은 효율적인 인프라 관리 및 배포에 매우 중요합니다. 앞으로도 계속 잘 부탁드립니다!
