# list를 map으로 또는 그 반대로 변환하기

## Introduction

이 실습에서는 Terraform에서 list를 Map으로 변환하거나 그 반대로 변환하는 방법을 살펴보겠습니다. 이 지식은 복잡한 데이터 구조를 관리하고 데이터를 효율적으로 검색하고 조작하는 데 매우 중요합니다. 이 연습은 `users` 목록 변수를 만들고, 이 목록을 `users_map`으로 변환한 다음, 그 맵을 다시 목록으로 변환하는 과정을 안내하는 세부 단계로 나뉘어져 있습니다. 연습이 끝나면 Terraform에서 list와 Map으로 작업하는 방법을 잘 이해하게 될 것입니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 각 객체에 `username`과 `role` 속성을 포함하는 객체 목록을 수신하는 `users` 변수를 만듭니다.
2. `var.users` 목록을 맵으로 변환하여 `username` 속성이 맵의 키가 되고 `role` 속성이 값이 되는 `users_map` 로컬을 만듭니다.
    1. 또한 `users_map` 로컬은 중복된 사용자 아이디를 처리하고 사용자 아이디가 `users` 변수에 두 번 이상 나타날 때마다 역할 목록을 반환해야 합니다.
3. ` local.users_map`을 다음 구조의 새 맵으로 변환하는 `users_map2` 로컬을 만듭니다: `<key> => { roles = <roles list> }`.
4. `users_map2` 로컬에서 특정 사용자의 정보를 검색하는 데 사용되는 문자열을 수신하는 `user_to_output` 변수를 만듭니다.
5. `local.users_map` 맵을 각 맵 항목의 사용자 이름만 포함하는 목록으로 변환하는 `usernames_from_map` 로컬을 생성합니다.
6. 지금까지 처리한 정보를 시각화하기 위해 output을 정의합니다.

## Step-by-Step Guide

1. 먼저 객체의 목록 유형인 `users`라는 변수를 정의하고, 각 객체에는 `username`과 `role` 속성이 포함됩니다.

    ```
    variable "users" {
      type = list(object({
        username = string
        role     = string
      }))
    }
    ```

2. 이제 로컬 `users_map`을 생성하여 `var.users` 목록을 맵으로 변환하고 `username` 속성이 맵의 키가 되고 `role` 속성이 값이 되는 맵을 만듭니다. 목록에 동일한 사용자명이 포함된 항목이 두 개 이상 있으면 어떻게 될까요?

    ```
    locals {
      users_map = {
        for user_info in var.users : user_info.username => user_info.role
      }
    }
    ```

3. 중복된 키가 있으면 오류가 발생합니다. `user_info.role` 끝에 줄임표 연산자를 사용하여 동일한 맵 키 아래에 있는 단일 `username`에 대한 모든 역할을 그룹화합니다.

    ```
    locals {
      users_map = {
        for user_info in var.users : user_info.username => user_info.role...
      }
    }
    ```

4. `<key> => { roles = <roles list> }`구조를 가진 새 맵으로 `local.users_map`을 변환하는 새 로컬을 만듭니다.

    ```
    locals {
      users_map2 = {
        for username, roles in local.users_map : username => {
          roles = roles
        }
      }
    }
    ```

5. 문자열 타입의 `user_to_output` 변수를 생성합니다. 이 변수는 `users_map2` 로컬에서 특정 사용자의 정보를 검색하는 데 사용됩니다.

    ```
    variable "user_to_output" {
      type = string
    }
    ```

6. 지금까지 처리한 정보를 시각화할 수 있는 몇 가지 출력을 정의합니다. `terraform plan`을 실행하여 변경 사항을 시각화합니다.

    ```
    output "users_map" {
      value = local.users_map
    }

    output "users_map2" {
      value = local.users_map2
    }

    output "user_to_output_roles" {
      value = local.users_map2[var.user_to_output].roles
    }
    ```

7. 마지막으로, `local.users_map` 맵을 각 맵 항목의 사용자 이름만 포함하는 목록으로 변환하는 로컬을 만듭니다. 정보를 표시할 새 출력을 만들고 `terraform plan`을 실행하여 결과를 시각화합니다.

    ```
    locals = {
      usernames_from_map = [for username, roles in local.users_map : username]
      # We can also use usernames_from_map = keys(local.users_map) instead of manually creating the list!
    }

    output "usernames_from_map" {
      value = local.usernames_from_map
    }
    ```

## Congratulations on Completing the Exercise!

이 어려운 연습을 완료해 주셔서 정말 수고하셨습니다! 열심히 노력하여 목록을 맵으로, 맵을 목록으로 변환하는 방법을 테라폼에서 배웠습니다. 이 기술은 복잡한 데이터 구조를 관리하고 데이터를 효율적으로 검색하고 조작하는 데 큰 도움이 될 것입니다. 계속 연습하여 지식을 계속 넓혀 나가세요. 계속 노력하세요!
