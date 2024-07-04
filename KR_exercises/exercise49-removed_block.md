# Terraform에서 인프라 제거하기

## Introduction

이 연습에서는 Terraform에서 인프라를 제거하는 방법을 탐색합니다. 이 과정은 S3 버킷을 생성하고, CLI를 사용하여 Terraform 구성에서 제거한 다음 다시 가져오는 과정을 포함합니다. 또한 `removed` 블록과 그 기능을 실험해 볼 것입니다. 이 연습은 Terraform이 리소스 관리와 리소스 제거를 처리하는 방식에 대한 이해를 높이기 위해 설계되었습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:


1. Terraform에서 새로운 S3 버킷을 생성합니다.
2. CLI 방식을 사용하여 Terraform 설정으로 S3 버킷을 제거합니다.
3. 버킷을 다시 Import하고 리소스를 형상관리 대상에서 제외하기 위해 `removed` 블록을 사용해 봅니다.


## Step-by-Step Guide

1. 이제 어떻게 하면 테라폼이 객체를 잊어버리고 그 구성 추적을 멈추게 할 수 있는지 살펴봅시다. 이 방법은 오브젝트를 유지하되 특정 테라폼 구성에서 제거하고자 할 때 유용합니다.
2. `remove.tf`라는 새 파일을 추가하고 파일 안에 새 S3 버킷을 생성합니다.

    ```
    resource "aws_s3_bucket" "my_bucket" {
      bucket = "random-name-<some random string>"
    }
    ```

3. 먼저 CLI 방식을 시도해 봅시다. `terraform state rm -dry-run aws_s3_bucket.my_bucket` 명령을 실행합니다. 이 명령은 Terraform이 잊을 것을 실제로 잊지 않고 보여줍니다. `-dry-run` 옵션 없이 명령을 다시 실행합니다. 이렇게 하면 Terraform 설정에서 리소스가 제거됩니다.

4. 파일에서 S3 버킷 리소스 블록을 삭제하거나 주석 처리하고 `terraform apply`를 실행하여 아무것도 삭제되지 않는지 확인합니다. 버킷은 여전히 존재하지만 이제 설정으로 추적되지 않습니다.


5. 버킷 리소스 블록을 추가하거나 주석 처리를 해제하고 리소스를 설정으로 가져옵니다.


6. 이제 `removed` 블록을 사용해 보겠습니다. 다음 코드를 `remove.tf` 파일에 추가하세요. S3 버킷 코드를 주석 처리하고 `terraform plan`을 실행하세요.


    ```
    removed {
      from = aws_s3_bucket.my_new_bucket

      lifecycle {
        destroy = true
      }
    }
    ```


7. `destroy` 플래그를 `false`로 변경하고 `terraform plan`을 다시 실행해보세요. 이전에 `destroy`가 `true`로 설정된 경우와 어떻게 다른지 확인해보세요.


## Congratulations on Completing the Exercise!

이 연습을 완료하신 것을 축하드립니다! Terraform이 리소스 관리와 리소스 제거를 처리하는 방식에 대한 이해를 높이는 중요한 한 걸음을 내디뎠습니다. 좋은 작업을 계속해주세요!
