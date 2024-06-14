# 목록 변수에 유효성 검사 추가하기

## Introduction

이 실습에서는 Terraform에서 EC2 인스턴스 구성 목록에 유효성 검사를 추가하는 방법을 배웁니다. 여기서는 `ec2_instance_config_list` 변수를 정의하고 `t2.micro` 인스턴스와 `ubuntu` 또는 `nginx` 이미지만 사용되도록 유효성 검사를 추가하는 데 초점을 맞출 것입니다. 이 연습에서는 이러한 유효성 검사를 구현하는 방법을 단계별로 안내합니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 아직 정의하지 않은 경우 variable를 정의합니다.  `ec2_instance_config_list`.
    - This variable is a list of objects.
    - Each object contains `instance_type` and `ami`.
2. `t2.micro` 인스턴스만 사용되도록 유효성 검사를 추가합니다.
3. `ubuntu` 및 `nginx` 이미지만 허용되도록 다른 유효성 검사를 추가합니다.

## Step-by-Step Guide

1. 변수 `ec2_instance_config_list`가 정의되어 있고 각 객체가 `instance_type`과 `ami`를 포함하는 객체 목록 유형인지 확인합니다.

    ```
    variable "ec2_instance_config_list" {
      type = list(object({
        instance_type = string
        ami           = string
      }))

      default = []
    }
    ```

2. 다음으로 `t2.micro` 인스턴스만 사용되도록 유효성 검사 블록을 추가합니다. `condition` 속성은 `alltrue()` 함수를 사용하여 `ec2_instance_config_list`의 모든 인스턴스가 `t2.micro` 유형인지 확인합니다. 이 조건이 충족되지 않으면 Terraform은 `"Only t2.micro instances are allowed."`라는 오류 메시지를 반환합니다.

    ```
    validation {
      condition = alltrue([
        for config in var.ec2_instance_config_list : contains(["t2.micro"], config.instance_type)
      ])
      error_message = "Only t2.micro instances are allowed."
    }
    ```

3. 마지막으로, 다른 유효성 검사 블록을 추가하여 `ubuntu` 및 `nginx` 이미지만 사용되도록 합니다. 다시 말하지만, `condition` 속성은 `alltrue` 함수를 사용하여 `ec2_instance_config_list`의 모든 `ami`가 `ubuntu` 또는 `nginx`인지 확인합니다. 이 조건이 충족되지 않으면 Terraform은 적절한 오류 메시지를 반환합니다.

    ```
    validation {
      condition = alltrue([
        for config in var.ec2_instance_config_list : contains(["nginx", "ubuntu"], config.ami)
      ])
      error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
    }
    ```

4. 이 단계를 수행한 후 필요한 유효성 검사가 수행된 `ec2_instance_config_list` 변수는 다음과 같이 보일 것입니다:

    ```
    variable "ec2_instance_config_list" {
      type = list(object({
        instance_type = string
        ami           = string
      }))

      default = []

      validation {
        condition = alltrue([
          for config in var.ec2_instance_config_list : contains(["t2.micro"], config.instance_type)
        ])
        error_message = "Only t2.micro instances are allowed."
      }

      validation {
        condition = alltrue([
          for config in var.ec2_instance_config_list : contains(["nginx", "ubuntu"], config.ami)
        ])
        error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
      }
    }
    ```

5. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 성공적으로 완료한 것을 축하드립니다! 이제 Terraform에서 EC2 인스턴스 구성 목록에 대한 유효성 검사 추가를 마스터하셨습니다. 이는 Terraform 구성의 정확성과 안정성을 보장하는 데 도움이 되는 귀중한 기술입니다. 계속 열심히 하세요!
