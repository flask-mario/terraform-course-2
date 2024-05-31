# Using a Remote S3 Backend

## Introduction

이 연습에서는 Terraform을 위한 S3 백엔드를 설정하는 단계를 안내해드리겠습니다. 이를 통해 Terraform 상태를 S3 버킷에 저장하여 안전한 원격 스토리지 솔루션을 제공할 수 있습니다. S3 백엔드를 설정하고 사용하는 방법을 이해하는 것은 Terraform 프로젝트를 관리하고 협업하는 데 매우 중요합니다. 시작해 보겠습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 상태 파일을 저장하는 데 사용되는 수동으로 생성된 S3 버킷으로, 고유한 이름을 지정하고 원하는 지역에 저장합니다.
2. 생성된 S3 버킷을 참조하고 상태 파일을 저장하기 위한 관련 키를 제공하여 Terraform 구성 파일에 구성된 S3 백엔드.
3. 테라폼이 S3 백엔드로 성공적으로 초기화되었습니다.
4. 테라폼 구성이 성공적으로 적용되고 상태가 S3 버킷에 저장되었습니다.

## Step-by-Step Guide

1. 먼저 테라폼 버전 1.7 이상이 설치되어 있는지 확인합니다. 터미널에서 `terraform version`을 실행하여 확인할 수 있습니다.
2. `03-first-tf-project` 폴더의 파일을 `04-backends`라는 새 폴더에 복사합니다.
3. 또한 AWS 및 Random 공급자를 설치해야 합니다. 이들은 `04-backends` 폴더 내에서 `terraform init` 명령을 실행하여 설치할 수 있습니다.
4. 다음으로 S3 버킷을 설정해야 합니다. 고유한 이름을 선택하고 버킷이 원하는 리전에 생성되었는지 확인합니다. AWS 콘솔을 통해 설정하거나 AWS CLI를 사용하여 설정할 수 있습니다.
5. 이제 Terraform 구성에서 S3 백엔드를 구성할 수 있습니다. 이것은 구성 파일의 `backend "s3"` 블록에서 수행됩니다. `<your-bucket-name>` 텍스트를 수동으로 생성한 버킷의 이름으로 바꾸고 `<your-aws-region>`을 코스에 사용 중인 각 리전으로 바꿉니다.
    ```
    backend "s3" {
      bucket = "<your-bucket-name>"
      key    = "04-backends/state.tfstate"
      region = "<your-aws-region>"
    }
    ```
6. `"aws"` 프로바이터 블록을 사용하여 AWS 제공자를 구성하고 프로젝트에 올바른 지역을 사용하는지 확인하세요.
7. 마지막으로 `terraform init`을 다시 실행합니다. 그러면 백엔드가 초기화됩니다. Terraform이 성공적으로 초기화되었고 백엔드 "s3"가 구성되었다는 메시지가 표시되어야 합니다.
8. 이제 `terraform apply`를 실행하여 구성을 적용할 수 있습니다. Terraform은 사용자가 구성한 S3 버킷에 상태를 저장합니다.
9. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! Terraform용 S3 백엔드를 설정하고 사용하는 방법을 이해하는 데 중요한 단계를 밟으셨습니다. 계속 열심히 하세요!
