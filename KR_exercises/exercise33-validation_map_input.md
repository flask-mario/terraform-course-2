# 맵 변수에 유효성 검사 추가하기

## Introduction

이 연습에서는 Terraform에서 맵 변수에 유효성 검사를 추가하는 방법을 배웁니다. 유효성 검사는 구성이 특정 규칙을 준수하도록 하고 지원되지 않거나 원치 않는 구성의 사용을 방지할 수 있으므로 IaC(Infrastructure as Code)로 작업할 때 중요한 기술입니다. 특히 `t2.micro` 인스턴스만 사용하고 `ubuntu` 및 `nginx` 이미지만 사용하도록 유효성 검사를 추가할 예정입니다. 이 유효성 검사를 추가하는 방법에 대해 자세히 알아보세요!

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 아직 정의하지 않은 경우 변수를 정의합니다.
 `ec2_instance_config_map`.
    - This variable is a map of objects.
    - Each object contains `instance_type` and `ami`.
2. `t2.micro` 인스턴스만 사용되도록 유효성 검사를 추가합니다.
3. `ubuntu`와 `nginx` 이미지만 사용되도록 다른 유효성 검사를 추가합니다.

## Step-by-Step Guide

1. 변수가 `ec2_instance_config_map`이 정의되어 있고 각 객체가 `instance_type`과 `ami`를 포함하는 객체 맵 유형인지 확인합니다.

    ```
    variable "ec2_instance_config_map" {
      type = map(object({
        instance_type = string
        ami           = string
      }))
    }
    ```

2. 다음으로, `t2.micro` 인스턴스만 사용되도록 유효성 검사 블록을 추가합니다. `condition` 속성은 `alltrue` 함수를 사용하여 `ec2_instance_config_map`의 모든 인스턴스가 `t2.micro` 유형인지 확인합니다. 이 조건이 충족되지 않으면 Terraform은 `"Only t2.micro instances are allowed."`라는 오류 메시지를 반환합니다.

    ```
    validation {
      condition = alltrue([
        for config in values(var.ec2_instance_config_map) : contains(["t2.micro"], config.instance_type)
      ])
      error_message = "Only t2.micro instances are allowed."
    }
    ```

3. 마지막으로, 다른 유효성 검사 블록을 추가하여 `ubuntu` 및 `nginx` 이미지만 사용되도록 합니다. 여기서도 `condition` 속성은 `alltrue` 함수를 사용하여 `ec2_instance_config_map`의 모든 `ami`가 `ubuntu` 또는 `nginx`인지 확인합니다. 이 조건이 충족되지 않으면 Terraform은 적절한 오류 메시지를 반환합니다.

    ```
    validation {
      condition = alltrue([
        for config in values(var.ec2_instance_config_map) : contains(["nginx", "ubuntu"], config.ami)
      ])
      error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
    }
    ```

4. 이 단계를 수행한 후 필요한 유효성 검사가 수행된 `ec2_instance_config_list` 변수는 다음과 같이 보일 것입니다:

    ```
    variable "ec2_instance_config_map" {
      type = map(object({
        instance_type = string
        ami           = string
        subnet_name   = optional(string, "default")
      }))

      validation {
        condition = alltrue([
          for config in values(var.ec2_instance_config_map) : contains(["t2.micro"], config.instance_type)
        ])
        error_message = "Only t2.micro instances are allowed."
      }

      validation {
        condition = alltrue([
          for config in values(var.ec2_instance_config_map) : contains(["nginx", "ubuntu"], config.ami)
        ])
        error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
      }
    }
    ```

5. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 잘 마쳤습니다! 강력하고 안전한 코드형 인프라 구성을 유지하는 데 필수적인 기술인 Terraform에서 맵 변수에 유효성 검사를 추가하는 방법을 배웠습니다. 계속 열심히 공부하세요!
