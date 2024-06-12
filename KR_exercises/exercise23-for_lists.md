# `for` Expression with Lists

## Introduction

이 연습에서는 테라폼을 사용해 목록의 데이터를 조작하고 분석하는 방법을 배웁니다. 숫자 목록과 개체 목록으로 작업하고 특정 특성을 가진 새로운 목록을 만들어 보겠습니다. 이 실습을 통해 테라폼의 강력한 목록 조작 기능에 대한 이해를 높이고 프로젝트에 활용할 수 있습니다. 그럼 시작해 봅시다!

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 두 개의 변수, `numbers_list`와 `objects_list`를 생성합니다. `numbers_list`의 유형은 숫자 목록이고 `objects_list`의 유형은 객체 목록으로, 각각 `firstname` 및 `lastname` 속성을 문자열로 포함합니다.
2. `double_numbers`라는 이름의 로컬을 생성합니다. 이 로컬에는 `numbers_list`의 숫자 목록이 각각 두 배로 포함됩니다.
3. `even_numbers`라는 로컬을 만듭니다. 이 로컬에는 `numbers_list`의 짝수 숫자 목록만 포함됩니다.
4. `firstnames`이라는 로컬을 만듭니다. 이 로컬에는 `objects_list`의 모든 이름 목록이 포함됩니다.
5. `fullnames`이라는 로컬을 만듭니다. 이 로컬에는 `objects_list`의 이름과 성이 연결된 목록이 포함됩니다.

## Step-by-Step Guide

1. 먼저 `numbers_list`와 `objects_list`라는 두 변수를 정의합니다. `numbers_list` 유형은 숫자 목록이고 `objects_list` 유형은 객체 목록으로, 각각 `firstname` 및 `lastname` 속성을 문자열로 포함합니다.

    ```
    variable "numbers_list" {
      type = list(number)
    }

    variable "objects_list" {
      type = list(object({
        firstname = string
        lastname  = string
      }))
    }
    ```

2. 변수 `numbers_list`를 반복하여 모든 요소의 두 배가 된 값을 포함하는 새 목록을 생성하는 `local.double_numbers` 항목을 만듭니다.

    ```
    locals {
      double_numbers = [for num in var.numbers_list : num * 2]
    }
    ```

3. 이제 `numbers_list` 변수를 반복하여 짝수만 포함하는 새 목록을 생성하는 `local.even_numbers` 항목을 만듭니다.

    ```
    locals {
      double_numbers = [for num in var.numbers_list : num * 2]
      even_numbers   = [for num in var.numbers_list : num if num % 2 == 0]
    }
    ```

4. 이제 `objects_list` 변수를 반복하여 각 요소의 `firstname` 속성 값만 포함하는 새 목록을 생성하는 `local.firstnames` 항목을 생성합니다.

    ```
    locals {
      double_numbers = [for num in var.numbers_list : num * 2]
      even_numbers   = [for num in var.numbers_list : num if num % 2 == 0]
      firstnames     = [for person in var.objects_list : person.firstname]
    }
    ```

5. 마지막으로 `local.fullnames` 항목을 생성하여 `objects_list` 변수를 반복하고 `firstname` 및 `lastname` 속성의 연결된 값을 포함하는 새 목록을 만듭니다.

    ```
    locals {
      double_numbers = [for num in var.numbers_list : num * 2]
      even_numbers   = [for num in var.numbers_list : num if num % 2 == 0]
      firstnames     = [for person in var.objects_list : person.firstname]
      fullnames = [
        for person in var.objects_list : "${person.firstname} ${person.lastname}"
      ]
    }
    ```

6. 출력을 사용하여 로컬 블록의 값을 출력하고 `terraform plan`을 실행하여 결과를 시각화합니다.

    ```
    output "double_numbers" {
      value = local.double_numbers
    }

    output "even_numbers" {
      value = local.even_numbers
    }

    output "firstnames" {
      value = local.firstnames
    }

    output "fullnames" {
      value = local.fullnames
    }
    ```

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 테라폼을 사용하여 목록의 데이터를 조작하고 분석하는 능력이 상당히 향상되었습니다! 앞으로도 계속 열심히 하셔서 테라폼 실력을 계속 향상시키세요. 계속 연습하고 즐겁게 배우세요!
