# Operators in Terraform

## Introduction

이 연습에서는 Terraform에서 사용할 수 있는 다양한 연산자를 살펴보겠습니다. 이 연습에는 수학, 등호, 비교, 논리 연산자 작업이 포함됩니다. 이러한 연산자를 가지고 놀면서 그 동작을 관찰할 수 있는 기회를 갖게 되며, 이를 통해 향후 더 복잡한 Terraform 구성을 작성할 수 있는 탄탄한 기초를 다질 수 있습니다. 시작해 봅시다!

## Step-by-Step Guide

1. 로컬 블록을 만들고 Terraform에서 사용할 수 있는 수학 연산자를 가지고 놀아보세요: `*, /, +, -, -<number>`. 이 연산자들의 동작은 매우 간단하므로 여기서 살펴볼 내용은 많지 않습니다.
2. 두 값이 같은지 아닌지 확인하는 데 사용할 수 있는 등호 연산자 `==`와 `!=`를 사용해 보세요.
3. 비교 연산자도 사용할 수 있습니다: `<, <=, >, >=`. 한번 사용해 보세요!
4. 마지막으로 논리 연산자 `&&`, `||`, `!`를 사용해 보세요.

    ```
    locals {
      math       = 2 * 2
      equality   = 2 != 2
      comparison = 2 < 1
      logical    = true || false
    }
    ```

5. 이러한 로컬의 값을 출력하여 어떻게 보이는지 검사할 수도 있습니다. `“operators” output` 블록을 생성하고 `terraform plan` 명령을 실행하여 결과를 검사합니다.

    ```
    output "operators" {
      value = {
        math       = local.math
        equality   = local.equality
        comparison = local.comparison
        logical    = local.logical
      }
    }
    ```

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 테라폼 연산자를 마스터하는 데 한 걸음 더 나아갔습니다. 계속 연습하고 기술을 계속 발전시켜 보세요. 학습은 목적지가 아니라 여정이라는 것을 기억하세요. 계속 노력하세요!
