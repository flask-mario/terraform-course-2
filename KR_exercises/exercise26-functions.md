# Working with Functions

## Introduction

이 실습에서는 테라폼에서 다양한 함수를 실제로 구현하는 방법을 살펴봅니다. 내장 함수를 사용해 데이터 유형을 조작하고 변환하는 방법을 살펴봅니다. 여기에는 문자열 함수, 수학적 계산, 파일 인코딩 및 디코딩 함수로 작업하는 것이 포함됩니다. 이 연습이 끝날 때쯤이면 Terraform 스크립트에서 이러한 함수를 효과적으로 활용하는 방법을 확실히 이해하게 될 것입니다.

## Step-by-Step Guide

1. `locals` 블록을 사용하여 몇 가지 로컬 변수를 정의하는 것으로 시작하세요. 합리적인 프리미티브 및 객체 값을 포함하는 `name`, `age`, `my_object`를 선언합니다.

    ```
    locals {
      name = "Lauro Müller"
      age  = 15
      my_object = {
        key1 = 10
        key2 = "my_value"
      }
    }
    ```

2. 또한 다음 내용으로 `users.yaml` 파일을 만듭니다:

    ```
    users:
    - name: Lauro
      group: developers
    - name: John
      group: auditors
    ```

3. `local.name`이 특정 값으로 시작하는지 확인하기 위해 `startswith` 함수를 사용하는 출력을 생성합니다. 대소문자를 구분하지 않고 비교하기 위해 어떤 함수를 사용할 수 있을까요?

    ```
    output "example1" {
      value = startswith(lower(local.name), "john")
    }
    ```

4. `pow` 함수를 사용하여 `local.age`의 제곱을 계산하는 또 다른 출력 블록을 만듭니다.

    ```
    output "example2" {
      value = pow(local.age, 2)
    }
    ```

5. `yamldecode` 함수를 사용하여 모듈 경로 내에 `users.yaml`이라는 이름의 생성된 YAML 파일을 디코딩하는 세 번째 출력 블록을 생성합니다. 각 객체의 `name` 속성만 포함된 목록을 출력합니다.

    ```
    output "example3" {
      value = yamldecode(file("${path.module}/users.yaml")).users[*].name
    }
    ```

6. 마지막으로 `jsonencode` 함수를 사용하여 `local.my_object`를 JSON 문자열로 변환하는 네 번째 출력 블록을 생성합니다.

    ```
    output "example4" {
      value = jsonencode(local.my_object)
    }
    ```

## Congratulations on Completing the Exercise!

이 연습을 잘 마쳤습니다! 다양한 테라폼 함수에 대한 실무 경험을 쌓고 데이터 유형을 조작하고 변환하는 기술을 향상시켰습니다. 계속 열심히 하세요!
