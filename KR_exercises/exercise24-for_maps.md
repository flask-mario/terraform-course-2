# `for` Expression with Maps

## Introduction

이 실습에서는 Terraform에서 Map Type과 함께 `for` 표현식을 사용하는 방법을 살펴보겠습니다. 지도를 정의하고, 이 지도의 수정된 버전으로 구성된 로컬을 만들고, 결과를 출력하는 방법을 배웁니다. 이 연습을 통해 Terraform의 중요한 데이터 구조인 맵으로 작업하는 방법과 맵에서 작업을 수행하는 방법을 이해하는 데 도움이 될 것입니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. `map(number)` 타입의 변수 `numbers_map`을 생성합니다. 이것이 우리가 작업할 지도가 될 것입니다.
2. 로컬 `doubles_map`을 만듭니다. 이 로컬은 `numbers_map`의 각 키-값 쌍으로 구성되지만 각 값이 두 배가 됩니다.
3. 로컬 `even_map`을 생성합니다. 이 로컬은 `numbers_map`의 각 키-값 쌍으로 구성되지만 값이 짝수인 경우에만 구성됩니다. 각 값도 두 배로 늘려야 합니다.
4. `doubles_map`과 `even_map`의 결과를 출력합니다. `terraform plan` 명령을 실행하면 이러한 출력을 시각화할 수 있습니다.

## Step-by-Step Guide

1. 먼저 `map(number)` 타입의 변수 `numbers_map`을 정의합니다. 이것이 우리가 작업할 지도가 될 것입니다.

    ```
    variable "numbers_map" {
      type = map(number)
    }
    ```

2. 다음으로 로컬 `doubles_map`을 만듭니다. for 루프를 사용하여 `numbers_map`의 각 키-값 쌍을 반복합니다. 각 쌍에 대해 값이 두 배가 되는 새로운 키-값 쌍을 생성합니다.

    ```
    locals {
      doubles_map = { for key, value in var.numbers_map : key => value * 2 }
    }
    ```

3. 또한 로컬 `even_map`을 만듭니다. 다시, for 루프를 사용하여 `numbers_map`의 각 키-값 쌍을 반복합니다. 하지만 이번에는 값이 짝수인 새로운 키-값 쌍만 생성하고 값도 두 배로 늘립니다.

    ```
    locals {
      doubles_map = { for key, value in var.numbers_map : key => value * 2 }
      even_map = { for key, value in var.numbers_map : key =>
        value * 2 if value % 2 == 0
      }
    }
    ```

4. 마지막으로 `doubles_map`과 `even_map`의 결과를 출력합니다. `terraform plan` 명령을 실행하여 결과를 시각화합니다.

    ```
    output "doubles_map" {
      value = local.doubles_map
    }

    output "even_map" {
      value = local.even_map
    }
    ```

위 코드에서 Terraform의 for 루프는 맵을 반복하고 연산을 수행하는 데 활용되었습니다. for 루프는 데이터 구조를 변환하고 복잡한 연산을 수행하는 데 사용할 수 있는 Terraform의 강력한 도구입니다.

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 맵을 정의하고, 이 맵의 수정된 버전으로 구성된 로컬을 만들고, 결과를 출력하는 방법을 포함하여 Terraform에서 맵으로 작업하는 방법을 배웠습니다. 이러한 기술은 인프라를 코드로 관리하는 데 매우 중요하므로 계속 연습하세요. 계속 노력하세요!
