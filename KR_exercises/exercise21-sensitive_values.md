# Working with Sensitive Values

## Introduction

이 실습에서는 Terraform에서 민감한 값을 처리하는 프로세스를 살펴보겠습니다. 특정 값을 민감한 값으로 설정하는 방법과 해당 값을 검색하는 방법을 배웁니다. 또한 민감한 값 설정의 의미와 해당 값이 Terraform에서 출력하는 로그에 미치는 영향을 이해합니다. 이 실습을 통해 인프라 관리의 중요한 측면인 민감한 데이터 작업에 대한 실질적인 이해를 얻을 수 있습니다.

## Step-by-Step Guide

1. output 블록에 `sensitive = true`를 추가하여 `s3_bucket_name`을 민감하게 설정하는 것으로 시작하겠습니다.

    ```
    output "s3_bucket_name" {
      value       = aws_s3_bucket.project_bucket.bucket
      sensitive   = true
      description = "The name of the S3 bucket"
    }
    ```

2. `terraform output s3_bucket_name`으로 출력 값을 검색합니다. 보시다시피, 민감하게 설정된 출력의 값을 검색하는 데 아무런 문제가 없습니다.
3. 민감한 값이 포함된 `my_sensitive_value`라는 변수를 생성하고 `sensitive_var`라는 출력에 이를 직접 반영합니다:

    ```
    variable "my_sensitive_value" {
      type      = string
      sensitive = true
    }

    output "sensitive_var" {
      sensitive = true   # We must set this to true since the variable is sensitive!
      value     = var.my_sensitive_value
    }
    ```

4. 이전 강의에서 생성한 `local.common_tags` 객체에 `my_sensitive_value`를 사용하여 새 태그를 생성합니다. 테라폼이 출력하는 로그는 어떻게 되나요?

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 테라폼에서 민감한 값을 처리하는 방법을 이해하는 데 중요한 한 걸음을 내디뎠습니다. 앞으로도 계속 노력하세요!
