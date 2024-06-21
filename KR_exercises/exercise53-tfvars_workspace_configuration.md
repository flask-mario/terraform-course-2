# `.tfvars` 파일을 사용하여 워크스페이스 구성 저장하기

## Introduction

이 실습에서는 `.tfvars` 파일을 사용하여 작업 공간별 구성을 Terraform에 저장하는 방법을 배웁니다. 워크스페이스마다 다른 `.tfvars` 파일을 생성하고 이를 인프라 관리에 적용하는 방법을 배워보겠습니다. 이 방법을 사용하면 사용 중인 워크스페이스에 따라 구성을 쉽게 확장하고 수정할 수 있습니다. 이 연습에서는 이 전략을 구현하는 단계를 안내합니다.

## Step-by-Step Guide

1. 배포할 버킷의 개수를 받을 숫자 타입의 새 변수 `bucket_count`를 정의합니다.
2. workspace에 대해 각각 3개의 `.tfvars` 파일을 만듭니다. 파일 이름이 `<workspace name>.tf`와 일치하는지 확인합니다. 각 파일에 워크스페이스당 배포할 버킷의 정확한 개수로 변수를 정의합니다.

    ```
    # dev.tfvars

    bucket_count = 1

    ---

    # staging.tfvars

    bucket_count = 2

    ---

    # prod.tfvars

    bucket_count = 3
    ```

3. `terraform apply -var-file=$(terraform workspace show).tfvars`를 실행하면 현재 작업 공간을 활용하여 올바른 `.tfvars` 파일을 찾습니다. 이 명령은 선택한 작업 공간과 관계없이 동일하게 유지되므로 이 명령에 별칭을 만들어 사용하면 더 쉽게 사용할 수 있습니다.
4. `int`라는 이름의 워크스페이스와 해당 `int.tfvars` 파일을 생성하여 새 워크스페이스를 수용하도록 구성을 확장합니다. bucket_count에 적절한 값을 전달하고, `-var-file` 옵션이 올바르게 전달되었는지 확인하면서 `terraform apply` 명령을 다시 실행합니다. 보시다시피, 이 접근 방식을 사용하면 기본 Terraform 코드를 건드리지 않고도 구성을 쉽게 확장할 수 있습니다.

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 테라폼에서 작업 공간별 구성을 위한 `.tfvars` 파일 사용을 마스터하기 위한 큰 발걸음을 내디뎠습니다. 계속 열심히 하세요!
